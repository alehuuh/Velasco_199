USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Addinstructorec]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Addinstructorec]
@instructorcode varchar(50),
@instructor_fn varchar(100),
@instructor_ln varchar(100),
@instructor_mi varchar(50),
@email varchar(50),
@password varchar(250)
AS
Insert into instructorrec (instructorcode, instructor_fn, instructor_ln, email, password) 
	values (@instructorcode, @instructor_fn, @instructor_ln, @email, @password)


GO
