USE SQL4DevsDb
GO
-- 4. Top selling product per month year
;WITH cte_orders AS (
	SELECT
		DATEPART(YEAR, o.OrderDate)	 AS OrderYear,
		DATEPART(MONTH, o.OrderDate) AS OrderMonth,
		DATENAME(MONTH, o.OrderDate) AS OrderMonthName,
		p.ProductName,
		SUM(oi.Quantity)			 AS TotalQuantity
	FROM dbo.[Order] o
	INNER JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	INNER JOIN dbo.Product p	ON p.ProductId = oi.ProductId
	GROUP BY
		p.ProductName,
		DATEPART(YEAR, o.OrderDate),
		DATEPART(MONTH, o.OrderDate),
		DATENAME(MONTH, o.OrderDate)
),
cte_selling_product_ranks AS (
	SELECT
		RANK() OVER (PARTITION BY co.OrderYear, co.OrderMonth ORDER BY co.TotalQuantity DESC) AS RankID,
		co.OrderYear,
		co.OrderMonth,
		co.OrderMonthName,
		co.ProductName,
		co.TotalQuantity
	FROM cte_orders co	
)

SELECT spr.OrderYear,
	spr.OrderMonthName AS OrderMonth,
	spr.ProductName,
	spr.TotalQuantity
FROM cte_selling_product_ranks spr
WHERE spr.RankID = 1
ORDER BY spr.OrderYear,	spr.OrderMonth ASC
