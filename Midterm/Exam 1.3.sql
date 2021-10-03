USE SQL4DevsDb
GO

;WITH orders_per_date AS (
	SELECT s.StoreName,
		DATEPART(YEAR, o.OrderDate) AS Year,
		COUNT(*) AS OrderCount
	FROM dbo.[Order] o
	INNER JOIN dbo.Store s ON o.StoreID = s.StoreID
	GROUP BY o.OrderDate, s.StoreName
)

SELECT StoreName	AS [Store Name],
	Year			AS [Order Year],
	SUM(OrderCount) AS [Number of Orders]
FROM orders_per_date 
GROUP BY Year, StoreName
ORDER BY StoreName ASC, Year DESC
