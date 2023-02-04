-- Pivots

-- GO USE
USE AdventureWorks
GO

-- PIVOTING
SELECT h.SalesOrderNumber, m.Name, AVG(h.TotalDue) AS AvgDue
FROM Purchasing.ShipMethod m
JOIN Sales.SalesOrderHeader h
ON m.ShipMethodID = h.ShipMethodID
GROUP BY h.SalesOrderNumber, m.Name

SELECT TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID

-- USING ABOVE QUERIES FOR PIVOT
SELECT TerritoryID, [XRQ - TRUCK GROUND], [CARGO TRANSPORT 5]
FROM /*pulled from above*/
(SELECT m.Name, h.TerritoryID, AVG(h.TotalDue) AS AvgDue
FROM Purchasing.ShipMethod m
JOIN Sales.SalesOrderHeader h
ON m.ShipMethodID = h.ShipMethodID
GROUP BY h.ShipMethodID, m.Name, h.TerritoryID) sq1
PIVOT (SUM(AvgDue) FOR sq1.Name IN ([XRQ - TRUCK GROUND], [CARGO TRANSPORT 5])) p

-- MAKING PIVOT DYNAMIC
DECLARE @columns NVARCHAR(MAX), @sq1 NVARCHAR(MAX);
SET @columns = N'';
SELECT @columns += N',' + QUOTENAME(Name)
FROM Purchasing.ShipMethod AS x;
SET @columns = STUFF(@columns, 1, 1, '');

SET @sq1 = N'SELECT TerritoryID, ' + @columns + N'
FROM
(SELECT m.Name, h.TerritoryID, AVG(h.TotalDue) AS AvgDue
FROM Purchasing.ShipMethod m
JOIN Sales.SalesOrderHeader h
ON m.ShipMethodID = h.ShipMethodID
GROUP BY h.ShipMethodID, m.Name, h.TerritoryID) sq1
PIVOT (SUM(AvgDue) FOR sq1.Name IN (' + @columns + N')) pvt';

PRINT @sq1;

EXECUTE sp_executesql @sq1;

-- DO ANOTHER
SELECT pc.Name, sc.Name
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory sc
ON pc.ProductCategoryID = sc.ProductCategoryID

-- MAKE PIVOT / DYNAMIC
DECLARE @columns2 NVARCHAR(MAX), @sql2 NVARCHAR(MAX);
SET @columns2 = N'';
SELECT @columns2 += N',' + QUOTENAME(Name) /* Creates a comma separated list of column names */
FROM Production.ProductCategory AS x;
SET @columns2 = STUFF(@columns2, 1, 1, ''); /* This removes the initial comman in the list */

SET @sql2 = N'SELECT OrderMonth,' + @columns2 + N'
FROM
(SELECT pc.Name AS CategoryName, sd.OrderQty, DATENAME(mm, sh.OrderDate) AS ORDERMONTH
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory sc
ON pc.ProductCategoryID = sc.ProductCategoryID
JOIN Production.Product pr
ON pr.ProductSubcategoryID = sc.ProductSubcategoryID
JOIN Sales.SalesOrderDetail sd
ON pr.ProductID = sd.ProductID
JOIN Sales.SalesOrderHeader sh
ON sd.SalesOrderID = sh.SalesOrderID) dataTable
PIVOT (SUM(OrderQty) FOR CategoryName IN ('+ @columns2 + N')) AS PivotTable';

EXECUTE sp_executesql @sql2;

-- FOR MONGODB
SELECT 'db.subcategories.save({"catID":' + CONVERT(varchar(2), pc.ProductCategoryID)
+ ',"catName":"' + pc.Name
+ '","subName":"' + ps.Name + '"});'
FROM Production.ProductSubcategory ps
JOIN Production.ProductCategory pc
ON ps.ProductCategoryID = pc.ProductCategoryID

-- AGGREGATION
SELECT 'db.employeePay.save({'
+ '"businessEntityID":"' + CONVERT(VARCHAR(MAX), e.BusinessEntityID) + '",'
+ '"rate":' + CONVERT(VARCHAR(MAX), h.rate) + ','
+ '"firstName":"' + p.FirstName + '",' + '"lastName":"' + p.LastName + '"});'
FROM HumanResources.EmployeePayHistory h
JOIN HumanResources.Employee e
ON h.BusinessEntityID = e.BusinessEntityID
JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID

-- ?
SELECT s.Name, p.PersonType, COUNT(*) AS NumOfEmployees
FROM HumanResources.Employee e
JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID
JOIN Person.BusinessEntity b
ON p.BusinessEntityID = b.BusinessEntityID
JOIN Person.BusinessEntityAddress a
ON b.BusinessEntityID = a.BusinessEntityID
JOIN Person.Address d
ON a.AddressID = d.AddressID
JOIN Person.StateProvince s
ON d.StateProvinceID = s.StateProvinceID
GROUP BY s.Name, p.PersonType

-- PREP FOR MONGO
SELECT s.Name, p.PersonType, p.BusinessEntityID
FROM HumanResources.Employee e
JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID
JOIN Person.BusinessEntity b
ON p.BusinessEntityID = b.BusinessEntityID
JOIN Person.BusinessEntityAddress a
ON b.BusinessEntityID = a.BusinessEntityID
JOIN Person.Address d
ON a.AddressID = d.AddressID
JOIN Person.StateProvince s
ON d.StateProvinceID = s.StateProvinceID

-- CONVERT TO MONGO
SELECT 'db.employeeCount.save({'
+ '"stateName":"' + s.Name + '",'
+ '"personType":"' + p.PersonType + '",'
+ '"businessEntityID":"' + CONVERT(VARCHAR(MAX), p.BusinessEntityID) + '"});'
FROM HumanResources.Employee e
JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID
JOIN Person.BusinessEntity b
ON p.BusinessEntityID = b.BusinessEntityID
JOIN Person.BusinessEntityAddress a
ON b.BusinessEntityID = a.BusinessEntityID
JOIN Person.Address d
ON a.AddressID = d.AddressID
JOIN Person.StateProvince s
ON d.StateProvinceID = s.StateProvinceID