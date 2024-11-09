USE [SuperStoreProject]  --Use to switch to a database

--Basic select query retrieving all columns from a table.

SELECT * FROM [dbo].[Orders$]
SELECT * FROM [dbo].[People$]
SELECT * FROM [dbo].[Returns$]

--Joining Table, Filtering & Sorting Data, Handling NULL values 

SELECT *
FROM [dbo].[Orders$] AS O
FULL JOIN [dbo].[People$] AS P ON O.[Customer Name] = P.Person
FULL JOIN [dbo].[Returns$] AS R ON O.[Order ID] = R.[Order ID]
WHERE O.[Customer ID] IS NOT NULL
AND P.Person IS NOT NULL
ORDER BY O.[Order Date] DESC

--Aggregation and Grouping 

SELECT O.Region, ROUND(SUM(O.Sales), 2) AS 'Total Sales', SUM(O.Quantity) AS 'Total Quantity'
FROM [dbo].[Orders$] AS O
FULL JOIN [dbo].[People$] AS P ON O.[Customer Name] = P.Person
FULL JOIN [dbo].[Returns$] AS R ON O.[Order ID] = R.[Order ID]
GROUP BY O.[Region]
HAVING SUM(O.Quantity) > 7000
ORDER BY 'Total Quantity' DESC

--Subquery
--e.g Retrieving customers that made purchases in a specific region.

SELECT DISTINCT([Customer Name]) FROM [dbo].[Orders$] 
WHERE [Customer ID] IN (SELECT [Customer ID] FROM [dbo].[Orders$]
WHERE Region = 'West')
 
--Window function 

SELECT [Customer Name], ROUND(SUM([Sales]) OVER(), 2) AS TotalSale
FROM [dbo].[Orders$]

SELECT [Customer Name], [Product Name], [Region], ROUND(SUM([Sales]) OVER(PARTITION BY [Customer Name], [Region]), 2) AS TotalSale
FROM [dbo].[Orders$]
WHERE [Region] = 'West'

SELECT [Customer Name], [Product Name], [Region], ROUND(SUM([Sales]), 2) AS TotalSale
FROM [dbo].[Orders$]
GROUP BY [Customer Name], [Product Name], [Region]
HAVING [Region] = 'West'
ORDER BY [Customer Name]




