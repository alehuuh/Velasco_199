USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Addsubject_instructor]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Addsubject_instructor]
@subjectinstructorcode varchar(50),
@subjectcode varchar(50),
@instructorname varchar(100)
AS

Declare @instructorcode varchar(100);

Select @instructorcode = instructorcode from instructorrec where @instructorname = instructor_ln + ', ' + instructor_fn + ' '

if @instructorcode is not null
begin
Insert into subject_instructor (subjectinstructorcode, subjectcode, instructorcode) 
	values (@subjectinstructorcode, @subjectcode, @instructorcode)
end
GO
