USE SQL4DevsDb
GO

-- Creating a backup of dbo.Product table
SELECT * INTO Product_20210912
FROM dbo.Product
WHERE ModelYear <> 2016 -- Exclude records with Model Year of 2016 

-- Raising the list price of each product by 20% for "Heller" and "Sun Bicycles" brands
--SELECT *, NewListPrice = p.ListPrice + (p.ListPrice * 0.2)
UPDATE p
SET p.ListPrice = p.ListPrice + (p.ListPrice * 0.2) 
FROM dbo.Product_20210912 p
WHERE p.BrandId IN (SELECT b.BrandId
					FROM dbo.Brand b
					WHERE b.BrandName IN ('Heller', 'Sun Bicycles'))

-- Raising the list price of each product by 10% for brands that are not "Heller" and "Sun Bicycles"
--SELECT *, NewListPrice = p.ListPrice + (p.ListPrice * 0.1)
UPDATE p
SET p.ListPrice = p.ListPrice + (p.ListPrice * 0.1)
FROM dbo.Product_20210912 p
WHERE p.BrandId IN (SELECT b.BrandId
					FROM dbo.Brand b
					WHERE b.BrandName NOT IN ('Heller', 'Sun Bicycles'))
