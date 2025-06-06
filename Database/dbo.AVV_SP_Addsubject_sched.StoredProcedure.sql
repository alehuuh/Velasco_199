USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Addsubject_sched]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Addsubject_sched]
@schedcode varchar(50),
@subjectcode varchar(50),
@description varchar(100),
@sched_days varchar(50),
@sched_time_from time(7),
@sched_time_to time(7),
@section varchar(100)
AS
Insert into subject_sched (schedcode, subjectcode, description, sched_days, sched_time_from, sched_time_to, section) 
	values (@schedcode, @subjectcode, @description, @sched_days ,@sched_time_from, @sched_time_to, @section)


GO
