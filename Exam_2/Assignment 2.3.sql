USE SQL4DevsDb
GO

;WITH cte_sold_quantity AS (
	SELECT p.ProductName,
		SUM(oi.Quantity) AS TotalQuantity
	FROM dbo.[Order] o
	INNER JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	INNER JOIN dbo.Product p ON oi.ProductId = p.ProductId
	INNER JOIN dbo.Store s ON o.StoreId = s.StoreId
	WHERE s.State = 'TX'
	
	GROUP BY p.ProductName
	HAVING SUM(oi.Quantity) > 10
),
cte_category_sold_quantity AS (
	SELECT
	 CASE WHEN CHARINDEX('Bikes', c.CategoryName) = 0 THEN c.CategoryName
		ELSE STUFF(c.CategoryName, CHARINDEX('Bikes', c.CategoryName), LEN('Bikes'), 'Bicycles') END AS CategoryName,
		SUM(oi.Quantity) AS TotalQuantity
	FROM dbo.[Order] o
	LEFT JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	LEFT JOIN dbo.Product p ON oi.ProductId = p.ProductId
	LEFT JOIN dbo.Store s ON o.StoreId = s.StoreId
	LEFT JOIN dbo.Category c ON c.CategoryId = p.CategoryId
	GROUP BY c.CategoryName
)

SELECT *
FROM cte_sold_quantity
UNION
SELECT *
FROM cte_category_sold_quantity

ORDER BY TotalQuantity DESC


-- /////////////////////// OR ///////////////////////
-- //////////////////////////////////////////////////
-- //////////////////////////////////////////////////

--;WITH cte_sold_quantity AS (
	SELECT p.ProductName AS Name,
		SUM(oi.Quantity) AS TotalQuantity
	INTO dbo.SoldPerProduct
	FROM dbo.[Order] o
	INNER JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	INNER JOIN dbo.Product p ON oi.ProductId = p.ProductId
	INNER JOIN dbo.Store s ON o.StoreId = s.StoreId
	WHERE s.State = 'TX'
	
	GROUP BY p.ProductName
	HAVING SUM(oi.Quantity) > 10
--),
--cte_category_sold_quantity AS (
	SELECT
	 CASE WHEN CHARINDEX('Bikes', c.CategoryName) = 0 THEN c.CategoryName
		ELSE STUFF(c.CategoryName, CHARINDEX('Bikes', c.CategoryName), LEN('Bikes'), 'Bicycles') END AS Name,
		SUM(oi.Quantity) AS TotalQuantity
	INTO dbo.SoldPerCategory
	FROM dbo.[Order] o
	LEFT JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	LEFT JOIN dbo.Product p ON oi.ProductId = p.ProductId
	LEFT JOIN dbo.Store s ON o.StoreId = s.StoreId
	LEFT JOIN dbo.Category c ON c.CategoryId = p.CategoryId
	GROUP BY c.CategoryName
--)

BEGIN TRAN

MERGE dbo.SoldPerCategory AS c
USING dbo.SoldPerProduct AS p
	ON c.Name = p.Name
WHEN MATCHED
	THEN UPDATE
		SET c.Name = p.Name,
			c.TotalQuantity = p.TotalQuantity
WHEN NOT MATCHED
	THEN INSERT
	VALUES (p.Name, p.TotalQuantity)
WHEN NOT MATCHED BY SOURCE
	THEN DELETE;

SELECT @@ROWCOUNT

SELECT * FROM dbo.SoldPerCategory
SELECT * FROM dbo.SoldPerProduct

ROLLBACK TRAN
