USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Updatestudent_subject]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Updatestudent_subject]
@studsubjectcode varchar(50),
@studcode varchar(50),
@subjectcode varchar(50)
AS

--declare @mcount int
--set @mcount = (select count(studsubjectcode) from student_subject)
--SET @studsubjectcode = 'SSub-' + RIGHT('000' + CAST(@mcount+1 AS VARCHAR), 3);

--If exists (Select 1 from student_subject where studcode = @studcode and subjectcode = @subjectcode)
If exists (Select 1 from student_subject where studcode = @studcode and subjectcode = @subjectcode)
begin
	update student_subject
	set 
		studcode = coalesce(@studcode, studcode),
		subjectcode = coalesce(@subjectcode, subjectcode)
	where studcode = @studcode and subjectcode = @subjectcode;
	RETURN 1
	--Delete from student_subject where subjectcode = @subjectcode;

	--WITH CTE AS (
	--	SELECT studsubjectcode, 
	--		   ROW_NUMBER() OVER (ORDER BY studsubjectcode) AS rn
	--	FROM student_subject
	--)
	--UPDATE CTE
	--SET studsubjectcode = 'SSub-' + RIGHT('000' + CAST(rn AS VARCHAR), 3);

	--Delete from student_subject where studcode = @studcode  and subjectcode = @subjectcode;
end
else begin
	Insert into student_subject(
		studsubjectcode, studcode, subjectcode)
	values(
		@studsubjectcode, @studcode, @subjectcode)

	RETURN 2
end


GO
