USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_GetUpcomingClass]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Creating the procedure
CREATE PROCEDURE [dbo].[AVV_SP_GetUpcomingClass]
    @instructorcode VARCHAR(50),
	@datestamp VARCHAR(50)
AS

Select  T1.* from subjects T0 
inner join subject_sched T1 on T0.subjectcode = T1.Subjectcode
inner join subject_instructor T2 on T1.subjectcode = T2.subjectcode
where T2.instructorcode = @instructorcode and cast(@datestamp as time)< T1.sched_time_from and T1.sched_days = DATENAME(dw, @datestamp) 
GO
