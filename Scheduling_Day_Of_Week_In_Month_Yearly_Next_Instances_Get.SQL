CREATE PROCEDURE [dbo].[Scheduling_Day_Of_Week_In_Month_Yearly_Next_Instances_Get]      
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
  @Interval INT,
  @Month INT;
  
SELECT
  @Interval = S.Interval,
  @Instance = YDM.Day_Of_Week_Instance,
  @Day_Of_Week = 
    CASE
      WHEN YDM.Day_Of_Week = 1 THEN 'Sunday'
      WHEN YDM.Day_Of_Week = 2 THEN 'Monday'
      WHEN YDM.Day_Of_Week = 3 THEN 'Tuesday'
      WHEN YDM.Day_Of_Week = 4 THEN 'Wednesday'
      WHEN YDM.Day_Of_Week = 5 THEN 'Thursday'
      WHEN YDM.Day_Of_Week = 6 THEN 'Friday'
      WHEN YDM.Day_Of_Week = 7 THEN 'Saturday'
    END,
  @Month = YDM.Month_Number
FROM dbo.Schedule AS S
JOIN dbo.Schedule_Yearly_Day_Of_Month AS YDM
  ON YDM.User_Id = S.User_Id
  AND YDM.Schedule_Key = S.Schedule_Key
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
      (
        @Instance BETWEEN 1 AND 4 
        AND C.Instance_Of_Day = @Instance
      )
      OR C.Is_Last_Instance = 1 AND @Instance = 5
    )
    AND C.Calendar_Month = @Month
  ORDER BY
    C.Calendar_Key
)
SELECT TOP(@Days_To_Return)
  C.Calendar_Date
FROM CTE_Dates AS C 
WHERE (@Interval = 1 OR Row_ID % @Interval = 1);

RETURN;