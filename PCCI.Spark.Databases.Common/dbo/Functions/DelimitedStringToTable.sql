CREATE FUNCTION [dbo].[DelimitedStringToTable] (
	@DelimitedString VARCHAR(MAX)
	,@DelimitCharacter VARCHAR(5)
	)
	RETURNS TABLE
 AS 
Return
SELECT
	 value	
	,row_number() over (partition by 1 order by PatIndex(@DelimitCharacter + value + @DelimitCharacter,@DelimitCharacter + @DelimitedString + @DelimitCharacter)) ValueOrder
from string_split(@DelimitedString,@DelimitCharacter )