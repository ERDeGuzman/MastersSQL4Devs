USE SQL4DevsDb
GO

;WITH product_list_price AS (
	SELECT b.BrandName,
		p.ProductID,
		p.ProductName,
		p.ListPrice
	FROM dbo.Brand b
	INNER JOIN dbo.Product p ON p.BrandID = b.BrandID 
	GROUP BY b.BrandName, p.ProductID, p.ProductName, p.ListPrice
),
sorted_list_price AS (
	SELECT ROW_NUMBER() OVER (PARTITION BY BrandName ORDER BY BrandName ASC, ListPrice DESC, ProductName ASC) AS RowID,
		BrandName,
		ProductID,
		ProductName,
		ListPrice
	FROM product_list_price
)

SELECT BrandName	AS [Brand Name],
	ProductID		AS [Product ID],
	ProductName		AS [Product Name],
	ListPrice		AS [List Price]
FROM sorted_list_price
WHERE RowID < 6
 