CREATE PROCEDURE [dbo].[Scheduling_Next_Instances_Get]      
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
-- Used in: Maintenance_Update and Work_Request_Fixed_Day_By_Month_Generate

DECLARE
  @Schedule_Type INT;

SELECT
  @Schedule_Type = S.Schedule_Type
FROM dbo.Schedule AS S
WHERE S.User_Id = @User_Id
  AND S.Schedule_Key = @Schedule_Key;

IF @Schedule_Type = 1
BEGIN 
  EXEC dbo.Scheduling_Days_Of_Week_Weekly_Next_Instances_Get @User_Id, @Schedule_Key, @Days_To_Return, @Day_To_Schedule_After
END
ELSE IF @Schedule_Type = 2
BEGIN
  EXEC dbo.Scheduling_Day_Of_Week_In_Month_Next_Instances_Get @User_Id, @Schedule_Key, @Days_To_Return, @Day_To_Schedule_After
END
ELSE IF @Schedule_Type = 3
BEGIN
  EXEC dbo.Scheduling_Specific_Days_Of_Month_Next_Instances_Get @User_Id, @Schedule_Key, @Days_To_Return, @Day_To_Schedule_After
END
ELSE IF @Schedule_Type = 4
BEGIN
  EXEC dbo.Scheduling_Day_Of_Week_In_Month_Yearly_Next_Instances_Get @User_Id, @Schedule_Key, @Days_To_Return, @Day_To_Schedule_After
END
ELSE
BEGIN
  EXEC dbo.Scheduling_Specific_Day_In_Month_Yearly_Next_Instances_Get @User_Id, @Schedule_Key, @Days_To_Return, @Day_To_Schedule_After
END;

RETURN;