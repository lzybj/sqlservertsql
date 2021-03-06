USE master
GO
--创建数据库Hotel
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Hotel')
	DROP DATABASE Hotel
GO
CREATE DATABASE [Hotel] ON  PRIMARY 
( NAME = 'Hotel', FILENAME = 'c:\Hotel.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = 'Hotel_log', FILENAME = 'c:\Hotel_log.ldf' , SIZE = 1024KB , MAXSIZE = 20MB , FILEGROWTH = 10%)
GO

--创建表
USE Hotel
GO
--创建结账状态表ResideState
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'ResideState')
	DROP TABLE ResideState
GO
CREATE TABLE ResideState(
	ResideId int IDENTITY(1,1) NOT NULL, --结账状态ID
	ResideName varchar(50) NULL          --结账状态名称
)

ALTER TABLE ResideState
  ADD CONSTRAINT PK_ResideState PRIMARY KEY (ResideId)
GO

--创建客房类型表RoomType
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'RoomType')
	DROP TABLE RoomType
GO
CREATE TABLE RoomType (
	TypeID int IDENTITY(1,1) NOT NULL,--客房类型id
	TypeName nvarchar(50) NULL,		  --客房类型名称
	TypePrice decimal(18, 2) NULL     --客房类型价格
)
GO
ALTER TABLE RoomType
  ADD CONSTRAINT PK_RoomType PRIMARY KEY (TypeID)
GO
ALTER TABLE RoomType
  ADD CONSTRAINT CK_RoomPrice CHECK(TypePrice >= 0)
GO

--创建客房状态表RoomState
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'RoomState')
	DROP TABLE RoomState
GO
CREATE TABLE RoomState (
	RoomStateID int IDENTITY(1,1) NOT NULL,--房间状态id
	RoomStateName nvarchar(20) NULL        --房间状态名称
)
GO
ALTER TABLE RoomState
   ADD CONSTRAINT PK_RoomState PRIMARY KEY (RoomStateID)
GO

--创建客房信息表Room
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'Room')
	DROP TABLE Room
GO
CREATE TABLE Room (
	RoomID int NOT NULL,                 --房间id
	Description nvarchar(200) NOT NULL,  --房间描述
	BedNum int NULL,                     --床位数
	GuestNum int NULL,                   --房客数目
	RoomStateID int NOT NULL,            --房间状态id
	RoomTypeID int NOT NULL              --客房类型id
)
GO
ALTER TABLE Room
  ADD CONSTRAINT PK_RoomID PRIMARY KEY (RoomID)
GO
ALTER TABLE Room
  ADD CONSTRAINT DF_RoomStateID  DEFAULT (2) FOR RoomStateID,
  CONSTRAINT DF_BedNum  DEFAULT (2) FOR BedNum,
  CONSTRAINT DF_GuestNum DEFAULT (0) FOR GuestNum,
  CONSTRAINT CK_GuestNum CHECK(GuestNum >= 0),
  CONSTRAINT FK_RoomStateID FOREIGN KEY(RoomStateID) REFERENCES RoomState(RoomStateID),
  CONSTRAINT FK_RoomTypeID FOREIGN KEY(RoomTypeID) REFERENCES RoomType(TypeID)
GO

--创建客人信息表GuestRecord
IF EXISTS (SELECT * FROM sysobjects WHERE name = 'GuestRecord')
	DROP TABLE GuestRecord
GO
CREATE TABLE GuestRecord (
	GuestID int IDENTITY(1,1) NOT NULL,--入住流水ID
	IdentityID varchar(50) NOT NULL,   --身份证号
	GuestName nvarchar(20) NOT NULL,   --客人姓名
	RoomID int NULL,                   --客房ID
	ResideID int NULL,                 --入住状态ID
	ResideDate datetime NULL,          --入住日期
	LeaveDate datetime NULL,           --结账日期
	Deposit decimal(18, 2) NULL,       --押金
	TotalMoney decimal(18, 2) NULL     --总金额
)
GO
ALTER TABLE GuestRecord
  ADD CONSTRAINT PK_GuestID PRIMARY KEY(GuestID),
  CONSTRAINT DF_ResideID DEFAULT (1) FOR ResideID,
  CONSTRAINT CK_LeaveDate CHECK (LeaveDate>=ResideDate),
  CONSTRAINT FK_RoomID FOREIGN KEY(RoomID) REFERENCES Room(RoomID),
  CONSTRAINT FK_ResideID FOREIGN KEY(ResideID) REFERENCES ResideState(ResideID)
GO

--插入数据
--数据插入结账状态表ResideState
INSERT INTO ResideState (ResideName) VALUES('未结帐')
INSERT INTO ResideState (ResideName) VALUES('结帐')
--数据插入客房类型表RoomType
INSERT INTO RoomType (TypeName, TypePrice) VALUES ('标准间',180)
INSERT INTO RoomType (TypeName, TypePrice)  VALUES ('单人间',128)
INSERT INTO RoomType (TypeName, TypePrice) VALUES ('三人间',208)
INSERT INTO RoomType (TypeName, TypePrice)  VALUES ('单人间',99)
INSERT INTO RoomType (TypeName, TypePrice) VALUES ('总统套房',998)
INSERT INTO RoomType (TypeName, TypePrice)  VALUES ('长包房',108)
INSERT INTO RoomType (TypeName, TypePrice)  VALUES ('豪华标准间',268)
INSERT INTO RoomType (TypeName, TypePrice)  VALUES ('单人套房',368)
INSERT INTO RoomType (TypeName, TypePrice)  VALUES ('双人套房',568)

--数据插入客房状态表RoomState
INSERT INTO RoomState (RoomStateName)  VALUES ('已入住')
INSERT INTO RoomState (RoomStateName)  VALUES ('空闲')
INSERT INTO RoomState (RoomStateName)  VALUES ('维修')

--数据插入客房信息表Room
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1008,'双人标准间',2,2,1,1)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1018,'双人标准间',2,0,2,1)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1028,'双人标准间',2,1,1,1)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1038,'双人标准间',2,0,3,1)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1048,'单人间',1,1,1,1)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1058,'单人间',1,1,1,1)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1068,'单人套房',1,1,1,8)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1078,'单人套房',1,0,2,8)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1088,'豪华双人标准间',2,1,1,7)
INSERT INTO Room (RoomID,Description,BedNum,GuestNum,RoomStateID,RoomTypeID) VALUES (1098,'豪华双人标准间',2,0,2,7)

--数据插入客人信息表GuestRecord
INSERT INTO GuestRecord (IdentityID,GuestName,RoomID,ResideDate,LeaveDate,Deposit,TotalMoney,ResideID) 
VALUES ('11010119910101001x','王笑',1008,'2009-9-9 12:30:00','2009-9-10 11:30:02',1000,180,2)
INSERT INTO GuestRecord (IdentityID,GuestName,RoomID,ResideDate,LeaveDate,Deposit,TotalMoney) 
VALUES ('110101199110100114','张淼',1008,'2009-9-9 12:30:00','2009-9-10 11:30:02',1000,180)
INSERT INTO GuestRecord (IdentityID,GuestName,RoomID,ResideDate,LeaveDate,Deposit,TotalMoney) 
VALUES ('230121197902030121','刘元元',1028,'2009-9-20 22:23:20',null,3000,null)
INSERT INTO GuestRecord (IdentityID,GuestName,RoomID,ResideDate,LeaveDate,Deposit,TotalMoney) 
VALUES ('321007198606161231','丁一',1048,'2009-9-29 02:30:40',null,1000,null)
INSERT INTO GuestRecord (IdentityID,GuestName,RoomID,ResideDate,LeaveDate,Deposit,TotalMoney) 
VALUES ('210119760210010083','赵玲',1058,'2009-9-18 16:33:13',null,800,null)
INSERT INTO GuestRecord (IdentityID,GuestName,RoomID,ResideDate,LeaveDate,Deposit,TotalMoney) 
VALUES ('21201019910710001x','谭坛',1068,'2009-10-3 6:36:09',null,1500,null)
INSERT INTO GuestRecord (IdentityID,GuestName,RoomID,ResideDate,LeaveDate,Deposit,TotalMoney) 
VALUES ('110102197801070121','周舟',1088,'2009-10-4 7:50:40',null,5000,null)
