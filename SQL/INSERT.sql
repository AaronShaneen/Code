-- INSERT

USE Shaneen_TRAMS

PRINT 'Beginning #1 - Displaying all UnitRateIDs, UnitRates, UnitTypeDescriptions
	and UnitTypeIDs for PropertyID 11000 valid on July 7 2015'

PRINT ''

GO

SELECT UnitRateID, UnitRate, UnitTypeDescription, UT.UnitTypeID
FROM UnitRate UR
	JOIN UnitType UT ON UR.UnitTypeID = UT.UnitTypeID
	JOIN Property PR ON UR.PropertyID = PR.PropertyID
WHERE PR.PropertyID = 11000
	AND UnitRateBeginDate < 'July 7 2015'
	AND UnitRateEndDate > 'July 7 2015'

GO

PRINT ''

PRINT 'Beginning #2 - Displaying Lodging TaxRate for PropertyID 11000 valid on July 7 2015'

GO

SELECT TR.TaxRate
FROM TaxLocation TL
	JOIN Property PR ON TL.TaxLocationID = PR.TaxLocationID
	JOIN UnitRate UR ON PR.PropertyID = UR.PropertyID
	JOIN TaxRate TR ON TL.TaxLocationID = TR.TaxLocationID
WHERE TaxType = 'L'
	AND UnitRateBeginDate < 'July 7 2015'
	AND UnitRateEndDate > 'July 7 2015'
GROUP BY TR.TaxRate

GO

PRINT ''

PRINT 'Beginning #3A - Adding myself as a new person to the TRAMS DB'

GO

INSERT
INTO Person
VALUES ('Aaron', 'Shaneen', '123 Street Ave', 'Ogden', 'UT', '88888', 'America', '5555555555', 'myemail@email.com')

GO

PRINT ''

PRINT 'Beginning #3B - Adding a reservation for myself at the Grand Oasis Hotal for this summer'

GO

INSERT
INTO Reservation
VALUES (GETDATE(), 'A', '7 July 2015', '3', '136.45', '136.45', 'pending', '13', @@IDENTITY)

GO

PRINT ''

PRINT 'Beginning #3C - Displaying all reservations to show changes'

GO

SELECT *
FROM Reservation

GO

PRINT ''

PRINT 'Beginning #4 - Updating PropertyID 16000 for pricing'

GO

UPDATE UnitRate
SET UnitRate = (UnitRate - FLOOR(UnitRate * 0.05))
WHERE PropertyID = 16000
	AND UnitRateDescription = 'High Season Rate'

UPDATE UnitRate
SET UnitRate = (UnitRate + CEILING(UnitRate * 0.05))
WHERE PropertyID = 16000
	AND UnitRateDescription = 'Standard Rate'

GO

PRINT ''

PRINT 'Beginning #4B - Displaying unit rates for PropertyID 16000'

GO

SELECT *
FROM UnitRate
WHERE PropertyID = 16000

GO

PRINT ''

PRINT 'Beginning #5 - Displaying PropertyName, UnitTypeDescription, UnitRate
	for all studio and 1 bedroom units with a price <= $199.00 per night'

GO

CREATE VIEW vw_PropertyInfo AS
SELECT PR.PropertyName, UT.UnitTypeDescription, UnitRate	--CAST $
FROM UnitRate UR
	JOIN UnitType UT ON UR.UnitTypeID = UT.UnitTypeID
	JOIN Property PR ON UR.PropertyID = PR.PropertyID
WHERE UnitRate <= 199.00

GO

PRINT ''

PRINT 'Beginning #6 - Displaying PropertyName and count of units that have
	"Refridgerator" or "Fridge" as a unit amenity'

GO

--TO DO

GO

PRINT ''

PRINT 'Beginning #7 - Displaying PropertyName average length of stay'

GO

--TO DO

GO

PRINT ''

PRINT 'Beginning #8 - Displaying PersonFirst, PersonLast, UnitTypeDescription, Arrival Date,
	and depature date for all reservations with an arrival date between Mon-Thurs'

GO

--TO DO

GO

PRINT ''

PRINT 'Beginning #9 - Displaying the sum of all 2015 folio transactions grouped by description and month'

GO

CREATE VIEW vw_FolioTransactionInfo AS
SELECT SUM(TransAmount) --FIX
FROM FolioTransaction
WHERE TransDate = 2015
GROUP BY TransDescription, TransDate