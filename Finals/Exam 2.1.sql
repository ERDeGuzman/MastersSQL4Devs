USE SQL4DevsDb
GO

CREATE PROCEDURE dbo.CreateNewBrandAndMoveProducts
	@NewBrandName NVARCHAR(MAX),
	@OldBrandId INT
AS
BEGIN TRY
    BEGIN TRAN CreateNewBrandAndMoveProducts

	DECLARE @NewBrandID INT;

	INSERT INTO dbo.Brand (BrandName)
	VALUES (@NewBrandName)

	SET @NewBrandId = (SELECT b.BrandID
					FROM dbo.Brand b
					WHERE b.BrandName = @NewBrandName);

    UPDATE dbo.Product
    SET BrandId = @NewBrandId
    WHERE BrandId = @OldBrandId

	DELETE FROM dbo.Brand
	WHERE BrandId = @OldBrandId

    COMMIT TRAN CreateNewBrandAndMoveProducts
END TRY

BEGIN CATCH
    ROLLBACK TRAN CreateNewBrandAndMoveProducts
    PRINT 'Creating new brand and move products Failed.'
END CATCH
GO