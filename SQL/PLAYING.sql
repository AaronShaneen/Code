-- Playing around

USE AdventureWorks

GO

-- Finding avg pay for females sales dept
SELECT emp.JobTitle, AVG(eph.Rate) AS AverageRate
FROM HumanResources.Employee emp
INNER JOIN HumanResources.EmployeePayHistory eph
ON emp.BusinessEntityID = eph.BusinessEntityID
INNER JOIN HumanResources.EmployeeDepartmentHistory edh
ON emp.BusinessEntityID = edh.BusinessEntityID
INNER JOIN HumanResources.Department dep
ON edh.DepartmentID = dep.DepartmentID
WHERE emp.Gender = 'F' AND dep.Name = 'Sales'
GROUP BY eph.Rate, emp.JobTitle;

-- First/last name, total for customers that spent over $2k in one order
SELECT DISTINCT per.FirstName, per.LastName, sod.LineTotal
FROM Person.Person per
INNER JOIN Sales.SalesOrderHeader soh
ON per.BusinessEntityID = soh.CustomerID
INNER JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = sod.SalesOrderID
WHERE sod.LineTotal > 2000.00;

-- Max discount given to product with a silver color
SELECT MAX(sod.UnitPriceDiscount) AS MaxDiscount
FROM Sales.SalesOrderDetail sod
JOIN Sales.SpecialOfferProduct sop
ON sod.ProductID = sop.ProductID
JOIN Production.Product p
ON sop.ProductID = p.ProductID
WHERE p.Color = 'Silver'

-- Employees with the same job title start shift at the same time
SELECT e.JobTitle, COUNT(e.BusinessEntityID) AS NumOfSameShift
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh
ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Shift s
ON edh.ShiftID = s.ShiftID
GROUP BY e.JobTitle, s.StartTime
HAVING COUNT(*) > 1

-- First/last name, gender, age, job title of oldest employee
SELECT p.FirstName, p.LastName, e.Gender, (DATEDIFF(dd, e.BirthDate, GETDATE())/365) AS Age, e.JobTitle
FROM HumanResources.Employee e
JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.BirthDate = (SELECT MIN(BirthDate) FROM HumanResources.Employee)

-- Display vendor ID, credit rating, address for vendors that have a credit rating higher than 500
SELECT DISTINCT v.BusinessEntityID, v.CreditRating, d.AddressLine1, d.City, s.Name
FROM Purchasing.Vendor v
JOIN Person.BusinessEntity b
ON v.BusinessEntityID = b.BusinessEntityID
JOIN Person.BusinessEntityAddress a
ON b.BusinessEntityID = a.BusinessEntityID
JOIN Person.Address d
ON a.AddressID = d.AddressID
JOIN Person.StateProvince s
ON d.StateProvinceID = s.StateProvinceID
WHERE v.CreditRating > 500

-- Display ID, name, CountryRegionCode, group, count of territory that has most customers
SELECT t.TerritoryID, t.Name, t.CountryRegionCode, [Group], COUNT(c.CustomerID) AS NumOfCustomers
FROM Sales.Customer c
JOIN Sales.SalesTerritory t
ON c.TerritoryID = t.TerritoryID
GROUP BY t.TerritoryID, t.Name, t.CountryRegionCode, [Group]
HAVING COUNT(c.CustomerID) = 
(SELECT MAX(x.NumOfCustomers)
FROM
(SELECT t.TerritoryID, t.Name, t.CountryRegionCode, [Group], COUNT(c.CustomerID) AS NumOfCustomers
FROM Sales.Customer c
JOIN Sales.SalesTerritory t
ON c.TerritoryID = t.TerritoryID
GROUP BY t.TerritoryID, t.Name, t.CountryRegionCode, [Group]) x )

-- Lists territory ID, name, number of states/provinces in territory
SELECT t.TerritoryID, t.Name, COUNT(*) AS StatesPerTerritory
FROM Person.StateProvince s
JOIN Sales.SalesTerritory t
ON s.TerritoryID = t.TerritoryID
GROUP BY t.TerritoryID, t.Name

-- SQL to Mongo script of territory ID's, names, state/province IDs, and state names
SELECT 'db.territoryState.save({'
+ '"territoryID":"' + CONVERT(VARCHAR(MAX), t.TerritoryID) + '",'
+ '"territoryName":"' + t.Name + '",'
+ '"stateID":"' + CONVERT(VARCHAR(MAX), s.StateProvinceID) + '",'
+ '"stateName":"' + s.Name + '"});'
FROM Person.StateProvince s
JOIN Sales.SalesTerritory t
ON s.TerritoryID = t.TerritoryID

-- Display name of day, avg online order sales subtotal, average in-store order sales subtotal for each day of the week
-- Static query only
SELECT OrderType, [Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday]
FROM
(SELECT AVG(h.SubTotal) AS AvgSubTotal, DATENAME(WEEKDAY, h.OrderDate) AS DayOrdered,
CASE WHEN h.OnlineOrderFlag = 0
THEN 'InStore'
ELSE 'Online'
END AS OrderType
FROM Sales.SalesOrderHeader h
GROUP BY DATENAME(dw, h.OrderDate), h.OnlineOrderFlag) x
PIVOT (SUM(AvgSubTotal) FOR DayOrdered IN ([Sunday], [Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday])) AS PivotTable

/* List each product category and the number of units sold by month. You
should have months as headers across the top and product categories down the
side (Static and Dynamic Pivot Query) */

-- Static Version
SELECT CategoryName, [January], [February], [March], [April], [May], [June], [July], [August], [September], [October], [November], [December]
FROM
(SELECT c.Name AS CategoryName, SUM(d.OrderQty) AS Quantity, DATENAME(MONTH, h.OrderDate) AS MonthOrdered
FROM Production.ProductCategory c
JOIN Production.ProductSubcategory s
ON c.ProductCategoryID = s.ProductCategoryID
JOIN Production.Product p
ON s.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail d
ON p.ProductID = d.ProductID
JOIN Sales.SalesOrderHeader h
ON d.SalesOrderID = h.SalesOrderID
GROUP BY c.Name, DATENAME(MONTH, h.OrderDate)) x
PIVOT (SUM(quantity)
FOR MonthOrdered
IN ([January], [February], [March], [April], [May], [June], [July], [August], [September], [October], [November], [December])) AS PivotTable

-- Dynamic Version
DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);
SET @columns = N'';
SELECT @columns += N',' + QUOTENAME(MonthOrdered)
FROM
(SELECT DISTINCT DATENAME(month, h.OrderDate) AS MonthOrdered, DATEPART(mm, h.OrderDate) AS MonthNum
FROM Sales.SalesOrderHeader h) x
ORDER BY MonthNum;
SET @columns = STUFF(@columns, 1, 1, '');
SELECT @sql = N'SELECT CategoryName, ' + @columns + N'
FROM
(SELECT c.Name AS CategoryName, SUM(d.OrderQty) AS Quantity, DATENAME(MONTH, h.OrderDate) AS MonthOrdered
FROM Production.ProductCategory c
JOIN Production.ProductSubcategory s
ON c.ProductCategoryID = s.ProductCategoryID
JOIN Production.Product p
ON s.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail d
ON p.ProductID = d.ProductID
JOIN Sales.SalesOrderHeader h
ON d.SalesOrderID = h.SalesOrderID
GROUP BY c.Name, DATENAME(MONTH, h.OrderDate)) y
PIVOT (SUM(quantity)
FOR MonthOrdered IN (' + @columns + N')) AS PivotTable';

EXECUTE sp_executesql @sql;