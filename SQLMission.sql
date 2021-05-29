USE SQLMission

GO

--USE OF CREATE TABLE
SELECT 'USE OF CREATE TABLE';

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY, 
	FirstName nvarchar(200) NOT NULL,
	LastName nvarchar(200) NOT NULL,
	Email nvarchar(100) NOT NULL,
	MainAddress nvarchar(200) NOT NULL,
	MainCity nvarchar(50) NOT NULL,
	MainCountry nvarchar(50) NOT NULL,
	MainZip nvarchar(20) NOT NULL
)

CREATE TABLE [dbo].[Orders](
	OrderID int PRIMARY KEY,
	CustomerID int NOT NULL,
	OrderStatusID int NOT NULL,
	OrderDate datetime NOT NULL,
	CurrencyCode nvarchar(3) NOT NULL,
	Total money NOT NULL,
	SubTotal money NOT NULL,
	TaxTotal money NOT NULL,
)

--USE OF INSERT
SELECT 'USE OF INSERT';

INSERT INTO Customers VALUES(1,'Debra','Burks','debra@yahoo.com','167 James St','AL','US','93635');
INSERT INTO Customers VALUES(2,'Diana','Beers','debra@yahoo.com','5353 St Erset','AL','US','31135');
INSERT INTO Customers VALUES(3,'Kasha','Todd','kasha.tod@yahoo.com','1913 E 1130 S','San Pablo', 'CA','94806');
INSERT INTO Customers VALUES(4,'Tameka','Fisher','tameka@aol.com','Amerveldstraat 223', 'Houtvenne','BE','2235');
INSERT INTO Customers VALUES(5,'Daryl','Spence','daryl.spence@aol.com','1913 E 1130 S', 'Spanish Fork', 'AU', '5001');
INSERT INTO Customers VALUES(6,'Marl','Froee','Marl.spence@aol.com','1913 E 1130 S', 'Spanish Fork', 'AU', '5001');
INSERT INTO Customers VALUES(7,'Lirk','Jmee','Lirk.spence@aol.com','1913 E 1130 S', 'Spanish Fork', 'AU', '5001');
INSERT INTO Customers VALUES(8,'Charolette','Rice','charolette@msn.com', '1913 E 1130 S', 'AUCKLAND', 'NZ','2431');
INSERT INTO Customers VALUES(9,'Delia','Rwo','Delia@msn.com', '1913 E 1130 S', 'AUCKLAND', 'NZ','63211');
INSERT INTO Customers VALUES(10,'Yuri','Toe','Yuri@msn.com', '1913 E 1130 S', 'AUCKLAND', 'NZ','2321');

INSERT INTO Orders VALUES(1, 1, 1, GETDATE(),'USD',100.20, 100.20, 0);
INSERT INTO Orders VALUES(2, 1, 1, GETDATE(),'USD',1980.00, 1980.00, 0);
INSERT INTO Orders VALUES(3, 2, 1, GETDATE(),'USD',32.67, 27.00, 5.67);
INSERT INTO Orders VALUES(4, 3, 1, GETDATE(),'CAD',35.09, 29.00, 6.09);
INSERT INTO Orders VALUES(5, 4, 1, GETDATE(),'EUR',32.67, 27.00, 5.67);
INSERT INTO Orders VALUES(6, 4, 1, GETDATE(),'EUR',1980.00, 1980.00, 0);
INSERT INTO Orders VALUES(7, 5, 1, GETDATE(),'AUD',45.19, 39.99, 5.20);
INSERT INTO Orders VALUES(8, 6, 1, GETDATE(),'AUD',45.19, 39.99, 5.20);
INSERT INTO Orders VALUES(9, 7, 1, GETDATE(),'AUD',100.20, 100.20, 0);
INSERT INTO Orders VALUES(10, 8, 1, GETDATE(),'NZD',274.79, 226.72, 43.88);
INSERT INTO Orders VALUES(11, 9, 1, GETDATE(),'NZD',33.80, 24.21, 5.40);
INSERT INTO Orders VALUES(12, 9, 1, GETDATE(),'NZD',89.52, 74.31, 11.02);
INSERT INTO Orders VALUES(13, 10, 1, GETDATE(),'NZD',104.08, 90.60, 9.29);


--USE OF WHERE, GROUP BY, HAVING, ORDER BY, IN
SELECT 'USE OF WHERE, GROUP BY, HAVING, ORDER BY, IN';

SELECT MainCity, count(*) FROM Customers
WHERE MainCountry IN ('US', 'CA')
GROUP BY MainCity
HAVING count(*) > 1
ORDER BY MainCity;

--USE OF AND and OR
SELECT 'USE OF AND and OR';

SELECT * FROM Customers
WHERE 
(MainCountry = 'US' AND MainCity = 'AL')
OR (MainCountry = 'NZ' AND MainCity = 'AUCKLAND')
ORDER BY 1 DESC
;

--USE OF UNION
SELECT 'USE OF UNION';

SELECT * FROM Customers
WHERE 
MainCountry = 'AU' AND MainCity = 'Spanish Fork'

UNION

SELECT * FROM Customers
WHERE 
MainCountry = 'NZ';

--USE OF JOIN
SELECT 'JOIN';

SELECT c.FirstName, c.LastName, o.Total  
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID

--USE OF ORDER BY
SELECT 'USE OF ORDER BY';

SELECT c.FirstName, c.LastName, o.Total  
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID
ORDER BY o.Total DESC

--USE OF DISTINCT
SELECT 'USE OF DISTINCT';

SELECT DISTINCT CurrencyCode
From Orders

--USE OF CASE
SELECT 'USE OF CASE';

SELECT CustomerID,
       FirstName,
       LastName,
       CASE MainCountry 
           WHEN 'US' 
               THEN 'UNITED STATES' 
           ELSE 'CANADA' 
       END CountryName
FROM 
Customers
WHERE MainCountry IN ('US', 'CA')

--USE OF UPDATE
SELECT 'USE OF UPDATE';

UPDATE Customers
SET MainZip = 'Z'+ MainZip
WHERE MainCountry = 'NZ'

--USE OF VIEW
SELECT 'USE OF VIEW';

CREATE VIEW OrderInfo
AS
SELECT c.FirstName, c.LastName, o.Total  
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID

SELECT * FROM OrderInfo

--USE OF INDEXES
SELECT 'USE OF INDEX';

CREATE INDEX IX_Orders_OrderDate
ON Orders (OrderDate)

CREATE INDEX IX_Customers_Name 
ON Customers(FirstName, LastName)

--USE OF STORED PROCEDURES
SELECT 'USE OF INDEX';

CREATE PROCEDURE ordGetOrders
@CustomerID AS INT 
AS
BEGIN
    SELECT OrderID, CustomerID, Total
    FROM Orders
    where CustomerID = @CustomerId
	ORDER BY 1 desc
END;

EXEC ordGetOrders 1


--USE OF FUNCTIONS
SELECT 'USE OF FUNCTIONS';

CREATE FUNCTION PriceWithTax(
    @Quantity INT,
    @PriceTaxable DEC(10,2),
    @TaxRate DEC(4,2)
)
RETURNS DEC(10,2)
AS 
BEGIN
    RETURN @Quantity * @PriceTaxable * (1 + @TaxRate)
END;

SELECT dbo.PriceWithTax(10, 100, 0.1) priceWithTax


--USE OF AGGREGATE FUNCTIONS
SELECT 'AGGREGATE FUNCTIONS';

SELECT CustomerId, 
Count(OrderID) CountOrders, 
AVG(Total) AverageOrderTotal,
MAX(Total) MaxOrderTotal,
MAX(Total) MinOrderTotal
FROM Orders
group by CustomerID
order by 1 desc
