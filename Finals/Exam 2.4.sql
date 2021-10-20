USE SQL4DevsDb
GO

-- a.
CREATE TABLE dbo.Ranking (
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[Description] NVARCHAR(MAX)
)

-- b.
SET IDENTITY_INSERT dbo.Ranking ON
GO

INSERT INTO dbo.Ranking (Id, [Description])
VALUES (1, 'Inactive'),
(2, 'Bronze'),
(3, 'Silver'),
(4, 'Gold'),
(5, 'Platinum')

SET IDENTITY_INSERT dbo.Ranking OFF
GO

-- c.
ALTER TABLE dbo.Customer
ADD RankingId INT CONSTRAINT FK_Customer_RankingId FOREIGN KEY REFERENCES dbo.Ranking(Id)

-- d.
CREATE PROCEDURE dbo.uspRankCustomers
AS
BEGIN TRY
    BEGIN TRAN uspRankCustomers

	;WITH cte_OrderAmount AS (
		SELECT 
			c.CustomerId,
			c.FirstName,
			c.LastName,
			TotalOrderAmount = oi.Quantity * oi.ListPrice
		FROM dbo.Customer c
		LEFT JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
		LEFT JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	),
	cte_TotalOrderAmount AS (
		SELECT 
			coa.CustomerId,
			coa.FirstName,
			coa.LastName,
			ISNULL(SUM(coa.TotalOrderAmount), 0) AS TotalAmount
		FROM cte_OrderAmount coa
		GROUP BY coa.CustomerId, coa.FirstName,	coa.LastName
	)

	UPDATE c 
	SET c.RankingId = CASE 
						WHEN ctoa.TotalAmount = 0 THEN 1 
						WHEN ctoa.TotalAmount < 1000 THEN 2
						WHEN ctoa.TotalAmount < 2000 THEN 3
						WHEN ctoa.TotalAmount < 3000 THEN 4
						ELSE 5
					  END
	FROM dbo.Customer c
	INNER JOIN cte_TotalOrderAmount ctoa ON ctoa.CustomerId = c.CustomerId
	
    COMMIT TRAN uspRankCustomers
END TRY

BEGIN CATCH
    ROLLBACK TRAN uspRankCustomers
    PRINT  'Customer Ranking Failed.'
END CATCH
GO

EXEC dbo.uspRankCustomers

-- e.
CREATE VIEW dbo.vwCustomerOrders WITH SCHEMABINDING 
AS
	WITH cte_OrderAmount AS (
		SELECT 
			c.CustomerId,
			c.FirstName,
			c.LastName,
			TotalOrderAmount = oi.Quantity * oi.ListPrice
		FROM dbo.Customer c
		LEFT JOIN dbo.[Order] o ON o.CustomerId = c.CustomerId
		LEFT JOIN dbo.OrderItem oi ON oi.OrderId = o.OrderId
	),
	cte_TotalOrderAmount AS (
		SELECT 
			coa.CustomerId,
			coa.FirstName,
			coa.LastName,
			ISNULL(SUM(coa.TotalOrderAmount), 0) AS TotalAmount
		FROM cte_OrderAmount coa
		GROUP BY coa.CustomerId, coa.FirstName,	coa.LastName
	)

	SELECT c.CustomerId,
		c.FirstName,
		c.LastName,
		ctoa.TotalAmount AS TotalOrderAmount,
		r.Description AS CustomerRanking
	FROM dbo.Customer c
	INNER JOIN cte_TotalOrderAmount ctoa ON ctoa.CustomerId = c.CustomerId
	INNER JOIN dbo.Ranking r ON r.Id = c.RankingId


SELECT * FROM dbo.vwCustomerOrders

