CREATE PROCEDURE [dbo].[Scheduling_Days_Of_Week_Weekly_Next_Instances_Get]      
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

DECLARE @Days_Of_Week TABLE
(
  Day_Of_Week VARCHAR(15)
);

DECLARE
  @Day_Of_Month INT,
  @Interval INT,
  @Month INT,
  @Week_Number INT;
  
SELECT
  @Interval = S.Interval
FROM dbo.Schedule AS S
WHERE S.User_Id = @User_Id
  AND S.Schedule_Key = @Schedule_Key;

INSERT @Days_Of_Week
(
  Day_Of_Week
)
SELECT
  CASE
    WHEN DOW.Day_Of_Week = 1 THEN 'Sunday'
    WHEN DOW.Day_Of_Week = 2 THEN 'Monday'
    WHEN DOW.Day_Of_Week = 3 THEN 'Tuesday'
    WHEN DOW.Day_Of_Week = 4 THEN 'Wednesday'
    WHEN DOW.Day_Of_Week = 5 THEN 'Thursday'
    WHEN DOW.Day_Of_Week = 6 THEN 'Friday'
    WHEN DOW.Day_Of_Week = 7 THEN 'Saturday'
  END
FROM dbo.Schedule_Day_Of_Week AS DOW
WHERE DOW.User_Id = @User_Id
  AND DOW.Schedule_Key = @Schedule_Key;

SELECT
  @Week_Number = C.Week_Number
FROM dbo.Calendar AS C
WHERE C.Calendar_Date = DATEADD(DD, 0, DATEDIFF(DD, 0, @Day_To_Schedule_After));

SELECT TOP(@Days_To_Return)
  C.Calendar_Date
FROM dbo.Calendar AS C 
WHERE C.Calendar_Date >= @Day_To_Schedule_After 
  AND C.Day_Of_Week IN
  (
    SELECT
      DOW.Day_Of_Week
    FROM @Days_Of_Week AS DOW
  )
  AND C.Week_Number % @Interval = @Week_Number % @Interval
ORDER BY
  C.Calendar_Key;

RETURN;