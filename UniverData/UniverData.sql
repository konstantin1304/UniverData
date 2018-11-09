IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = N'University_DNU')
CREATE DATABASE University_DNU
GO
USE University_DNU
GO
--Специальности
IF (object_id(N'[dbo].[tbSpec]','U') IS NULL)
CREATE TABLE tbSpec(
  Id INT IDENTITY  NOT NULL, 
  [Name] NVARCHAR(32) NOT NULL,
  PRIMARY KEY (Id)
);
--Группы
IF (object_id(N'[dbo].[tbGroups]','U') IS NULL)
CREATE TABLE tbGroups(
  Id INT IDENTITY NOT NULL,
  [Name] NVARCHAR(32) NOT NULL,
  SpecId INT NOT NULL, 
  PRIMARY KEY (Id),
  FOREIGN KEY(SpecId) REFERENCES tbSpec (Id)
  );
--Студенты
IF (object_id(N'[dbo].[tbStudents]','U') IS NULL)
CREATE TABLE tbStudents(
  Id INT IDENTITY NOT NULL,
  FirstName NVARCHAR (64) NOT NULL,
  MiddleName NVARCHAR (64) NOT NULL,
  LastName NVARCHAR (64) NOT NULL,
  Birthday DATE NOT NULL,
  LogbookNumber INT NULL,
  Email NVARCHAR (255) NOT NULL,
  Adress NVARCHAR (255) NULL,
  GroupId INT NULL,
  CONSTRAINT ST_PK PRIMARY KEY (Id),
  CONSTRAINT ST_GR_FK FOREIGN KEY (GroupId) REFERENCES tbGroups (Id) ON DELETE SET NULL ON UPDATE CASCADE
  );
--Телефоны студентов
IF (object_id(N'[dbo].[tbPhones]','U') IS NULL)
CREATE TABLE tbPhones (
  Id INT IDENTITY NOT NULL,
  Phone NVARCHAR(32) NOT NULL,
  StudentID INT NOT NULL,
  CONSTRAINT PH_PK PRIMARY KEY (Id),
  CONSTRAINT PH_ST_FK FOREIGN KEY (StudentId) 
  REFERENCES tbStudents (Id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE (Phone)
  );

-- Кафедры
IF (object_id(N'[dbo].[tbDepartments]','U') IS NULL)
CREATE TABLE tbDepartments(
  Id INT IDENTITY,
  Name NVARCHAR(32) NOT NULL,
  CONSTRAINT PK_DEP PRIMARY KEY (Id),
);

-- Преподаватели
IF (object_id(N'[dbo].[tbTeachers]','U') IS NULL)
CREATE TABLE tbTeachers(
  Id INT IDENTITY NOT NULL,
  FirstName NVARCHAR (64) NOT NULL,
  MiddleName NVARCHAR (64) NOT NULL,
  LastName NVARCHAR (64) NOT NULL,
  DepID INT NULL,
  FOREIGN KEY (DepId) REFERENCES tbDepartments (Id) ON DELETE SET NULL ON UPDATE CASCADE,
  PRIMARY KEY (Id)
  );
--Предметы
IF (object_id(N'[dbo].[tbSubjects]','U') IS NULL)
CREATE TABLE tbSubjects(
  Id INT IDENTITY,
  Name NVARCHAR(260) NOT NULL,
  PRIMARY KEY (Id)
);
 
IF (object_id(N'[dbo].[tbTeachSubj]','U') IS NULL)
CREATE TABLE tbTeachSubj(
  Id INT IDENTITY PRIMARY KEY,
  TeachId INT NOT NULL,
  SubjId INT NOT NULL,
  SpecId INT NOT NULL,
  FOREIGN KEY (TeachId) REFERENCES tbTeachers (Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SubjId) REFERENCES tbSubjects (Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (SpecId) REFERENCES tbSpec (Id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE ( TeachID, SubjId)
);

IF (object_id(N'[dbo].[tbMarks]','U') IS NULL)
CREATE TABLE tbMarks(
  Id INT IDENTITY,
  Mark INT NOT NULL,
  TSId INT NOT NULL,
  StudId INT NOT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY(StudId)REFERENCES tbStudents (Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (TSId) REFERENCES tbTeachSubj (Id),
  CHECK (Mark BETWEEN 1 AND 12)
);

IF (object_id(N'[dbo].[tbPairTimeTable]','U') IS NULL)
CREATE TABLE tbPairTimetable(
Id INT IDENTITY,
  PairNumber INT NOT NULL UNIQUE,
  BeginPair TIME NOT NULL,
  EndPair TIME NOT NULL,
  PRIMARY KEY (Id)
);

IF (object_id(N'[dbo].[tbClassroom]','U') IS NULL)
CREATE TABLE tbClassroom(
Id INT IDENTITY,
  ClassroomNumber INT NOT NULL,
  Capacity INT NOT NULL,
  [Floor] INT NOT NULL,
  PRIMARY KEY (Id)
);

IF (object_id(N'[dbo].[tbTimetable]','U') IS NULL)
CREATE TABLE tbTimetable(
Id INT IDENTITY,
ClassroomId INT NOT NULL,
TeachSubjId INT NOT NULL,
PairTimetableId INT NOT NULL,
  PRIMARY KEY (Id),
  FOREIGN KEY(ClassroomId)REFERENCES tbClassroom (Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(TeachSubjId)REFERENCES tbTeachSubj (Id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(PairTimetableId)REFERENCES tbPairTimetable (Id) ON DELETE CASCADE ON UPDATE CASCADE
);

IF (object_id(N'[dbo].[tbGroupTimetable]','U') IS NULL)
CREATE TABLE tbGroupTimetable(
Id INT IDENTITY,
TimetableId INT NOT NULL,
GroupsId INT NOT NULL,
PRIMARY KEY (Id),
FOREIGN KEY(TimetableId)REFERENCES tbTimetable (Id) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(GroupsId)REFERENCES tbGroups (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
GO
INSERT INTO tbSpec ([Name]) Values ('Программист');
INSERT INTO tbDepartments (Name) Values ('Примат');
INSERT INTO tbSubjects ([Name]) Values ('Основы ООП');
INSERT INTO tbClassroom (ClassroomNumber, Capacity, [Floor]) Values (245, 60, 2);
INSERT INTO tbPairTimetable (PairNumber, BeginPair, EndPair) Values (1, '08:00:00.0', '09:20:00.0');

INSERT INTO tbGroups([Name], SpecId) Values ('ВЗ-07-1', 1);
INSERT INTO tbStudents (FirstName, MiddleName, LastName, Birthday, LogbookNumber, Email, Adress, GroupId) Values ('Константин', 'Петров', 'Петрович', '1990-12-10','321169', '567@i.ua', 'ул.Колотушкина', 1)
INSERT INTO tbTeachers (FirstName, MiddleName, LastName, DepID) Values ('Иванов', 'Иван', 'Иванович', 1);
INSERT INTO tbTeachSubj (TeachId, SubjId, SpecId) Values (1, 1, 1);
INSERT INTO tbTimetable (ClassroomId, TeachSubjId, PairTimetableId) Values (1, 1, 1);
INSERT INTO tbMarks (Mark, TSId, StudId) Values (5, 1, 1);

INSERT INTO tbGroupTimetable (TimetableId, GroupsId) Values (1, 1);
GO
--EnterpriceDir (Name, Surename, Department, Position) Values ('Petya', 'Ivanov', 'Cleaning', 'Cleaner')";
SELECT Id, ClassroomId, TeachSubjId, PairTimetableId FROM tbTimetable;
SELECT Id, SubjId, SpecId, TeachId FROM tbTeachSubj WHERE Id=1; --TeachSubjId
SELECT Id, ClassroomNumber FROM tbClassroom Where Id=1; --ClassroomId
SELECT Id, PairNumber FROM tbPairTimetable Where Id=1; --PairTimeTableId
SELECT Id, [Name] FROM tbSubjects WHERE Id=1; --SubjId
SELECT Id, FirstName, LastName From tbTeachers Where Id=1; --TeachId
SELECT Id, [Name] FROM tbSpec WHERE Id=1; --SpecId
       