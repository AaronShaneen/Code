-- Create Procedure

USE Shaneen_TRAMS

GO

-- #1 SP_InsertPerson & SP_InsertReservation

-- Check if SP_InsertPerson exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'SP_InsertPerson')

-- If SP_InsertPerson exists then DROP it
DROP PROCEDURE SP_InsertPerson

GO

-- Check if SP_InsertReservation exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'SP_InsertReservation')

-- If SP_InsertReservation exists then DROP it
DROP PROCEDURE SP_InsertReservation

GO

-- SP_InsertReservation creation
CREATE PROC SP_InsertReservation
	@ResDate			SMALLDATETIME,
	@ResStatus			CHAR(1),
	@ResCheckInDate		DATE,
	@ResNights			TINYINT,
	@ResQuotedRate		SMALLMONEY,
	@ResDepositPaid		SMALLMONEY,
	@ResCCAuth			VARCHAR(25),
	@UnitRateID			SMALLINT,
	@PersonID			INT
AS

BEGIN
	INSERT INTO Reservation
	(
		ResDate,
		ResStatus,
		ResCheckInDate,
		ResNights,
		ResQuotedRate,
		ResDepositPaid,
		ResCCAuth,
		UnitRateID,
		PersonID
	)

	VALUES
	(
		@ResDate,
		@ResStatus,
		@ResCheckInDate,
		@ResNights,
		@ResQuotedRate,
		@ResDepositPaid,
		@ResCCAuth,
		@UnitRateID,
		@PersonID
	)
END -- END SP_InsertReservation

GO

-- SP_InsertPerson creation
CREATE PROC SP_InsertPerson
	@PersonFirst		NVARCHAR(50),
	@PersonLast			NVARCHAR(50),
	@PersonAddress		VARCHAR(50),
	@PersonCity			VARCHAR(50),
	@PersonState		CHAR(2) = NULL,
	@PersonPostalCode	VARCHAR(10),
	@PersonCountry		VARCHAR(20),
	@PersonPhone		VARCHAR(20),
	@PersonEmail		VARCHAR(200)
AS

BEGIN
	INSERT INTO Person
	(
		PersonFirst,
		PersonLast,
		PersonAddress,
		PersonCity,
		PersonState,
		PersonPostalCode,
		PersonCountry,
		PersonPhone,
		PersonEmail
	)

	VALUES
	(
		@PersonFirst,
		@PersonLast,
		@PersonAddress,
		@PersonCity,
		@PersonState,
		@PersonPostalCode,
		@PersonCountry,
		@PersonPhone,
		@PersonEmail
	)

	EXEC SP_InsertReservation
		@ResDate			= '4/11/2016',
		@ResStatus			= 'A',
		@ResCheckInDate		= '4/11/2016',
		@ResNights			= '4',
		@ResQuotedRate		= '89.00',
		@ResDepositPaid		= '100.00',
		@ResCCAuth			= '123456789',
		@UnitRateID			= '1',
		@PersonID			= @@IDENTITY
END -- END SP_InsertPerson

GO

-- Adding myself to the Person table
EXEC SP_InsertPerson
	@PersonFirst			= 'Aaron',
	@PersonLast				= 'Shaneen',
	@PersonAddress			= '123 Street Ave',
	@PersonCity				= 'Ogden',
	@PersonState			= 'UT',
	@PersonPostalCode		= '12345',
	@PersonCountry			= 'USA',
	@PersonPhone			= '123-456-7890',
	@PersonEmail			= 'my@email.com'

GO

-- Show myself added to the Person table
SELECT *
FROM Person

GO

-- Show my new reservation from the Reservation table
SELECT *
FROM Reservation

GO

-- #2 SP_UpdatePrices

-- Check if SP_UpdatePrices exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'SP_UpdatePrices')

-- If SP_UpdatePrices exists then DROP it
DROP PROCEDURE SP_UpdatePrices

GO

-- SP_UpdatePrices creation
CREATE PROC SP_UpdatePrices
	@PropertyID			SMALLINT,
	@PercentChange		DECIMAL(6,2)
AS

BEGIN
	IF @PercentChange > 0
		BEGIN
			UPDATE UnitRate
			SET UnitRate = CEILING(UnitRate + (UnitRate * (@PercentChange / 100)))
			WHERE PropertyID = @PropertyID
				AND GETDATE() >= UnitRateBeginDate
				AND GETDATE() <= UnitRateEndDate
		END

	ELSE
		BEGIN
			UPDATE UnitRate
			SET UnitRate = FLOOR(UnitRate + (UnitRate * (@PercentChange / 100)))
			WHERE PropertyID = @PropertyID
				AND GETDATE() >= UnitRateBeginDate
				AND GETDATE() <= UnitRateEndDate
		END
END -- END SP_UpdatePrices

GO

-- Decreasing PropertyID 10000 by 6.66%
EXEC SP_UpdatePrices 
	@PropertyID		= 10000,
	@PercentChange	= -06.66

GO

-- Showing changes to PropertyID 10000
SELECT *
FROM UnitRate
WHERE PropertyID = 10000

GO

-- Decreasing PropertyID 17000 by 5%
EXEC SP_UpdatePrices 
	@PropertyID		= 17000,
	@PercentChange	= 5.00

GO

-- Showing changes to PropertyID 17000
SELECT *
FROM UnitRate
WHERE PropertyID = 17000

GO

-- #3 SP_UpdateResDetail

-- Check if SP_UpdateResDetail exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'SP_UpdateResDetail')

-- If SP_UpdateResDetail exists then DROP it
DROP PROCEDURE SP_UpdateResDetail

GO

-- SP_UpdateResDetail creation
CREATE PROC SP_UpdateResDetail
	@ReservationID		INT,
	@ResCheckInDate		DATE,
	@ResNights			VARCHAR(10),
	@ResStatus			CHAR(1)
AS

BEGIN
	DECLARE @ErrorMsg			VARCHAR(max)
	DECLARE	@CheckResNights		TINYINT

	BEGIN TRY
		SET @CheckResNights = CONVERT(TINYINT, @ResNights)
	END TRY

	BEGIN CATCH
		SET @ErrorMsg = ('Sorry, but "' + @ResNights + '" is not a valid number of nights')
		RAISERROR(@ErrorMsg, -1, -1, @ResNights)
		RETURN -1
	END CATCH

	UPDATE Reservation
	SET ResCheckInDate = @ResCheckInDate,
		ResNights = @ResNights,
		ResStatus = @ResStatus
	WHERE ReservationID = @ReservationID
END -- END SP_UpdateResDetail

GO

-- Attempting first reservation change
EXEC SP_UpdateResDetail
	@ReservationID		= 1,
	@ResCheckInDate		= '02/10/2015',
	@ResNights			= 10,
	@ResStatus			= 'C'

GO

-- Attempting second reservation change
EXEC SP_UpdateResDetail
	@ReservationID		= 2,
	@ResCheckInDate		= '02/15/2015',
	@ResNights			= 4,
	@ResStatus			= 'C'

GO

-- Attempting a third reservation change to trigger error
EXEC SP_UpdateResDetail
	@ReservationID		= 3,
	@ResCheckInDate		= '01/08/2015',
	@ResNights			= 'A',
	@ResStatus			= 'C'

GO

-- #4 SP_ProduceBill

-- Check if SP_ProduceBill exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'SP_ProduceBill')

-- If SP_ProduceBill exists then DROP it
DROP PROCEDURE SP_ProduceBill

GO

-- SP_ProduceBill creation
CREATE PROC SP_ProduceBill
	@FolioID		INT
AS

BEGIN
	DECLARE @GuestName				NVARCHAR(100)
	DECLARE @GuestUnitNumber		VARCHAR(5)
	DECLARE @GuestCheckIn			SMALLDATETIME
	DECLARE @GuestCheckOut			SMALLDATETIME

	DECLARE @FolioTransDesc			VARCHAR(50)
	DECLARE @FolioTransAmount		SMALLMONEY
	DECLARE @FolioTransDate			DATETIME

	SELECT @GuestName = CONCAT(P.PersonLast, ', ', P.PersonFirst),
		@GuestUnitNumber = U.UnitNumber,
		@GuestCheckIn = F.FolioCheckInDate,
		@GuestCheckOut = F.FolioCheckOutDate
	FROM Person P
	INNER JOIN Reservation R ON P.PersonID = R.PersonID
	INNER JOIN Folio F ON R.ReservationID = F.ReservationID
	INNER JOIN FolioTransaction FT ON F.FolioID = FT.FolioID
	INNER JOIN UnitRate UR ON R.UnitRateID = UR.UnitRateID
	INNER JOIN UnitType UT ON UR.UnitTypeID = UT.UnitTypeID
	INNER JOIN Unit U ON UT.UnitTypeID = U.UnitTypeID
	WHERE F.FolioID = @FolioID
	GROUP BY P.PersonFirst, P.PersonLast, U.UnitNumber, F.FolioCheckInDate, F.FolioCheckOutDate

	PRINT 'Guest Details'
	PRINT @GuestName
	PRINT @GuestUnitNumber
	PRINT @GuestCheckIn
	PRINT @GuestCheckOut

	DECLARE GuestFolioCursor CURSOR FOR
	SELECT TransDescription, TransAmount, TransDate
	FROM FolioTransaction
	WHERE FolioID = @FolioID

	OPEN GuestFolioCursor

	FETCH NEXT FROM GuestFolioCursor
	INTO @FolioTransDesc, @FolioTransAmount, @FolioTransDate

	WHILE @@FETCH_STATUS = 0

	BEGIN
		PRINT 'Transaction Description: '	+ @FolioTransDesc
		PRINT 'Transaction Amount: '		+ CONVERT(VARCHAR, @FolioTransAmount)
		PRINT 'Transaction Date: '			+ CONVERT(VARCHAR, @FolioTransDate)

		FETCH NEXT FROM GuestFolioCursor
		INTO @FolioTransDesc, @FolioTransAmount, @FolioTransDate
	END

	CLOSE GuestFolioCursor
	DEALLOCATE GuestFolioCursor
END -- END SP_ProduceBill

GO

-- SP_ProduceBill demonstration #1
EXEC SP_ProduceBill
	@FolioID = 1

GO

-- SP_ProduceBill demonstration #2
EXEC SP_ProduceBill
	@FolioID = 2

GO

-- SP_ProduceBill demonstration #3
EXEC SP_ProduceBill
	@FolioID = 3

GO