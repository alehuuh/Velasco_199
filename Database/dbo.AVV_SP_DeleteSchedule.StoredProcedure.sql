USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_DeleteSchedule]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_DeleteSchedule]
@schedcode varchar(50) = null
AS

----declare @studcode varchar(50)
----set @studcode = (select studcode from studentrec where studnum = @studnum)

If exists (Select 1 from subject_sched where schedcode = @schedcode)
begin
	delete from subject_sched where schedcode = @schedcode
end
GO
