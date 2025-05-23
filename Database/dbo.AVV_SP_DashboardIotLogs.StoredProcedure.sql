USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_DashboardIotLogs]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_DashboardIotLogs]
@timestamp date
AS

Select distinct T0.rfid, T1.studcode, T1.studfname + ' ' + T1.studlname as studname, T3.description, T6.instructor_fn + ' ' + T6.instructor_ln instructor, T4.sched_days, T4.sched_time_from, T4.sched_time_to
--, T0.timeStamp
,(Select top 1 timestamp from DeviceLogs where transValue = '1' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date) and cast(timeStamp as time)>= T4.sched_time_from and cast(timeStamp as time)<= T4.sched_time_to ) as timein
,(Select top 1 timestamp from DeviceLogs where transValue = '2' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date) and cast(timeStamp as time)>= T4.sched_time_from and cast(timeStamp as time)<= T4.sched_time_to order by timeStamp desc) as timeout
from DeviceLogs T0 inner join studentrec T1 on T0.rfid = T1.studrfid 
inner join student_subject T2 on T1.studcode = T2.studcode 
inner join subjects T3 on T2.subjectcode = T3.subjectcode 
inner join subject_sched T4 on T2.subjectcode = T4.subjectcode 
inner join subject_instructor T5 on T4.subjectcode = T5.subjectcode
inner join instructorrec T6 on T5.instructorcode = T6.instructorcode
where 
cast(T0.timeStamp as time)>= T4.sched_time_from and cast(T0.timeStamp as time)<= T4.sched_time_to and 
T4.sched_days = DATENAME(dw, @timestamp) and
cast(T0.timeStamp as date) = cast(@timeStamp as date)




GO
