USE SQL4DevsDb
GO

/*
Testing:
	EXEC dbo.ProductListPerPage NULL, NULL, NULL, NULL, 1
	EXEC dbo.ProductListPerPage 'Electra Relic 3i - 2018', NULL, NULL, NULL, 1
	EXEC dbo.ProductListPerPage NULL, 1, NULL, NULL, 1
	EXEC dbo.ProductListPerPage NULL, NULL, 2, NULL, 3
	EXEC dbo.ProductListPerPage NULL, NULL, 2, 2018, 1
	EXEC dbo.ProductListPerPage 'Heller Shagamaw GX1 - 2018', 3, NULL, 2018, 1	
*/

CREATE PROCEDURE dbo.ProductListPerPage
	@ProductName NVARCHAR(MAX) = NULL,
	@BrandId INT = NULL,
	@CategoryId INT = NULL,
	@ModelYear INT = NULL,
	@PageNumber INT = 1			-- to support pagination, defaulted to 1
AS
BEGIN TRY
    BEGIN TRAN ProductListPerPage

	DECLARE @PageSize AS INT
	SET @PageSize = 10

	SELECT 
		p.ProductId,
		p.ProductName,
		p.BrandId,
		b.BrandName,
		p.CategoryId,
		c.CategoryName,
		p.ModelYear,
		p.ListPrice
	FROM dbo.Product p
	LEFT JOIN dbo.Brand b ON b.BrandId = p.BrandId
	LEFT JOIN dbo.Category c ON c.CategoryId = p.CategoryId
	WHERE (ISNULL(@ProductName, '') = ''	OR p.ProductName = @ProductName)
		AND (ISNULL(@BrandId, '') = ''		OR p.BrandId = @BrandId)
		AND (ISNULL(@CategoryId, '') = ''	OR p.CategoryId = @CategoryId)
		AND (ISNULL(@ModelYear, '') = ''	OR p.ModelYear = @ModelYear)

	ORDER BY p.ModelYear DESC, p.ListPrice DESC, p.ProductName ASC
	OFFSET @PageSize * (@PageNumber - 1) ROWS
	FETCH NEXT @PageSize ROWS ONLY;

    COMMIT TRAN ProductListPerPage
END TRY

BEGIN CATCH
    ROLLBACK TRAN ProductListPerPage
    PRINT 'Retrieving Product List Failed.'
END CATCH
GO
