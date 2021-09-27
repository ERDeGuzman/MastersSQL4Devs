USE SQL4DevsDb
GO

-- 1.
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
)

SELECT *
FROM cte_sold_quantity
ORDER BY TotalQuantity DESC

-- 2.
;WITH cte_category_sold_quantity AS (
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
FROM cte_category_sold_quantity
ORDER BY TotalQuantity DESC
