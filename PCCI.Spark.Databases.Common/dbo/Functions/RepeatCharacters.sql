CREATE   FUNCTION [dbo].[RepeatCharacters]
	(
		 @StringToRepeat VARCHAR(20)
		,@TimesToRepeat INT
	)
	RETURNS VARCHAR(1000)
AS 
BEGIN 
	DECLARE @Result VARCHAR(1000) = ''
	DECLARE @Cnt INT = 0
	WHILE @Cnt < @TimesToRepeat 
	BEGIN 
		SELECT 
			@Result = @Result + @StringToRepeat
			,@Cnt = @Cnt + 1
	END
	RETURN @Result
END