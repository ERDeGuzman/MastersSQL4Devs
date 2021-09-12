USE SQL4DevsDb
GO

-- Customer order records 
SELECT
	DISTINCT o.CustomerId
	,COUNT(o.OrderId) AS OrderCount
FROM [dbo].[Order] o
WHERE o.OrderDate BETWEEN '2017-01-01' AND '2018-12-31'	-- Orders for the year 2017 and 2018
AND o.ShippedDate IS NULL								-- Orders should not have been shipped yet 
GROUP BY o.CustomerId
HAVING COUNT(o.OrderId) > 1								-- Customer’s orders should be at least 2 
