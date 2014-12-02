CREATE PROCEDURE [dbo].[Scheduling_Specific_Days_Of_Month_Next_Instances_Get]      
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

DECLARE @Days_Of_Month TABLE
(
  Day_Of_Month INT
);

DECLARE
  @Interval INT,
  @Month_Number INT;
  
SELECT
  @Interval = S.Interval
FROM dbo.Schedule AS S
WHERE S.User_Id = @User_Id
  AND S.Schedule_Key = @Schedule_Key;

INSERT @Days_Of_Month
(
  Day_Of_Month
)
SELECT
  DOM.Day_Of_Month
FROM dbo.Schedule_Day_Of_Month AS DOM
WHERE DOM.User_Id = @User_Id
  AND DOM.Schedule_Key = @Schedule_Key;

SELECT
  @Month_Number = C.Month_Number
FROM dbo.Calendar AS C
WHERE C.Calendar_Date = DATEADD(DD, 0, DATEDIFF(DD, 0, @Day_To_Schedule_After));

SELECT TOP(@Days_To_Return)
  C.Calendar_Date
FROM dbo.Calendar AS C 
WHERE C.Calendar_Date >= @Day_To_Schedule_After 
  AND 
  (
    C.Day_Of_Month IN
    (
      SELECT
        DOM.Day_Of_Month
      FROM @Days_Of_Month AS DOM
    )
    OR
    (
      (
        C.Calendar_Month IN (4,6,9,11)
        AND C.Day_Of_Month = 30
        AND EXISTS
        (
          SELECT
            *
          FROM @Days_Of_Month AS DOM
          WHERE DOM.Day_Of_Month = 31
        )
      )
      OR
      (
        C.Calendar_Month = 2
        AND C.Day_Of_Month = 29
        AND 
        (
          C.Calendar_Year % 400 = 0
          OR
          (
            C.Calendar_Year % 4 = 0
            AND C.Calendar_Year % 100 <> 0
          )
        )
        AND EXISTS
        (
          SELECT
            *
          FROM @Days_Of_Month AS DOM
          WHERE DOM.Day_Of_Month IN (30,31)
        )
      )
      OR
      (
        C.Calendar_Month = 2
        AND C.Day_Of_Month = 28
        AND NOT
        (
          C.Calendar_Year % 400 = 0
          OR
          (
            C.Calendar_Year % 4 = 0
            AND C.Calendar_Year % 100 <> 0
          )
        )
        AND EXISTS
        (
          SELECT
            *
          FROM @Days_Of_Month AS DOM
          WHERE DOM.Day_Of_Month IN (29,30,31)
        )
      )
    )
  )
  AND C.Month_Number % @Interval = @Month_Number % @Interval
ORDER BY
  C.Calendar_Key;

RETURN;