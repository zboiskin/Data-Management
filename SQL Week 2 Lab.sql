--select max, min, avg list price of finished goods
SELECT MAX(ListPrice), MIN(ListPrice), ROUND(AVG(ListPrice),2)
FROM Production.Product 
WHERE FinishedGoodsFlag = 1

--report showing job titles that have been held by more than 10 employees, sort by # of employees who have held each title in DESC

SELECT JobTitle, COUNT(*) AS Employees
FROM HumanResources.Employee
GROUP BY JobTitle
HAVING COUNT(*) > 10
ORDER BY COUNT(*) DESC;

--provide a list of names and emails that opted into the marketing campaign

SELECT FirstName, LastName, EmailAddress.EmailAddressID
FROM Person.Person
INNER JOIN Person.EmailAddress
ON Person.BusinessEntityID = EmailAddress.BusinessEntityID
WHERE Person.EmailPromotion = 1

--unit price vs list price

SELECT *
FROM Sales.SalesOrderDetail
INNER JOIN Production.Product
ON SalesOrderDetail.ProductID = Product.ProductID

--produce a list of employees who have not changed their password

--SELECT *
--FROM Person.Person p
--INNER JOIN Person.Password
--ON p.BusinessEntityID = Person.Password.BusinessEntityID
--INNER JOIN p
--ON p.BusinessEntityID = HumanResources.Employee.BusinessEntityID; 

SELECT p.FirstName, p.LastName, ea.EmailAddress, pw.ModifiedDate AS PasswordChanged
FROM HumanResources.Employee e
INNER JOIN Person.Person p
ON e.BusinessEntityID = p.BusinessEntityID
INNER JOIN Person.Password pw
ON p.BusinessEntityID = pw.BusinessEntityID
INNER JOIN Person.EmailAddress ea
ON p.BusinessEntityID = ea.BusinessEntityID;

   