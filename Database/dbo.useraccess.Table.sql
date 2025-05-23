USE [Attendance_Monitoring]
GO
/****** Object:  Table [dbo].[useraccess]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[useraccess](
	[accessid] [varchar](50) NOT NULL,
	[userid] [varchar](50) NULL,
	[moduleid] [varchar](50) NULL,
	[access] [bit] NOT NULL,
 CONSTRAINT [PK_useraccess] PRIMARY KEY CLUSTERED 
(
	[accessid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[useraccess] ADD  CONSTRAINT [DF_useraccess_access]  DEFAULT ((0)) FOR [access]
GO
