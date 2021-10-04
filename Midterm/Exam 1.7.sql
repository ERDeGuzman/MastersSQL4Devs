USE SQL4DevsDb
GO

DECLARE @columns NVARCHAR(MAX) = '', 
		@sql     NVARCHAR(MAX) = '';

;WITH order_months AS (
	SELECT DISTINCT CAST(DATENAME(MONTH, o.OrderDate) AS CHAR(3)) AS [MonthName],
		DATEPART(MONTH, o.OrderDate) AS [MonthNumber]
	FROM dbo.[Order] o
	INNER JOIN dbo.OrderItem oi ON oi.OrderID = o.OrderID 
)

SELECT @columns += QUOTENAME([MonthName]) + ','
FROM order_months
ORDER BY [MonthNumber]

SET @columns = LEFT(@columns, LEN(@columns) - 1);

SET @sql = '
		WITH cte_pricePerYearMonth AS (
			SELECT CAST(DATENAME(Month, o.OrderDate) AS CHAR(3)) AS Month,
				ISNULL(oi.ListPrice, 0.00) AS ListPrice,
				DATENAME(Year, o.OrderDate) AS SalesYear
			FROM dbo.[Order] o
			INNER JOIN dbo.OrderItem oi ON oi.OrderID = o.OrderID 	
		)

		SELECT * FROM cte_pricePerYearMonth 
		PIVOT(
			SUM(ListPrice)
			FOR Month IN ('+ @columns +')
		) AS PivotTable
		ORDER BY SalesYear ASC'

EXECUTE sp_executesql @sql
