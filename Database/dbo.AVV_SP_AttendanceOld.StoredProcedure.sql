USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_AttendanceOld]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_AttendanceOld]
    @instructorcode VARCHAR(50),
    @subjectcode VARCHAR(50) = NULL,
    @studentname VARCHAR(100) = NULL,
    @datestamp VARCHAR(50) = NULL
AS

Select distinct T1.studcode, T1.studfname + ' ' + T1.studlname as studname, T3.description, T4.sched_days, T4.sched_time_from, T4.sched_time_to
--, T0.timeStamp
,(Select top 1 timestamp from DeviceLogs where transValue = '1' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date) ) as timein
,(Select top 1 timestamp from DeviceLogs where transValue = '2' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date)order by timeStamp desc) as timeout
, Case
	when (Select top 1 timestamp from DeviceLogs where transValue = '1' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date)) is not null 
		and (Select top 1 timestamp from DeviceLogs where transValue = '2' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date)order by timeStamp desc) is not null
	then 'Present'

	when (Select top 1 timestamp from DeviceLogs where transValue = '1' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date)) is null 
	then 'Absent'

	when (Select top 1 timestamp from DeviceLogs where transValue = '1' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date)) is not null 
		and (Select 1 timestamp from DeviceLogs where transValue = '2' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date)) is null
		and cast(T0.timeStamp as date) != cast(GETDATE() as date)
	then 'No Time Out'

	else NULL
end as Remarks
into #TempData
from DeviceLogs T0 inner join studentrec T1 on T0.rfid = T1.studrfid 
inner join student_subject T2 on T1.studcode = T2.studcode 
inner join subjects T3 on T2.subjectcode = T3.subjectcode 
inner join subject_sched T4 on T2.subjectcode = T4.subjectcode
inner join subject_instructor T5 on T4.subjectcode = T5.subjectcode
inner join instructorrec T6 on T5.instructorcode = T6.instructorcode

WHERE (@instructorcode IS NULL OR T5.instructorcode = @instructorcode)
    AND (@subjectcode IS NULL OR T2.subjectcode = @subjectcode)
    --AND ((T1.studfname + ' ' + T1.studlname) = @studentname)
    AND (@datestamp IS NULL OR CAST(T0.timeStamp AS DATE) = @datestamp) 
	AND (Datename(WEEKDAY, T0.timeStamp) = sched_days)


-------------------------------

UNION ALL

Select distinct T1.studcode, T1.studfname + ' ' + T1.studlname as studname, T3.description, T4.sched_days, T4.sched_time_from, T4.sched_time_to
,Null as timein
,Null as timeout

,'Absent' as Remarks

from studentrec T1
inner join student_subject T2 on T1.studcode = T2.studcode
inner join subjects T3 on T2.subjectcode = T3.subjectcode 
inner join subject_sched T4 on T2.subjectcode = T4.subjectcode
inner join subject_instructor T5 on T4.subjectcode = T5.subjectcode
inner join instructorrec T6 on T5.instructorcode = T6.instructorcode


WHERE (@instructorcode IS NULL OR T5.instructorcode = @instructorcode)
	AND (Datename(WEEKDAY, GETDATE()) = sched_days) /* get all student in a class on the current day */
	AND T1.studcode not in 
	
	-- filter student with no device log records for the current day
	(Select T1.studcode from DeviceLogs T0 inner join studentrec T1 on T0.rfid = T1.studrfid 
inner join student_subject T2 on T1.studcode = T2.studcode 
inner join subjects T3 on T2.subjectcode = T3.subjectcode 
inner join subject_sched T4 on T2.subjectcode = T4.subjectcode
inner join subject_instructor T5 on T4.subjectcode = T5.subjectcode
inner join instructorrec T6 on T5.instructorcode = T6.instructorcode
WHERE (@instructorcode IS NULL OR T5.instructorcode = @instructorcode)
    AND (@subjectcode IS NULL OR T2.subjectcode = @subjectcode)
    --AND ((T1.studfname + ' ' + T1.studlname) = @studentname)
    AND (@datestamp IS NULL OR CAST(T0.timeStamp AS DATE) = @datestamp) 
	AND (Datename(WEEKDAY, T0.timeStamp) = sched_days)
	)



Select distinct * from #TempData order by description, remarks desc, studname
GO
