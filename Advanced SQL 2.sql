--This will give you customers who made purchase Bike or Skateboard
select c.CustomerID,CustFirstName,ProductName from Customers c
inner join Orders O on o.CustomerID = c.CustomerID
inner join Order_Details od on od.OrderNumber = o.OrderNumber
inner join Products p on p.ProductNumber = od.ProductNumber
where p.ProductName LIKE '%Bike%' or p.ProductName like '%Skateboard%'
----This will give you customers who made purchase Both (Bike and Skateboard)
SELECT c.CustFirstName, c.CustLastName
FROM Customers AS c
WHERE c.CustomerID IN
(SELECT o.CustomerID
FROM Orders AS o
INNER JOIN Order_Details AS od
ON o.OrderNumber = od.OrderNumber
INNER JOIN Products AS p
ON p.ProductNumber = od.ProductNumber
WHERE p.ProductName = 'Bike')
INTERSECT
SELECT c2.CustFirstName, c2.CustLastName
FROM Customers AS c2
WHERE c2.CustomerID IN
(SELECT o.CustomerID
FROM Orders AS o
INNER JOIN Order_Details AS od
ON o.OrderNumber = od.OrderNumber
INNER JOIN Products AS p
ON p.ProductNumber = od.ProductNumber
WHERE p.ProductName = 'Skateboard');
----------------------------------------------------------------------------------------
--find all customers who ordered a skateboard but did not order a helmet

select c.CustFirstName, c.CustLastName from Customers c
where exists (
SELECT o.CustomerID
FROM Orders AS o
INNER JOIN Order_Details AS od
ON o.OrderNumber = od.OrderNumber
INNER JOIN Products AS p
ON p.ProductNumber = od.ProductNumber
WHERE p.ProductName LIKE'%skateboard%' and c.CustomerID = o.CustomerID )
and NOT EXISTS (
SELECT o.CustomerID
FROM Orders AS o
INNER JOIN Order_Details AS od
ON o.OrderNumber = od.OrderNumber
INNER JOIN Products AS p
ON p.ProductNumber = od.ProductNumber
WHERE p.ProductName  LIKE '%helmet%' and c.CustomerID = o.CustomerID
)


SELECT c.CustFirstName, c.CustLastName
FROM Customers AS c
WHERE c.CustomerID IN
(SELECT o.CustomerID
FROM Orders AS o
INNER JOIN Order_Details AS od
ON o.OrderNumber = od.OrderNumber
INNER JOIN Products AS p
ON p.ProductNumber = od.ProductNumber
WHERE p.ProductName LIKE '%Skateboard%')
EXCEPT
SELECT c2.CustFirstName, c2.CustLastName
FROM Customers AS c2
WHERE c2.CustomerID IN
(SELECT o.CustomerID
FROM Orders AS o
INNER JOIN Order_Details AS od
ON o.OrderNumber = od.OrderNumber
INNER JOIN Products AS p
ON p.ProductNumber = od.ProductNumber
WHERE p.ProductName LIKE '%helmet%');

---------------------------------------------------------------------------
--Show me all customers and, if some exist, any orders that they placed during the last quarter of 2015.
--the query does return all customers who have never placed an order and any customers who did place an order in the last quarter of 2015.
--If there is a customer who placed an order earlier, but not in the last quarter, that customer will not show up at all because the date
--filter removes that row.
SELECT c.CustomerID, c.CustFirstName, c.CustLastName,
o.OrderNumber, o.OrderDate, o.OrderTotal
FROM Customers AS c
LEFT JOIN Orders AS o
ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN CAST('2015-10-01' AS DATE)
AND CAST('2015-12-31' AS DATE) OR o.OrderNumber IS NULL;


------------------------------------I WANT TO RETURN ALL CUSTOMERS TABLE 
SELECT c.CustomerID, c.CustFirstName, c.CustLastName,
neworders.OrderNumber, neworders.OrderDate, neworders.OrderTotal
FROM Customers AS c 
LEFT OUTER JOIN (
SELECT * FROM Orders 
WHERE Orders.OrderDate 
BETWEEN CAST('2015-10-01' AS DATE) AND CAST ('2015-12-31' AS DATE))as neworders
on neworders.CustomerID = c.CustomerID
------------------------------------------------------------------------------------------
------This will give you customers who made purchase Both ('Skateboard', 'Helmet', 'Knee Pads', 'Gloves')
ALTER function customerProductsName (@productName varchar(25)) returns table
as return 
(SELECT Orders.CustomerID AS CustID
FROM Orders
INNER JOIN Order_Details
ON Orders.OrderNumber
= Order_Details.OrderNumber
INNER JOIN Products
ON Products.ProductNumber
= Order_Details.ProductNumber
WHERE ProductName LIKE '%' +@productName + '%');

SELECT CustomerID,CustFirstName,CustLastName 
FROM Customers C
WHERE C.CustomerID IN
(SELECT CustID FROM customerProductsName('Skateboard'))
AND C.CustomerID IN
(SELECT CustID FROM customerProductsName('Helmet'))
AND C.CustomerID IN
(SELECT CustID FROM customerProductsName('Knee Pads'))
AND C.CustomerID IN
(SELECT CustID FROM customerProductsName('Gloves'));
-------------------------------------------------------------------------------------------


