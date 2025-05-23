USE [Attendance_Monitoring]
GO
/****** Object:  Table [dbo].[DeviceLogs]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceLogs](
	[transId] [int] IDENTITY(1,1) NOT NULL,
	[deviceId] [varchar](50) NULL,
	[deviceName] [varchar](100) NULL,
	[deviceLoc] [varchar](50) NULL,
	[rfid] [varchar](50) NULL,
	[classCode] [varchar](50) NULL,
	[timeStamp] [datetime2](7) NULL,
	[transValue] [varchar](50) NULL,
	[ledger_start_transaction_id] [bigint] GENERATED ALWAYS AS transaction_id START HIDDEN NOT NULL,
	[ledger_start_sequence_number] [bigint] GENERATED ALWAYS AS sequence_number START HIDDEN NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[transId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
WITH
(
LEDGER = ON (APPEND_ONLY = ON, LEDGER_VIEW = [dbo].[DeviceLogs_Ledger] (TRANSACTION_ID_COLUMN_NAME = [ledger_transaction_id], SEQUENCE_NUMBER_COLUMN_NAME = [ledger_sequence_number], OPERATION_TYPE_COLUMN_NAME = [ledger_operation_type], OPERATION_TYPE_DESC_COLUMN_NAME = [ledger_operation_type_desc]))
)
GO
