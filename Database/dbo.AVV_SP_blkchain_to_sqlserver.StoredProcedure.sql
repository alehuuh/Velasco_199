USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_blkchain_to_sqlserver]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_blkchain_to_sqlserver]
@deviceid varchar(100),
@devicename varchar(100),
@deviceloc varchar(100),
@rfid varchar(50),
@classcode varchar(50),
@timestamp datetime2,
@transValue varchar(50)
AS
	Insert into DeviceLogs (DeviceID, DeviceName, DeviceLoc, rfid, classCode, timeStamp, TransValue) 
		values (@deviceid, @devicename, @deviceloc, @rfid, @classcode, @timestamp, @transValue)	
	





GO
