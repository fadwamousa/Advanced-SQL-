--Finding recipes using both beef and garlic with table subqueries
SELECT BeefRecipes.RecipeTitle
FROM (
SELECT Recipes.RecipeID, Recipes.RecipeTitle
FROM Recipes
INNER JOIN Recipe_Ingredients
ON Recipes.RecipeID = Recipe_Ingredients.RecipeID
INNER JOIN Ingredients
ON Ingredients.IngredientID =
Recipe_Ingredients.IngredientID
WHERE Ingredients.IngredientName = 'Beef'
) AS BeefRecipes
INNER JOIN (
SELECT Recipe_Ingredients.RecipeID
FROM Recipe_Ingredients
INNER JOIN Ingredients
ON Ingredients.IngredientID =
Recipe_Ingredients.IngredientID
WHERE Ingredients.IngredientName = 'Garlic'
) AS GarlicRecipes
ON BeefRecipes.RecipeID = GarlicRecipes.RecipeID;
-------------------------------------------------------------------------
--Finding products not ordered in December 2015 using a single-column table subquery
use SalesOrdersSample

select P.ProductName from Products P
where NOT EXISTS 
(
select od.ProductNumber from Order_Details od 
                             inner join 
							 Orders o 
							 on o.OrderNumber = od.OrderNumber
							 where OrderDate BETWEEN '2015-12-01' AND '2015-12-31'
							                                      and P.ProductNumber = od.ProductNumber
)

--------------------------------------------
SELECT Products.ProductName
FROM Products
WHERE Products.ProductNumber NOT IN (
SELECT Order_Details.ProductNumber
FROM Orders
INNER JOIN Order_Details
ON Orders.OrderNumber = Order_Details.OrderNumber
WHERE Orders.OrderDate
BETWEEN '2015-12-01' AND '2015-12-31'
);

-------------------------------------------------------------------------------------------------------

--what is the name of products which orderd lastly 
SELECT ProductName,max(orderDate) from Products inner join Order_Details on Order_Details.ProductNumber = Products.ProductNumber
inner join Orders on Orders.OrderNumber = Order_Details.OrderNumber
group by ProductName


SELECT ProductName,
(select max(orderdate) from Orders inner join Order_Details on Orders.OrderNumber = Order_Details.OrderNumber
                                         and  Products.ProductNumber = Order_Details.ProductNumber) 
from Products
------------------------------------------------------------------------------------------
use RecipesSample

SELECT Recipe_Classes.RecipeClassDescription, (
SELECT COUNT(*)
FROM Recipes
WHERE Recipes.RecipeClassID =
Recipe_Classes.RecipeClassID
) AS RecipeCount
FROM Recipe_Classes;

select RecipeClassDescription , count(*)  from Recipe_Classes inner join Recipes 
on Recipes.RecipeClassID = Recipe_Classes.RecipeClassID
group by RecipeClassDescription

----------------------------------------------------------------------------















