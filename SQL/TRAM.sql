-- TRAM DB Build

-- Creating DB in MasterDB

USE Master

-- Checking to see if TRON already exists

IF EXISTS (SELECT * FROM sysdatabases WHERE name='TRON')
DROP DATABASE TRON

GO

-- Creating TRON

CREATE DATABASE TRON

ON PRIMARY
(
	NAME = 'TRON',
	FILENAME = 'C:\Stage\TRON.mdf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 10%
)

-- Creating TRON log

LOG ON
(
	NAME = 'TRON_Log',
	FILENAME = 'C:\Stage\TRON.ldf',
	SIZE = 2500KB,
	MAXSIZE = 5MB,
	FILEGROWTH = 500KB
)

GO

-- Using TRON

USE TRON

GO

-- Creating tables and primary keys

CREATE TABLE Person
(
	PersonID			int	IDENTITY(1,1)	NOT NULL	PRIMARY KEY,
	PersonFirst			nvarchar(50)		NOT NULL,
	PersonLast			nvarchar(50)		NOT NULL,
	PersonAddress		varchar(50)			NOT NULL,
	PersonCity			varchar(50)			NOT NULL,
	PersonState			char(2)				NULL,
	PersonPostalCode	varchar(10)			NOT NULL,
	PersonCountry		varchar(20)			NOT NULL,
	PersonPhone			varchar(20)			NOT NULL,
	PersonEmail			varchar(200)		NOT NULL
)

CREATE TABLE Reservation
(
	ReservationID		int IDENTITY(1,1)	NOT NULL	PRIMARY KEY,
	ResDate				smalldatetime		NOT NULL,
	ResStatus			char(1)				NOT NULL,
	ResCheckInDate		date				NOT NULL,
	ResNights			tinyint				NOT NULL,
	ResQuotedRate		smallmoney			NOT NULL,
	ResDepositPaid		smallmoney			NOT NULL,
	ResCCAuth			varchar(25)			NOT NULL,
	UnitRateID			smallint			NOT NULL,
	PersonID			int					NOT NULL
)

CREATE TABLE Folio
(
	FolioID				int IDENTITY(1,1)		NOT NULL	PRIMARY KEY,
	FolioStatus			char(1)					NOT NULL,
	FolioRate			smallmoney				NOT NULL,
	FolioCheckInDate	smalldatetime			NOT NULL,
	FolioCheckOutDate	smalldatetime			NULL,
	UnitID				smallint				NOT NULL,
	ReservationID		int						NOT NULL
)

CREATE TABLE FolioTransaction
(
	TransID				bigint IDENTITY(1,1)	NOT NULL	PRIMARY KEY,
	TransDate			datetime				NOT NULL,
	TransAmount			smallmoney				NOT NULL,
	TransDescription	varchar(50)				NOT NULL,
	TransCategoryID		smallint				NOT NULL,
	FolioID				int						NOT NULL
)

CREATE TABLE TransCategory
(
	TransCategoryID				smallint IDENTITY(1,1)		NOT NULL	PRIMARY KEY,
	TransCategoryDescription	varchar(50)					NOT NULL,
	TransTaxType				char(1)						NOT NULL
)

CREATE TABLE UnitOwner
(
	UnitID				smallint		NOT NULL,
	PersonID			int				NOT NULL,
	OwnerStartDate		date			NOT NULL,
	OwnerEndDate		date			NULL
)

CREATE TABLE Unit
(
	UnitID			smallint		NOT NULL	PRIMARY KEY,
	UnitNumber		varchar(5)		NOT NULL,
	PropertyID		smallint		NOT NULL,
	UnitTypeID		tinyint			NOT NULL
)

CREATE TABLE UnitType
(
	UnitTypeID				tinyint IDENTITY(1,1)		NOT NULL	PRIMARY KEY,
	UnitTypeDescription		varchar(20)					NOT NULL
)

CREATE TABLE UnitRate
(
	UnitRateID				smallint IDENTITY(1,1)		NOT NULL	PRIMARY KEY,
	UnitRate				smallmoney					NOT NULL,
	UnitRateBeginDate		date						NOT NULL,
	UnitRateEndDate			date						NOT NULL,
	UnitRateDescription		varchar(50)					NULL,
	UnitRateActive			bit							NOT NULL,
	PropertyID				smallint					NOT NULL,
	UnitTypeID				tinyint						NOT NULL
)

CREATE TABLE UnitAmenity
(
	AmenityID		smallint		NOT NULL,
	UnitID			smallint		NOT NULL
)

CREATE TABLE Amenity
(
	AmenityID				smallint IDENTITY(1,1)		NOT NULL	PRIMARY KEY,
	AmenityDescription		varchar(50)					NOT NULL
)

CREATE TABLE Property
(
	PropertyID				smallint			NOT NULL	PRIMARY KEY,
	PropertyName			varchar(50)			NOT NULL,
	PropertyAddress			varchar(200)		NOT NULL,
	PropertyCity			varchar(50)			NOT NULL,
	PropertyState			char(2)				NULL,
	PropertyPostalCode		varchar(10)			NOT NULL,
	PropertyCountry			varchar(20)			NOT NULL,
	PropertyPhone			varchar(20)			NOT NULL,
	PropertyMgmtFee			decimal(4,2)		NOT NULL,
	PropertyWebAddress		varchar(100)		NULL,
	TaxLocationID			smallint			NULL
)

CREATE TABLE PropertyAmenity
(
	AmenityID		smallint		NOT NULL,
	PropertyID		smallint		NOT NULL
)

CREATE TABLE TaxLocation
(
	TaxLocationID		smallint IDENTITY(1,1)		NOT NULL	PRIMARY KEY,
	TaxCounty			varchar(50)					NOT NULL,
	TaxState			char(2)						NOT NULL
)

CREATE TABLE TaxRate
(
	TaxID				int IDENTITY(1,1)		NOT NULL	PRIMARY KEY,
	TaxRate				decimal(5,3)			NOT NULL,
	TaxType				char(1)					NOT NULL,
	TaxDescription		varchar(50)				NOT NULL,
	TaxStartDate		date					NOT NULL,
	TaxEndDate			date					NULL,
	TaxLocationID		smallint				NOT NULL
)

GO

-- Creating foreign keys (pks in table creation)

ALTER TABLE Reservation
	ADD CONSTRAINT FK2_UnitRateID
	FOREIGN KEY (UnitRateID) 
	REFERENCES UnitRate(UnitRateID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE Reservation
	ADD CONSTRAINT FK3_PersonID
	FOREIGN KEY (PersonID) 
	REFERENCES Person(PersonID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE Folio
	ADD CONSTRAINT FK3_ReservationID
	FOREIGN KEY (ReservationID) 
	REFERENCES Reservation(ReservationID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE FolioTransaction
	ADD CONSTRAINT FK1_TransCategoryID
	FOREIGN KEY (TransCategoryID)
	REFERENCES TransCategory(TransCategoryID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE FolioTransaction
	ADD CONSTRAINT FK2_FolioID
	FOREIGN KEY (FolioID)
	REFERENCES Folio(FolioID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE UnitOwner
	ADD CONSTRAINT FK1_UnitID
	FOREIGN KEY (UnitID)
	REFERENCES Unit(UnitID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE UnitOwner
	ADD CONSTRAINT FK2_PersonID
	FOREIGN KEY (PersonID)
	REFERENCES Person(PersonID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE Unit
	ADD CONSTRAINT FK1_UnitTypeID
	FOREIGN KEY (UnitTypeID)
	REFERENCES UnitType(UnitTypeID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE UnitRate
	ADD CONSTRAINT FK1_PropertyID
	FOREIGN KEY (PropertyID)
	REFERENCES Property(PropertyID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE UnitRate
	ADD CONSTRAINT FK2_UnitTypeID
	FOREIGN KEY (UnitTypeID)
	REFERENCES UnitType(UnitTypeID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE UnitAmenity
	ADD CONSTRAINT FK1_AmenityID
	FOREIGN KEY (AmenityID)
	REFERENCES Amenity(AmenityID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE UnitAmenity
	ADD CONSTRAINT FK2_UnitID
	FOREIGN KEY (UnitID)
	REFERENCES Unit(UnitID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE Property
	ADD CONSTRAINT FK1_TaxLocationID
	FOREIGN KEY (TaxLocationID)
	REFERENCES TaxLocation(TaxLocationID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE PropertyAmenity
	ADD CONSTRAINT FK2_AmenityID
	FOREIGN KEY (AmenityID)
	REFERENCES Amenity(AmenityID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE PropertyAmenity
	ADD CONSTRAINT FK2_PropertyID
	FOREIGN KEY (PropertyID)
	REFERENCES Property(PropertyID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE TaxRate
	ADD CONSTRAINT FK2_TaxLocationID
	FOREIGN KEY (TaxLocationID)
	REFERENCES TaxLocation(TaxLocationID)
	ON UPDATE Cascade
	ON DELETE Cascade

GO

-- Bulk inserting data into Stage dir

BULK INSERT Amenity FROM 'C:\Stage\Amenity.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT Folio FROM 'C:\Stage\Folio.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT FolioTransaction FROM 'C:\Stage\FolioTransaction.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT Person FROM 'C:\Stage\Person.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT Property FROM 'C:\Stage\Property.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT PropertyAmenity FROM 'C:\Stage\PropertyAmenity.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT Reservation FROM 'C:\Stage\Reservation.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT TaxLocation FROM 'C:\Stage\TaxLocation.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT TaxRate FROM 'C:\Stage\TaxRate.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT TransCategory FROM 'C:\Stage\TransCategory.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT Unit FROM 'C:\Stage\Unit.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT UnitAmenity FROM 'C:\Stage\UnitAmenity.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT UnitOwner FROM 'C:\Stage\UnitOwner.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT UnitRate FROM 'C:\Stage\UnitRate.txt' WITH (FIELDTERMINATOR = '|')

BULK INSERT UnitType FROM 'C:\Stage\UnitType.txt' WITH (FIELDTERMINATOR = '|')