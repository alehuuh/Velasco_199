USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Addstudent_subject]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Addstudent_subject]
@studsubjectcode varchar(50),
@studcode varchar(50),
@subjectcode varchar(50)
AS
Insert into student_subject (studsubjectcode, studcode, subjectcode) 
	values (@studsubjectcode, @studcode, @subjectcode)


GO
