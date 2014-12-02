CREATE TABLE dbo.Schedule
(
  User_Id INT NOT NULL,
  Schedule_Key INT NOT NULL IDENTITY,
  Name VARCHAR(50) NOT NULL,
  Schedule_Description VARCHAR(250) NOT NULL CONSTRAINT DF_Schedule_Schedule_Description DEFAULT (''),
  Interval INT NOT NULL,
  Schedule_Type INT NOT NULL,
  CONSTRAINT PK_Schedule PRIMARY KEY CLUSTERED
  (
    PCN,
    Schedule_Key
  )
  WITH
  (
    FILLFACTOR = 95
  )
)
ON [PRIMARY];

ALTER TABLE dbo.Schedule
  WITH CHECK 
  ADD CONSTRAINT FK_User_Schedule
  FOREIGN KEY
  (
    User_Id
  )
  REFERENCES dbo.User
  (
    User_Id
  );

CREATE UNIQUE INDEX IX_UNIQUE_Name_Module_Key
ON dbo.Schedule
(
  User_Id,
  Name,
  Module_Key
)
WITH 
(
  FILLFACTOR = 95
)
ON [PRIMARY];

CREATE TABLE dbo.Schedule_Day_Of_Week
(
  User_Id INT NOT NULL,
  Schedule_Day_Of_Week_Key INT NOT NULL IDENTITY,
  Schedule_Key INT NOT NULL,
  Day_Of_Week INT NOT NULL,
  CONSTRAINT PK_Schedule_Day_Of_Week PRIMARY KEY CLUSTERED
  (
    User_Id,
    Schedule_Day_Of_Week_Key
  )
  WITH
  (
    FILLFACTOR = 95
  )
)
ON [PRIMARY];

CREATE UNIQUE INDEX IX_UNIQUE_Schedule_Key_Day_Of_Week
ON dbo.Schedule_Day_Of_Week
(
  User_Id,
  Schedule_Key,
  Day_Of_Week
)
WITH 
(
  FILLFACTOR = 95
)
ON [PRIMARY];

ALTER TABLE dbo.Schedule_Day_Of_Week 
  WITH CHECK 
  ADD CONSTRAINT FK_Schedule_Day_Of_Week_Schedule
  FOREIGN KEY
  (
    User_Id,
    Schedule_Key
  )
  REFERENCES dbo.Schedule
  (
    User_Id,
    Schedule_Key
  );

CREATE TABLE dbo.Schedule_Day_Of_Month
(
  User_Id INT NOT NULL,
  Schedule_Day_Of_Month_Key INT NOT NULL IDENTITY,
  Schedule_Key INT NOT NULL,
  Day_Of_Month INT NOT NULL,
  CONSTRAINT PK_Schedule_Day_Of_Month PRIMARY KEY CLUSTERED
  (
    User_Id,
    Schedule_Day_Of_Month_Key
  )
  WITH
  (
    FILLFACTOR = 95
  )
)
ON [PRIMARY];

CREATE UNIQUE INDEX IX_UNIQUE_Schedule_Key_Day_Of_Month
ON dbo.Schedule_Day_Of_Month
(
  User_Id,
  Schedule_Key,
  Day_Of_Month
)
WITH 
(
  FILLFACTOR = 95
)
ON [PRIMARY];

ALTER TABLE dbo.Schedule_Day_Of_Month 
  WITH CHECK 
  ADD CONSTRAINT FK_Schedule_Day_Of_Month_Schedule 
  FOREIGN KEY
  (
    User_Id,
    Schedule_Key
  )
  REFERENCES dbo.Schedule
  (
    User_Id,
    Schedule_Key
  );

CREATE TABLE dbo.Schedule_Weekday_Of_Month
(
  User_Id INT NOT NULL,
  Schedule_Weekday_Of_Month_Key INT NOT NULL IDENTITY,
  Schedule_Key INT NOT NULL,
  Day_Of_Week INT NOT NULL,
  Day_Of_Week_Instance INT NOT NULL,
  CONSTRAINT PK_Schedule_Weekday_Of_Month PRIMARY KEY CLUSTERED
  (
    User_Id,
    Schedule_Weekday_Of_Month_Key
  )
  WITH
  (
    FILLFACTOR = 95
  )
)
ON [PRIMARY];

CREATE UNIQUE INDEX IX_UNIQUE_Schedule_Key_Day_Of_Week_Day_Of_Week_Instance
ON dbo.Schedule_Weekday_Of_Month
(
  User_Id,
  Schedule_Key,
  Day_Of_Week,
  Day_Of_Week_Instance
)
WITH 
(
  FILLFACTOR = 95
)
ON [PRIMARY];

ALTER TABLE dbo.Schedule_Weekday_Of_Month 
  WITH CHECK 
  ADD CONSTRAINT FK_Schedule_Weekday_Of_Month_Schedule 
  FOREIGN KEY
  (
    User_Id,
    Schedule_Key
  )
  REFERENCES dbo.Schedule
  (
    User_Id,
    Schedule_Key
  );

CREATE TABLE dbo.Schedule_Yearly_On_Date
(
  User_Id INT NOT NULL,
  Schedule_Yearly_On_Date_Key INT NOT NULL IDENTITY,
  Schedule_Key INT NOT NULL,
  Month_Number INT NOT NULL,
  Day_Of_Month INT NOT NULL,
  CONSTRAINT PK_Schedule_Yearly_On_Date PRIMARY KEY CLUSTERED
  (
    User_Id,
    Schedule_Yearly_On_Date_Key
  )
  WITH
  (
    FILLFACTOR = 95
  )
)
ON [PRIMARY];

CREATE UNIQUE INDEX IX_UNIQUE_Schedule_Key_Month_Number_Day_Of_Month
ON dbo.Schedule_Yearly_On_Date
(
  User_Id,
  Schedule_Key,
  Month_Number,
  Day_Of_Month
)
WITH 
(
  FILLFACTOR = 95
)
ON [PRIMARY];

ALTER TABLE dbo.Schedule_Yearly_On_Date 
  WITH CHECK 
  ADD CONSTRAINT FK_Schedule_Yearly_On_Date_Schedule 
  FOREIGN KEY
  (
    User_Id,
    Schedule_Key
  )
  REFERENCES dbo.Schedule
  (
    User_Id,
    Schedule_Key
  );

CREATE TABLE dbo.Schedule_Yearly_Day_Of_Month
(
  User_Id INT NOT NULL,
  Schedule_Yearly_Day_Of_Month_Key INT NOT NULL IDENTITY,
  Schedule_Key INT NOT NULL,
  Month_Number INT NOT NULL,
  Day_Of_Week INT NOT NULL,
  Day_Of_Week_Instance INT NOT NULL,
  CONSTRAINT PK_Schedule_Yearly_Day_Of_Month PRIMARY KEY CLUSTERED
  (
    User_Id,
    Schedule_Yearly_Day_Of_Month_Key
  )
  WITH
  (
    FILLFACTOR = 95
  )
)
ON [PRIMARY];

CREATE UNIQUE INDEX IX_UNIQUE_Schedule_Key_Month_Number_Day_Of_Week_Day_Of_Week_Instance
ON dbo.Schedule_Yearly_Day_Of_Month
(
  User_Id,
  Schedule_Key,
  Month_Number,
  Day_Of_Week,
  Day_Of_Week_Instance
)
WITH 
(
  FILLFACTOR = 95
)
ON [PRIMARY];

ALTER TABLE dbo.Schedule_Yearly_Day_Of_Month 
  WITH CHECK 
  ADD CONSTRAINT FK_Schedule_Yearly_Day_Of_Month_Schedule 
  FOREIGN KEY
  (
    User_Id,
    Schedule_Key
  )
  REFERENCES dbo.Schedule
  (
    User_Id,
    Schedule_Key
  );

CREATE TABLE dbo.Calendar
(
  Calendar_Key INT NOT NULL IDENTITY,
  Calendar_Date DATETIME NOT NULL,
  Day_Of_Month INT NOT NULL,
  Calendar_Month INT NOT NULL,
  Calendar_Year INT NOT NULL,
  Day_Of_Week VARCHAR(15) NOT NULL,
  Instance_Of_Day INT NOT NULL,
  Is_Last_Instance BIT NOT NULL,
  Week_Number INT NOT NULL,
  Month_Number INT NOT NULL,
  CONSTRAINT PK_Calendar PRIMARY KEY CLUSTERED
  (
    Calendar_Key
  )
  WITH
  (
    FILLFACTOR = 95
  )
)
ON [PRIMARY];

