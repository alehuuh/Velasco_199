USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_DeleteStudent]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_DeleteStudent]
@studnum varchar(50) = null
AS

declare @studcode varchar(50)
set @studcode = (select studcode from studentrec where studnum = @studnum)

If exists (Select 1 from student_subject where @studcode = @studcode)
begin
	delete from student_subject where studcode = @studcode
end

If exists (Select 1 from studentrec where studcode = @studcode)
begin
	delete from studentrec where studcode = @studcode
end
GO
