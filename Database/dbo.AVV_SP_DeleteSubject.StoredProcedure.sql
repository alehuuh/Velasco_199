USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_DeleteSubject]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_DeleteSubject]
@classcode varchar(50) = null
AS

declare @subjectcode varchar(50)
set @subjectcode = (select subjectcode from subjects where classcode = @classcode)


If exists (Select 1 from subjects where subjectcode = @subjectcode)
begin
	delete subjects where subjectcode = @subjectcode
end

If exists (Select 1 from student_subject where subjectcode = @subjectcode)
begin
	delete student_subject where subjectcode = @subjectcode
end

If exists (Select 1 from subject_instructor where subjectcode = @subjectcode)
begin
	delete subject_instructor where subjectcode = @subjectcode
end

If exists (Select 1 from subject_sched where subjectcode = @subjectcode)
begin
	delete subject_sched where subjectcode = @subjectcode
end
GO
