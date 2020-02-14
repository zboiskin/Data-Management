--Zachary Boiskin
--Data Management
--Assignment 1


--PROBLEM 1

--PROBLEM,Part A
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
ORDER BY JobTitle ASC

--PROBLEM 1, PART B
SELECT DISTINCT JobTitle
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' OR 
JobTitle Like '%Supervisor%' OR
JobTitle Like '%Vice President%' OR
JobTitle Like 'Chief%'
ORDER BY JobTitle ASC;

--PROBLEM 1, Part C
SELECT COUNT (JobTitle) AS Managers
FROM HumanResources.Employee
WHERE JobTitle LIKE '%Manager%' OR 
JobTitle Like '%Supervisor%' OR
JobTitle Like '%Vice President%' OR
JobTitle Like 'Chief%';
--easier way to do it? any 'contains' feature?

--PROBLEM 1, Part D
SELECT BusinessEntityID AS EmployeeID, JobTitle, BirthDate
FROM HumanResources.Employee
WHERE BirthDate <= '1960-01-12'
ORDER BY BirthDate DESC;

--PROBLEM 1, Part E
SELECT BusinessEntityID AS EmployeeID, JobTitle, BirthDate, HireDate, 
CAST (GETDATE() - CAST (HireDate AS datetime) AS INT)/365 AS EmploymentYears
FROM HumanResources.Employee
WHERE BirthDate <= '1960-01-12'
ORDER BY HireDate ASC;

--Problem 2

--Problem 2, Part A
SELECT Name, ListPrice,SafetyStockLevel
FROM Production.Product
WHERE FinishedGoodsFlag = 1 AND SellEndDate IS NULL 
ORDER BY SafetyStockLevel DESC, Name ASC;

--Problem 2, Part B
SELECT Name, Color
FROM Production.Product
WHERE Name LIKE '%yellow%' AND (Color != 'yellow' OR Color IS NULL)
ORDER BY Name ASC;
--anyway to do it to see all colors without listing them individually?

--Problem 2, Part C
SELECT Name, SellStartDate
FROM Production.Product
WHERE SellStartDate >= '2013-05-01'
AND SellStartDate <= '2013-05-31'
ORDER BY Name;

--Problem 2, Part D
SELECT Name, SellStartDate, DATEPART(weekday,SellStartDate) AS WeekDay
FROM Production.Product
WHERE DATEPART(weekday,SellStartDate) >= 4
ORDER BY SellStartDate ASC, Name ASC;