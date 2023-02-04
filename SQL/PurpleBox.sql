-- Purple Box DB

--Creating DB in MasterDB
USE Master

--Checking to see if MyName_Database already exists
IF EXISTS (SELECT * FROM sysdatabases WHERE name='Shaneen_PurpleBox')
DROP DATABASE Shaneen_PurpleBox		--If it does then delete it first

GO

--Creating my database in Master
CREATE DATABASE Shaneen_PurpleBox

ON PRIMARY
(
	NAME = 'Shaneen_PurpleBox',
	FILENAME = 'C:\Stage\Shaneen_PurpleBox.mdf',
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 10%
)

--Creating DB log for backups/rollbacks
LOG ON
(
	NAME = 'Shaneen_PurpleBox_Log',
	FILENAME = 'C:\Stage\Shaneen_PurpleBox.ldf',
	SIZE = 2500KB,
	MAXSIZE = 5MB,
	FILEGROWTH = 500KB
)

GO

--Specifying which database to create the following tables in
USE Shaneen_PurpleBox

GO

--Following tables DO NOT have FK's, PK's only

					--Seems that "User" is a SQL Dev keyword? I know plural table
CREATE TABLE Users	--names is not good practice, so this is just to get it to work
(
	UserID					int	IDENTITY(1,1)	NOT NULL,
	UserPassword			char(10)			NOT NULL,
	VerificationQuestion	char(50)			NOT NULL,
	VerificationAnswer		char(50)			NOT NULL,
	Administrator			bit					NOT NULL,
	BannedStatus			bit					NOT NULL,
	Premium					bit					NOT NULL
)

CREATE TABLE MovieFormat
(
	FormatID	tinyint	IDENTITY(1,1)	NOT NULL,
	FormatType	char(10)				NOT NULL
)

CREATE TABLE Movie
(
	MovieID int NOT NULL IDENTITY(1,1),
	MovieTitle char(50) NOT NULL,
	MovieDescription varchar(140) NOT NULL
)

CREATE TABLE Director
(
	DirectorID int NOT NULL IDENTITY(1,1),
	DirectorFirstName char(20) NULL,
	DirectorLastName char(20) NOT NULL
)

CREATE TABLE Actor
(
	ActorID int NOT NULL IDENTITY(1,1),
	ActorFirstName char(20) NULL,
	ActorLastName char(20) NOT NULL
)

CREATE TABLE Genre
(
	GenreType char(15) NOT NULL,
	GenreDescription char(30) NOT NULL
)

--Following tables DO have FK's
CREATE TABLE PhoneNumber
(
	PhoneNumberID int NOT NULL IDENTITY(1,1),
	UserID int NOT NULL,
	PhoneType varchar(20),
	PhoneNumber varchar(20)
)

CREATE TABLE MovieRental
(
	RentalNum bigint NOT NULL,
	RentalDate smalldatetime NOT NULL,
	ReturnDate smalldatetime NOT NULL,
	UserID int NOT NULL,
	MovieItemID bigint NOT NULL
)

CREATE TABLE MovieItem
(
	MovieItemID bigint NOT NULL IDENTITY(1,1),
	MovieID int NOT NULL,
	FormatID tinyint NOT NULL
)

CREATE TABLE MovieRequest
(
	RequestID bigint NOT NULL IDENTITY(1,1),
	UserID int NOT NULL,
	MovieID int NOT NULL,
	FormatID tinyint NULL
)

CREATE TABLE MovieDirector
(
	MovieID int NOT NULL IDENTITY(1,1),
	DirectorID int NOT NULL
)

CREATE TABLE MovieActor
(
	MovieActorID int NOT NULL IDENTITY(1,1),
	ActorID int NOT NULL,
	MovieID int NOT NULL IDENTITY(1,1),
	CharactorPlayed varchar(50) NULL
)

CREATE TABLE MovieGenre
(
	MovieID int NOT NULL IDENTITY(1,1),
	GenreType char(10) NOT NULL
)

GO

--Adding PK's
ALTER TABLE Users
	ADD CONSTRAINT PK_UserID
	PRIMARY KEY (UserID)

ALTER TABLE PhoneNumber
	ADD CONSTRAINT PK_PhoneNumberID
	PRIMARY KEY (PhoneNumberID)

ALTER TABLE MovieRental
	ADD CONSTRAINT PK_RentalNum
	PRIMARY KEY (RentalNum)

ALTER TABLE MovieItem
	ADD CONSTRAINT PK_MovieItemID
	PRIMARY KEY (MovieItemID)

ALTER TABLE MovieFormat
	ADD CONSTRAINT PK_FormatID
	PRIMARY KEY (FormatID)

ALTER TABLE MovieRequest
	ADD CONSTRAINT PK_RequestID
	PRIMARY KEY (RequestID)

ALTER TABLE Movie
	ADD CONSTRAINT PK_MovieID 
	PRIMARY KEY (MovieID)

ALTER TABLE MovieDirector
	ADD CONSTRAINT PK_MovieID
	PRIMARY KEY (MovieID)

ALTER TABLE MovieDirector
	ADD CONSTRAINT PK_DirectorID
	PRIMARY KEY (DirectorID)

ALTER TABLE MovieActor
	ADD CONSTRAINT PK_MovieActorID
	PRIMARY KEY (MovieActorID)

ALTER TABLE MovieGenre
	ADD CONSTRAINT PK_MovieID
	PRIMARY KEY (MovieID)

ALTER TABLE Director
	ADD CONSTRAINT PK_DirectorID
	PRIMARY KEY (DirectorID)

ALTER TABLE Actor
	ADD CONSTRAINT PK_ActorID
	PRIMARY KEY (ActorID)

ALTER TABLE Genre
	ADD CONSTRAINT PK_GenreType 
	PRIMARY KEY (GenreType)

GO

--Adding FK's
ALTER TABLE PhoneNumber
	ADD CONSTRAINT FK_UserID
	FOREIGN KEY (UserID) REFERENCES Users(UserID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieRental
	ADD CONSTRAINT FK_UserID
	FOREIGN KEY (UserID) REFERENCES Users(UserID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieRental
	ADD CONSTRAINT FK_MovieItemID
	FOREIGN KEY (MovieItemID) REFERENCES MovieItem(MovieItemID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieItem
	ADD CONSTRAINT FK_MovieID
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieItem
	ADD CONSTRAINT FK_FormatID
	FOREIGN KEY (FormatID) REFERENCES MovieFormat(FormatID)
	ON UPDATE Cascade
	ON DELETE Cascade

	ALTER TABLE MovieRequest
	ADD CONSTRAINT FK_UserID
	FOREIGN KEY (UserID) REFERENCES Users(UserID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieRequest
	ADD CONSTRAINT FK_MovieID
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieDirector
	ADD CONSTRAINT FK_MovieID
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieDirector
	ADD CONSTRAINT FK_DirectorID
	FOREIGN KEY (DirectorID) REFERENCES Director(DirectorID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieActor
	ADD CONSTRAINT FK_ActorID
	FOREIGN KEY (ActorID) REFERENCES Actor(ActorID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieActor
	ADD CONSTRAINT FK_MovieID
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieGenre
	ADD CONSTRAINT FK_MovieID
	FOREIGN KEY (MovieID) REFERENCES Movie(MovieID)
	ON UPDATE Cascade
	ON DELETE Cascade

ALTER TABLE MovieGenre
	ADD CONSTRAINT FK_GenreType
	FOREIGN KEY (GenreType) REFERENCES Genre(GenreType)
	ON UPDATE Cascade
	ON DELETE Cascade