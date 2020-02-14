--Zac Boiskin
--Data Management
--SQL Assignment 2

USE AdventureWorks2014;

--PROBLEM 1
--A
SELECT Sales.SalesTerritory.Name AS TerritoryName, ROUND(SUM(SubTotal),0) AS TotalSalesRevenue
FROM Sales.SalesOrderHeader
INNER JOIN Sales.SalesTerritory
ON Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID
GROUP BY Sales.SalesTerritory.Name
ORDER BY TotalSalesRevenue DESC;


--Problem 1, B
SELECT Sales.SalesTerritory.Name AS TerritoryName, 
DATEPART(month,Sales.SalesOrderHeader.OrderDate) AS SalesMonth,
DATEPART(YEAR,Sales.SalesOrderHeader.OrderDate) AS SalesYear, 
ROUND(SUM(SubTotal),0) AS TotalSalesRevenue
FROM Sales.SalesOrderHeader
INNER JOIN Sales.SalesTerritory
ON Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID
WHERE Sales.SalesOrderHeader.OrderDate BETWEEN '2013/01/01' AND '2013/12/31'
GROUP BY Sales.SalesTerritory.Name, 
DATEPART(month,Sales.SalesOrderHeader.OrderDate), 
DATEPART(YEAR,Sales.SalesOrderHeader.OrderDate)
ORDER BY Sales.SalesTerritory.Name ASC, SalesMonth ASC;

--Problem 1, C
SELECT DISTINCT (Sales.SalesTerritory.Name) AS AwardWinners
FROM Sales.SalesTerritory
INNER JOIN Sales.SalesOrderHeader
ON Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID 
WHERE Sales.SalesOrderHeader.OrderDate BETWEEN '2013/01/01' AND '2013/12/31'
GROUP BY SalesTerritory.Name, DATEPART(month,Sales.SalesOrderHeader.OrderDate)
HAVING SUM(SalesOrderHeader.SubTotal) > 750000
ORDER BY Name

--Problem 1, D
SELECT DISTINCT Sales.SalesTerritory.Name
FROM Sales.SalesTerritory
EXCEPT
SELECT DISTINCT (Sales.SalesTerritory.Name) AS AwardWinners
FROM Sales.SalesTerritory
INNER JOIN Sales.SalesOrderHeader
ON Sales.SalesTerritory.TerritoryID = Sales.SalesOrderHeader.TerritoryID 
WHERE Sales.SalesOrderHeader.OrderDate BETWEEN '2013/01/01' AND '2013/12/31'
GROUP BY SalesTerritory.Name, DATEPART(month,Sales.SalesOrderHeader.OrderDate)
HAVING SUM(SalesOrderHeader.SubTotal) > 750000
ORDER BY Sales.SalesTerritory.Name

--PROBLEM 2
--PROBLEM 2, A
SELECT Production.Product.Name, SUM(Sales.SalesOrderDetail.OrderQty) AS TotalQuantity
FROM Production.Product
INNER JOIN Sales.SalesOrderDetail 
ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
WHERE FinishedGoodsFlag = 1
GROUP BY Name
HAVING SUM(Sales.SalesOrderDetail.OrderQty) < 50
ORDER BY SUM(Sales.SalesOrderDetail.OrderQty);

--PROBLEM 2, B
SELECT Person.CountryRegion.Name AS Country, MAX(Sales.SalesTaxRate.TaxRate) AS MaxTaxRate
FROM Sales.SalesTaxRate
INNER JOIN Person.StateProvince
ON Sales.SalesTaxRate.StateProvinceID = Person.StateProvince.StateProvinceID
INNER JOIN Person.CountryRegion
ON Person.StateProvince.CountryRegionCode = Person.CountryRegion.CountryRegionCode
GROUP BY Person.CountryRegion.Name
ORDER BY MAX(Sales.SalesTaxRate.TaxRate) DESC;

--PROBLEM 2, C
SELECT DISTINCT Sales.Store.Name AS Store, Sales.SalesTerritory.Name As SalesTerritory
FROM Sales.SalesOrderDetail
INNER JOIN Production.Product
ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
INNER JOIN Sales.SalesOrderHeader
ON Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
INNER JOIN Sales.SalesTerritory
ON Sales.SalesOrderHeader.TerritoryID = Sales.SalesTerritory.TerritoryID
INNER JOIN Sales.Customer
ON Sales.SalesOrderHeader.CustomerID = Customer.CustomerID
INNER JOIN Sales.Store
ON Customer.StoreID = Store.BusinessEntityID
WHERE Production.Product.Name LIKE '%helmet%'
AND Sales.SalesOrderHeader.ShipDate BETWEEN '2014-02-01' AND '2014-02-05'
ORDER BY SalesTerritory ASC, Store.Name ASC;