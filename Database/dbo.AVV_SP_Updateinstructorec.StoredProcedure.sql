USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Updateinstructorec]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Updateinstructorec]
@instructorcode varchar(50),
@instructor_fn varchar(100) = null,
@instructor_ln varchar(100) = null,
@instructor_mi varchar(50) = null,
@email varchar(50) = null,
@password varchar(250) = null
AS

If exists (Select 1 from instructorrec where instructorcode = @instructorcode)
begin
	update instructorrec
	set 
		instructor_fn = coalesce(@instructor_fn, instructor_fn),
		instructor_ln = coalesce(@instructor_ln, instructor_ln),
		instructor_mi = coalesce(@instructor_mi, instructor_mi),
		email = coalesce(@email, email),
		password = coalesce(@password, password)
	where instructorcode = @instructorcode;
end
GO
