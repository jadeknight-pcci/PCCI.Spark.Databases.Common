CREATE FUNCTION tools.RepeatCharacters 
	(
		 @CharactersToAdd		VARCHAR(10)
		,@NumberToAdd			INT
	)
RETURNS VARCHAR(1000)
/*

*/
AS
BEGIN
    DECLARE @response	VARCHAR(1000) = ''
	DECLARE @Tabs		INT = 0
	WHILE @Tabs < @NumberToAdd 
	BEGIN 
		set @Response = @response + @CharactersToAdd
		set @Tabs = @Tabs + 1
	end
	return @response

END