USE SQL4DevsDb
GO

DECLARE @multiplicand INT,
		@multiplier INT,
		@product INT

SET @multiplicand = 1

WHILE @multiplicand <= 10
BEGIN
	SET @multiplier = 1

	WHILE @multiplier <= 10
	BEGIN	
		SET @product = @multiplicand * @multiplier
		PRINT CONVERT(VARCHAR(MAX), @multiplicand) + ' * '
			+ CONVERT(VARCHAR(MAX), @multiplier) + ' = '
			+ CONVERT(VARCHAR(MAX), @product)
		
		SET @multiplier = @multiplier + 1 
	END

	SET @multiplicand = @multiplicand + 1
END
