USE [Attendance_Monitoring]
GO
/****** Object:  StoredProcedure [dbo].[AVV_SP_Subjects_Instructors]    Script Date: 5/23/2025 10:14:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AVV_SP_Subjects_Instructors]
    @instructorcode VARCHAR(50)
AS
BEGIN
    WITH CombinedSchedules AS (
        SELECT 
            T0.subjectcode, 
            T0.description, 
            T2.sched_time_from,
            T2.sched_time_to,
			T2.section,
			T2.classcode,
            STRING_AGG(
                CASE 
                    WHEN T2.sched_days = 'Monday' THEN 'M'
                    WHEN T2.sched_days = 'Tuesday' THEN 'T'
                    WHEN T2.sched_days = 'Wednesday' THEN 'W'
                    WHEN T2.sched_days = 'Thursday' THEN 'Th'  -- ✅ Corrected for Thursday
                    WHEN T2.sched_days = 'Friday' THEN 'F'
                    WHEN T2.sched_days = 'Saturday' THEN 'S'
                    WHEN T2.sched_days = 'Sunday' THEN 'Su'
                END, ''
            ) AS GroupedDays
        FROM subjects T0
        INNER JOIN subject_instructor T1 ON T0.subjectcode = T1.subjectcode
        INNER JOIN subject_sched T2 ON T0.subjectcode = T2.subjectcode
        WHERE T1.instructorcode = @instructorcode
        GROUP BY T0.subjectcode, T0.description, T2.section, T2.classcode, T2.sched_time_from, T2.sched_time_to
    )
    SELECT 
		classcode,
        subjectcode,
        description,
		section,
        STRING_AGG(
            CONCAT(
                GroupedDays, -- MWF
                ' ',
                RIGHT(CONVERT(VARCHAR, sched_time_from, 100), 7), -- 3:30AM
                '-',
                RIGHT(CONVERT(VARCHAR, sched_time_to, 100), 7) -- 6:30AM
            ), '; ' -- Separate different schedules with ;
        ) AS Schedule
    FROM CombinedSchedules
    GROUP BY classcode, subjectcode, description, section;
END
GO
