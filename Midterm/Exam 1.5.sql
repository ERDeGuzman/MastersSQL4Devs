USE SQL4DevsDb
GO
SET NOCOUNT ON;

DECLARE @storeName VARCHAR(50),
		@year INT,
		@numberOfOrders INT;

DECLARE order_per_year_cursor CURSOR FOR
WITH orders_per_date AS (
	SELECT s.StoreName,
		DATEPART(YEAR, o.OrderDate) AS Year,
		COUNT(*) AS OrderCount
	FROM dbo.[Order] o
	INNER JOIN dbo.Store s ON o.StoreID = s.StoreID
	GROUP BY o.OrderDate, s.StoreName
)

SELECT StoreName,
	Year,
	SUM(OrderCount) AS numberOfOrders
FROM orders_per_date 
GROUP BY Year, StoreName
ORDER BY StoreName ASC, Year DESC;

OPEN order_per_year_cursor

FETCH NEXT FROM order_per_year_cursor
INTO @storeName, @year, @numberOfOrders

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CAST(@storeName AS VARCHAR(50)) + ' ' + CAST(@year AS VARCHAR(10)) + ' ' + CAST(@numberOfOrders AS VARCHAR(10))

	FETCH NEXT FROM order_per_year_cursor
INTO @storeName, @year, @numberOfOrders

END

CLOSE order_per_year_cursor;
DEALLOCATE order_per_year_cursor;
