DECLARE
  @StartDate DATETIME,
  @EndDate DATETIME,
  @Week_No INT,
  @Month_No INT,
  @Poison_Pill INT;

SELECT
  @StartDate = '2004-01-01',
  @EndDate = '2114-12-31',
  @Week_No = 1,
  @Month_No = 1,
  @Poison_Pill = 1;

WHILE @StartDate <= @EndDate
  AND @Poison_Pill < 40600
BEGIN
  INSERT INTO dbo.Calendar
  (
    Calendar_Date,
    Day_Of_Month,
    Calendar_Month,
    Calendar_Year,
    Day_Of_Week,
    Instance_Of_Day,
    Is_Last_Instance,
    Week_Number,
    Month_Number
  )
  VALUES
  (
    DATEADD(DD, 0, DATEDIFF(DD, 0, @StartDate)),
    DATEPART(DAY, @StartDate),
    DATEPART(MONTH, @StartDate),
    DATEPART(YEAR, @StartDate),
    DATENAME(WEEKDAY, @StartDate),
    CASE
      WHEN DATEPART(DAY, @StartDate) BETWEEN 1 AND 7 THEN 1
      WHEN DATEPART(DAY, @StartDate) BETWEEN 8 AND 14 THEN 2
      WHEN DATEPART(DAY, @StartDate) BETWEEN 15 AND 21 THEN 3
      WHEN DATEPART(DAY, @StartDate) BETWEEN 22 AND 28 THEN 4
      WHEN DATEPART(DAY, @StartDate) > 28 THEN 5
    END,
    CASE
      WHEN DATEPART(DAY, @StartDate) BETWEEN 25 AND 31
        AND DATEPART(MONTH, @StartDate) IN (1,3,5,7,8,10,12) THEN 1
      WHEN DATEPART(DAY, @StartDate) BETWEEN 24 AND 30
        AND DATEPART(MONTH, @StartDate) IN (4,6,9,11) THEN 1
      WHEN DATEPART(DAY, @StartDate) BETWEEN 22 AND 28
        AND DATEPART(MONTH, @StartDate) = 2
        AND NOT
        (
          DATEPART(YEAR, @StartDate) % 400 = 0
          OR
          (
            DATEPART(YEAR, @StartDate) % 4 = 0
            AND DATEPART(YEAR, @StartDate) % 100 <> 0
          )
        ) THEN 1
      WHEN DATEPART(DAY, @StartDate) BETWEEN 23 AND 29
        AND DATEPART(MONTH, @StartDate) = 2
        AND
        (
          DATEPART(YEAR, @StartDate) % 400 = 0
          OR
          (
            DATEPART(YEAR, @StartDate) % 4 = 0
            AND DATEPART(YEAR, @StartDate) % 100 <> 0
          )
        ) THEN 1
      ELSE 0
    END,
    @Week_No,
    @Month_No
  );
  IF DATENAME(WEEKDAY, @StartDate) = 'Saturday'
  BEGIN
    SET @Week_No = @Week_No + 1;
  END;
  SET @StartDate =DATEADD(DD, 1, @StartDate);
  IF DATEPART(DAY, @StartDate) = 1
  BEGIN
    SET @Month_No = @Month_No + 1
  END;
  
  SET @Poison_Pill = @Poison_Pill + 1;
END;