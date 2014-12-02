CREATE PROCEDURE [dbo].[Scheduling_Day_Of_Week_In_Month_Next_Instances_Get]      
(
  @User_Id INT,
  @Schedule_Key INT,
  @Days_To_Return INT,
  @Day_To_Schedule_After DATETIME
)
AS
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

-- Created: 08/07/14  ccdwyer
-- Purpose: Finds the next @Days_To_Return days that match the schedule, following @Day_To_Schedule_After
-- Used in: Scheduling_Next_Instances_Get

DECLARE
  @Day_Of_Week VARCHAR(15),
  @Instance INT,
  @Interval INT;
  
SELECT
  @Interval = S.Interval,
  @Instance = SWM.Day_Of_Week_Instance,
  @Day_Of_Week = 
    CASE
      WHEN SWM.Day_Of_Week = 1 THEN 'Sunday'
      WHEN SWM.Day_Of_Week = 2 THEN 'Monday'
      WHEN SWM.Day_Of_Week = 3 THEN 'Tuesday'
      WHEN SWM.Day_Of_Week = 4 THEN 'Wednesday'
      WHEN SWM.Day_Of_Week = 5 THEN 'Thursday'
      WHEN SWM.Day_Of_Week = 6 THEN 'Friday'
      WHEN SWM.Day_Of_Week = 7 THEN 'Saturday'
    END
FROM dbo.Schedule AS S
JOIN dbo.Schedule_Weekday_Of_Month AS SWM
  ON SWM.User_Id = S.User_Id
  AND SWM.Schedule_Key = S.Schedule_Key
WHERE S.User_Id = @User_Id
  AND S.Schedule_Key = @Schedule_Key;

WITH CTE_Dates AS
(
  SELECT TOP(@Days_To_Return * @Interval)
    C.Calendar_Date,
    ROW_NUMBER() OVER (ORDER BY C.Calendar_Key) AS Row_ID
  FROM dbo.Calendar AS C 
  WHERE C.Calendar_Date >= @Day_To_Schedule_After 
    AND C.Day_Of_Week = @Day_Of_Week 
    AND 
    (
      C.Instance_Of_Day = @Instance
      OR
      (
        @Instance = 5
        AND C.Is_Last_Instance = 1
      )
    )
  ORDER BY
    C.Calendar_Key
)
SELECT TOP(@Days_To_Return)
  C.Calendar_Date
FROM CTE_Dates AS C 
WHERE (@Interval = 1 OR C.Row_ID % @Interval = 1);

RETURN;