USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_GetStudentsByClass_Admin]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Creating the procedure
CREATE PROCEDURE [dbo].[AVV_SP_GetStudentsByClass_Admin]
    @subjectcode VARCHAR(50)
AS
Select distinct T1.studlname + ', ' + T1.studfname + ' ' AS studname, T1.coursecode, T1.studnum
from student_subject T0 inner join studentrec T1 ON T0.studcode = T1.studcode
where T0.subjectcode = @subjectcode;
GO
