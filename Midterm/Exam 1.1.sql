USE SQL4DevsDb
GO

SELECT DISTINCT StoreID AS [id],
	StoreName AS [name]
FROM dbo.Store
WHERE StoreID NOT IN (
	SELECT DISTINCT o.StoreID
	FROM dbo.Store s
	INNER JOIN dbo.[Order] o ON o.StoreID = s.StoreID)
