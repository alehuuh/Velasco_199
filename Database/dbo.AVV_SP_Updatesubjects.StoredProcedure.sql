USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Updatesubjects]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Updatesubjects]
@subjectcode varchar(50),
@description varchar(100) = null,
@section varchar(100) = null,
@classcode varchar(100) = null
AS

--Select @instructorcode = instructorcode from instructorrec where @instructorname = instructor_ln + ', ' + instructor_fn + ' '

If exists (Select 1 from subjects where classcode = @classcode)
begin
	update subjects
	set 
		description = coalesce(@description, description),
		section = coalesce(@section, section),
		classcode = coalesce(@classcode, classcode)
	where subjectcode = @subjectcode;
	RETURN 1
end
else begin
		insert into subjects (
			subjectcode, description, section, classcode)
		values (
			@subjectcode, @description, @section, @classcode)

	RETURN 2
end
GO
