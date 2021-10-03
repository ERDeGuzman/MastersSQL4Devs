USE SQL4DevsDb
GO

SELECT p.ProductID AS [Product Id],
	p.ProductName AS [Product Name],
	b.BrandName AS [Brand Name],
	c.CategoryName AS [Category Name],
	st.Quantity AS [Quantity]
FROM dbo.Store s
INNER JOIN dbo.Stock st		ON st.StoreID = s.StoreID
INNER JOIN dbo.Product p	ON p.ProductID = st.ProductID
INNER JOIN dbo.Brand b		ON b.BrandID = p.BrandID
INNER JOIN dbo.Category c	ON c.CategoryID = p.CategoryID 
WHERE s.StoreName = 'Baldwin Bikes'
AND p.ModelYear IN (2017, 2018) 
ORDER BY st.Quantity DESC, p.ProductName ASC, b.BrandName ASC, c.CategoryName ASC

