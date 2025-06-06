USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Attendance]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Attendance]
    @instructorcode VARCHAR(50) NULL,
    @subjectcode VARCHAR(50) = NULL,
    @studentname VARCHAR(100) = NULL,
    @datestamp VARCHAR(50) = NULL
AS

Select distinct  T5.instructorcode, T3.subjectcode, T1.studcode, T1.studfname + ' ' + T1.studlname as studname, T3.description/*, T4.sched_days*/, T4.sched_time_from, T4.sched_time_to
,(Select top 1 timestamp from DeviceLogs where transValue = '1' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date) ) as timein
,(Select top 1 timestamp from DeviceLogs where transValue = '2' and rfid = T0.rfid and cast(timeStamp as date) = cast(T0.timeStamp as date)order by timeStamp desc) as timeout
, 'Present' as Remarks,
T3.section
into #TempData
from DeviceLogs T0 inner join studentrec T1 on T0.rfid = T1.studrfid 
inner join student_subject T2 on T1.studcode = T2.studcode 
inner join subjects T3 on T2.subjectcode = T3.subjectcode and T0.classcode = T3.classcode
inner join subject_sched T4 on T2.subjectcode = T4.subjectcode
inner join subject_instructor T5 on T4.subjectcode = T5.subjectcode
inner join instructorrec T6 on T5.instructorcode = T6.instructorcode

WHERE (@instructorcode IS NULL OR T5.instructorcode = @instructorcode)
    AND (@subjectcode IS NULL OR T2.subjectcode = @subjectcode)
   AND (@datestamp IS NULL OR CAST(T0.timeStamp AS DATE) = @datestamp)
   AND /*CAST(T0.timeStamp AS TIME) >= sched_time_from and*/ CAST(T0.timeStamp AS TIME) <= sched_time_to 


Select distinct description, sched_time_from, sched_time_to into #Classes from #TempData


Select *, 
Case
				When timein is null then convert(date, timeout)
				Else  convert(date, timein)
				End Att_date
into #FinalList from #TempData

--Select * from #FinalList
--------------------


Select distinct description, sched_time_from, sched_time_to,
Case
				When timein is null then convert(date, timeout)
				Else  convert(date, timein)
				End Att_date
into #Schedlist from #TempData

select *,Case When timein is null then convert(date, timeout) Else  convert(date, timein) End Att_date into #TempDate_AttDate from #TempData

DECLARE @description varchar(50);
DECLARE @sched_time_from time(7);
DECLARE @sched_time_to time(7);
DECLARE @att_date date;

DECLARE SchedlistCursor CURSOR FOR
Select * from #Schedlist;

OPEN SchedlistCursor;

FETCH NEXT FROM SchedlistCursor INTO @description, @sched_time_from, @sched_time_to, @att_date;
WHILE @@FETCH_STATUS = 0
BEGIN
    Insert Into  #FinalList (instructorcode, subjectcode, studcode, studname, description, section, sched_time_to, timein, timeout, Remarks, Att_date) 
				
		(Select distinct T6.instructorcode, T3.subjectcode, T1.studcode, T1.studfname + ' ' + T1.studlname as studname, T3.description, T3.section, T4.sched_time_to
			,Null as timein
			,Null as timeout
			,'Absent' as Remarks
			, @att_date as Att_date

			from studentrec T1
			inner join student_subject T2 on T1.studcode = T2.studcode
			inner join subjects T3 on T2.subjectcode = T3.subjectcode 
			inner join subject_sched T4 on T2.subjectcode = T4.subjectcode
			inner join subject_instructor T5 on T4.subjectcode = T5.subjectcode
			inner join instructorrec T6 on T5.instructorcode = T6.instructorcode


			WHERE T3.description = @description
				AND T4.sched_time_from = @sched_time_from
				AND T4.sched_time_to = @sched_time_to
				AND T1.studcode not in (Select studcode from #TempDate_AttDate
											where description = @description
												and sched_time_from = @sched_time_from
												and sched_time_to = @sched_time_to
												and Att_date = @att_date
												)
		)
    -- Fetch the next row
    FETCH NEXT FROM SchedlistCursor INTO @description, @sched_time_from, @sched_time_to, @att_date;
END;

-- Close and deallocate the cursor
CLOSE SchedlistCursor;
DEALLOCATE SchedlistCursor;

Select * from #FinalList /* where att_date = N'05-01-2025' */ order by description, Att_date, instructorcode, sched_time_from, sched_time_to, studname
--------------------
GO
