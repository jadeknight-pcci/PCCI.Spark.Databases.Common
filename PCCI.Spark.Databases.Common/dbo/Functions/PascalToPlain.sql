CREATE FUNCTION dbo.PascalToPlain
		(
			@String	VARCHAR(2000)
		)
	returns VARCHAR(2000)
	AS 
	BEGIN
	DECLARE @StringLength		INT
    DECLARE @CurrentChar		INT = 0 
    DECLARE @Result				VARCHAR(2000) = ''
    SET @StringLength = LEN(@String)
	
    WHILE @CurrentChar < @StringLength 
    BEGIN
	SET @CurrentChar = @CurrentChar + 1
	SET @Result	= @Result + 
		CASE 
			WHEN @CurrentChar = @StringLength
			THEN substring (@String,@CurrentChar,1)
			WHEN (ascii(substring (@String,@CurrentChar,1))>=65 
				and  ascii(substring (@String,@CurrentChar,1))<=90)
			THEN ' '+substring (@String,@CurrentChar,1) 
			ELSE substring (@String,@CurrentChar,1) 
		END
    END 
	RETURN @Result 
END