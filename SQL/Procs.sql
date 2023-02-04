-- Procs

-- Specify database
USE Shaneen_TRAMS

GO

-- Check if SP_InsertReservation exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'SP_InsertReservation')

-- If it does then DROP it
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

-- Check if SP_InsertPerson exists
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE SPECIFIC_NAME = 'SP_InsertPerson')

-- If it does then DROP it
DROP PROCEDURE SP_InsertPerson

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
		@ResDate			= '7/21/2015',
		@ResStatus			= 'A',
		@ResCheckInDate		= '7/21/2015',
		@ResNights			= 3,
		@ResQuotedRate		= 89.00,
		@ResDepositPaid		= 100.00,
		@ResCCAuth			= '123456789',
		@UnitRateID			= 1,
		@PersonID			= @@IDENTITY
END -- END SP_InsertPerson

GO

-- Check if FN_GetLodgingTaxRate exists
IF EXISTS(SELECT name FROM sys.objects WHERE name = N'FN_GetLodgingTaxRate' ) 

-- If it does then DROP it
DROP FUNCTION FN_GetLodgingTaxRate;

GO

-- FN_GetLodgingTaxRate creation
CREATE FUNCTION dbo.FN_GetLodgingTaxRate
(
	@PropertyID smallint,
	@Date datetime
)

RETURNS decimal(5,2)

AS

BEGIN
	DECLARE @result decimal(5,2)
	SET @result = 0

	SET @result =
	(
		SELECT TR.TaxRate
		FROM TAXRATE TR
		JOIN TAXLOCATION TL ON TL.TaxLocationID = TR.TaxLocationID
		JOIN PROPERTY P ON P.TaxLocationID = TL.TaxLocationID
		WHERE P.PropertyID = @PropertyID
		AND TR.TaxType = 'L'
		AND @Date BETWEEN TR.TaxStartDate AND TR.TaxEndDate
	) / 100

	IF @result IS NULL
		SET @result = 0
	
	RETURN @result
END -- END FN_GetLodgingTaxRate

GO

-- Check if FN_GetQuotedRate exists
IF EXISTS(SELECT name FROM sys.objects WHERE name = N'FN_GetQuotedRate')

-- If it does then DROP it 
DROP FUNCTION FN_GetQuotedRate;

GO

-- FN_GetQuotedRate creation
CREATE FUNCTION dbo.FN_GetQuotedRate
(
	@BeginDate		DATE,
	@EndDate		DATE,
	@PropertyID		SMALLINT,
	@UnitTypeID		TINYINT
)

RETURNS @ValidRates TABLE
(
	[UnitRate]				SMALLMONEY NULL,
	[UnitTypeDescription]	VARCHAR(20) NULL,
	[UnitRateDescription]	VARCHAR(50) NOT NULL
)

AS

BEGIN
	IF DATEDIFF(dd, @BeginDate, @EndDate) < 0
		BEGIN
			INSERT INTO @ValidRates
			SELECT '', '', 'ERROR!! Begin Date must be less than End Date'
		END

	ELSE
		INSERT INTO @ValidRates
		SELECT TOP 1 MAX(UR.UnitRate), UT.UnitTypeDescription, UR.UnitRateDescription
		FROM UNITRATE UR
		JOIN UNITTYPE UT ON UT.UnitTypeID = UR.UnitTypeID
		WHERE @PropertyID = UR.PropertyID
		AND @UnitTypeID = UR.UnitTypeID 
		AND (@BeginDate BETWEEN UR.UnitRateBeginDate AND UR.UnitRateEndDate
			OR @EndDate BETWEEN UR.UnitRateBeginDate AND UR.UnitRateEndDate)
		GROUP BY UT.UnitTypeDescription, UR.UnitRateDescription

	RETURN
END -- END FN_GetQuotedRate

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

-- #1 TR_UnitIDMustExist
DROP TRIGGER TR_UnitIDMustExist

GO

-- TR_UnitIDMustExist creation
CREATE TRIGGER TR_UnitIDMustExist ON Folio

AFTER INSERT, UPDATE

AS

IF EXISTS
(
	SELECT 'Something'
	FROM Inserted I
	LEFT JOIN Unit U ON I.UnitID = U.UnitID
	WHERE U.UnitID IS NULL
)

BEGIN
	RAISERROR('Not a valid Unit ID', 1, 1)
	ROLLBACK
END -- END TR_UnitIDMustExist

GO

-- #1A Bad UnitID demo
INSERT INTO Folio
VALUES('C', '89.00', '7/21/2015', '7/24/2015', 999, 46)

GO

-- #1B Good UnitID demo
INSERT INTO Folio
VALUES('C', '89.00', '7/21/2015', '7/24/2015', 10000, 46)

GO

-- #1C Showing all Folio for results
SELECT *
FROM Folio

GO

-- #2 TR_UpdateFolio