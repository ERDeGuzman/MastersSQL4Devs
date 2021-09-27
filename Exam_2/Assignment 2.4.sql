USE SQL4DevsDb
GO
-- 4. Top selling product per month year
;WITH cte_orders AS (
	SELECT 
		DATEPART(YEAR, o.OrderDate) AS OrderYear,
		DATEPART(MONTH, o.OrderDate) AS OrderMonth,
		p.ProductName,
		SUM(oi.Quantity) AS TotalQuantity
	FROM dbo.[Order] o
	INNER JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	INNER JOIN dbo.Product p ON oi.ProductId = p.ProductId
	INNER JOIN dbo.Store s ON o.StoreId = s.StoreId
	GROUP BY o.OrderDate, p.ProductName
),
cte_top_selling_product AS (
	SELECT
		RANK() OVER (PARTITION BY co.OrderYear, co.OrderMonth ORDER BY co.TotalQuantity DESC) AS [RankID],
		co.OrderYear,
		co.OrderMonth,
		co.ProductName,
		co.TotalQuantity
	FROM cte_orders co
)

SELECT tsp.OrderYear,
	DATENAME(MONTH, DATEADD(MONTH, tsp.OrderMonth, -1)) AS OrderMonth,
	tsp.ProductName,
	tsp.TotalQuantity
FROM cte_top_selling_product tsp
WHERE tsp.RankID = 1
ORDER BY tsp.OrderYear,	tsp.OrderMonth ASC
