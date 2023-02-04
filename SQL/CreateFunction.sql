-- CreateFunction

-- Switching to my TRAMS DB
USE Shaneen_TRAMS

GO

-- #1 dbo.GetLodgingTaxRate FUNCTION

-- Check if dbo.GetLodgingTaxRate exists
IF OBJECT_ID(N'dbo.GetLodgingTaxRate', N'FN') IS NOT NULL

-- If it does then drop it
DROP FUNCTION dbo.GetLodgingTaxRate

GO

-- dbo.GetLodgingTaxRate creation
CREATE FUNCTION dbo.GetLodgingTaxRate
(
	@PropertyID		SMALLINT,
	@Date			DATE
)
RETURNS DECIMAL(5,3)

AS

BEGIN
	DECLARE @TaxRate	DECIMAL(5,3)
	SET @TaxRate = 0.0
	
	SET @TaxRate =
	(SELECT TaxRate
	FROM TaxRate TR
	JOIN TaxLocation TL ON TR.TaxLocationID = TL.TaxLocationID
	JOIN Property P ON TL.TaxLocationID = P.TaxLocationID
	WHERE P.PropertyID = @PropertyID
	AND TaxType = 'L'
	AND @Date BETWEEN TR.TaxStartDate AND TR.TaxEndDate)

	IF @TaxRate IS NULL
		SET @taxrate = 0 
	
	RETURN @taxrate

END

GO

-- #2 dbo.CalculateDeposit

-- Check if dbo.CalculateDeposit exists
IF OBJECT_ID(N'dbo.CalculateDeposit', N'FN') IS NOT NULL

-- If it does then drop it
DROP FUNCTION dbo.CalculateDeposit

GO

-- dbo.CalculateDeposit creation
CREATE FUNCTION dbo.CalculateDeposit
(
	@UnitRateID			SMALLINT,
	@ResCheckInDate		DATE
)
RETURNS SMALLMONEY

AS

BEGIN
	DECLARE @Amount		SMALLMONEY
	SET @Amount = 0

	SET @Amount = 
		(SELECT(UnitRate * (1 + (dbo.GetLodgingTaxRate(PropertyID, ResCheckinDate) / 100)))
		FROM UnitRate UR
		JOIN Reservation R ON UR.UnitRateID = R.UnitRateID
		WHERE UR.UnitRateID = @UnitRateID)
	
	RETURN @Amount
END

GO

-- #3A First demonstration
INSERT INTO Reservation
VALUES(GETDATE(), 'A', '15 Aug 2015', 3, dbo.CalculateDeposit(13,'15 Aug 2015'),
	dbo.CalculateDeposit(13,'15 Aug 2015'), '3A Reults', 13, 7)

GO

-- #3B Second demonstration
INSERT INTO Reservation
VALUES(GETDATE(), 'A', '27 Aug 2015', 3, dbo.CalculateDeposit(21,'27 Aug 2015'),
	dbo.CalculateDeposit(21,'27 Aug 2015'), '3B Reults', 21, 8)

GO

-- #3C Third demonstration
INSERT INTO Reservation
VALUES(GETDATE(), 'A', '25 Sep 2015', 3, dbo.CalculateDeposit(29,'25 Sep 2015'),
	dbo.CalculateDeposit(29,'25 Sep 2015'), '3C Reults', 29, 9)

GO

-- #3D Showing reservation changes
SELECT *
FROM Reservation

GO 