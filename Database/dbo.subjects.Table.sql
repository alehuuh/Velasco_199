USE [Attendance_Monitoring]
GO
/****** Object:  Table [dbo].[subjects]    Script Date: 5/23/2025 10:14:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[subjects](
	[subjectcode] [varchar](50) NOT NULL,
	[description] [varchar](100) NULL,
	[section] [varchar](50) NULL,
	[classcode] [int] NULL,
 CONSTRAINT [PK_courses] PRIMARY KEY CLUSTERED 
(
	[subjectcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
