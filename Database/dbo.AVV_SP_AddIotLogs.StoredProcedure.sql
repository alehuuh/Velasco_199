USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_AddIotLogs]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_AddIotLogs]
@deviceid varchar(100),
@devicename varchar(100),
@deviceloc varchar(100),
@rfid varchar(50),
@classcode varchar(50),
@timestamp datetime2,
@transvalue varchar(50)
AS

DECLARE @Interval int
DECLARE @Acceptable_Interval int
DECLARE @Logs_Reccount int
DECLARE @Transvalue_Count int
DECLARE @Interval_found int
SET @Acceptable_Interval = 2 /* 2 minutes */

---------- rfid for student record capture start ----------
if (select count(rfid) from rfid) = 0 
	insert into rfid (rfid) values (@rfid)
else
	update rfid set rfid = @rfid where id = 1
---------- rfid for student record capture end   ----------



/* CHECK if student/rfid has class on the current day and time */
select distinct T2.description, t3.sched_days, t3.sched_time_from, T3.sched_time_to into #studSched from studentrec T0
	inner join student_subject T1 on T0.studcode = T1.studcode 
	inner join subjects T2 on T1.subjectcode = T2.subjectcode 
	inner join subject_sched T3 on T2.subjectcode = T3.subjectcode where T0.studrfid = @rfid and T3.sched_days = DATENAME(dw, @timestamp)
	and (cast(@timestamp as time) >= t3.sched_time_from and cast(@timestamp as time) <= t3.sched_time_to)

/* CHECK if student/rfid has class on the current day and time */

/* CHECK if successive tap is greater than the interval allowed */

Set @Interval = (SELECT top 1 DATEDIFF(MINUTE, timeStamp, @timestamp) as interval FROM [Attendance_Monitoring].[dbo].[DeviceLogs] where timeStamp is not null and rfid = @rfid and transvalue = @transvalue  order by transId desc, timeStamp desc)
Set @Interval_found = (Select count(timestamp)  FROM [Attendance_Monitoring].[dbo].[DeviceLogs] where timeStamp is not null and rfid = @rfid and transvalue = @transvalue )
/* CHECK if successive tap is greater than the interval allowed */

Set @Logs_Reccount = (select count(rfid) from DeviceLogs)
Set @Transvalue_Count = (select count(rfid) from DeviceLogs where transValue = @transvalue)

IF ( (select count(description) from #studSched) > 0 and @Interval >= @Acceptable_Interval)
	or  @logs_Reccount = 0 or @Transvalue_Count = 0 or @Interval_found = 0 or @transvalue = 2 or @transvalue = 1
BEGIN
	Insert into DeviceLogs (DeviceID, DeviceName, DeviceLoc, rfid, classCode, timeStamp, TransValue) 
		values (@deviceid, @devicename, @deviceloc, @rfid, @classcode, @timestamp, @transValue)	
	
	SELECT * FROM DeviceLogs WHERE transId = SCOPE_IDENTITY()
	RETURN 1  /* Successful */
END

IF (select count(description) from #studSched) = 0 
	RETURN -1 /*Not enrolled on the current class schedule or no current class schedule */ 

IF @Interval <= @Acceptable_Interval
	RETURN -2 /*Duplicate Tap - did not exceed the acceptable tap interval */ 


return -5


GO
