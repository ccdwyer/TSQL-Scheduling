CREATE PROCEDURE [dbo].[Scheduling_Specific_Day_In_Month_Yearly_Next_Instances_Get]      
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
  @Day_Of_Month INT,
  @Interval INT,
  @Month INT;
  
SELECT
  @Interval = S.Interval,
  @Day_Of_Month = YD.Day_Of_Month,
  @Month = YD.Month_Number
FROM dbo.Schedule AS S
JOIN dbo.Schedule_Yearly_On_Date AS YD
  ON YD.PCN = S.PCN
  AND YD.Schedule_Key = S.Schedule_Key
WHERE S.User_Id = @User_Id
  AND S.Schedule_Key = @Schedule_Key;

WITH CTE_Dates AS
(
  SELECT TOP(@Days_To_Return * @Interval)
    C.Calendar_Date,
    ROW_NUMBER() OVER (ORDER BY C.Calendar_Key) AS RowID
  FROM dbo.Calendar AS C 
  WHERE C.Calendar_Date >= @Day_To_Schedule_After 
    AND C.Day_Of_Month = @Day_Of_Month
    AND C.Calendar_Month = @Month
  ORDER BY
    C.Calendar_Key
)
SELECT TOP(@Days_To_Return)
  C.Calendar_Date 
FROM CTE_Dates AS C 
WHERE (@Interval = 1 OR RowID % @Interval = 1);

RETURN;