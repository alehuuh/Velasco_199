USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_GetClassSchedules]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Creating the procedure
CREATE PROCEDURE [dbo].[AVV_SP_GetClassSchedules]

AS

begin
Select T0.classcode, T0.description, T0.section, T0.sched_days, T0.sched_time_from, T0.sched_time_to, STRING_AGG(CONCAT(T2.instructor_ln, ', ', T2.instructor_fn), ', ') as Instructors
from subject_sched T0 inner join subject_instructor T1 on T0.subjectcode = T1.subjectcode
inner join instructorrec T2 on T1.instructorcode = T2.instructorcode
GROUP BY T0.classcode, T0.description, T0.section, T0.sched_days, T0.sched_time_from, T0.sched_time_to 
end
GO
