CREATE VIEW AgeAsOfToday
AS 
		SELECT 
			DateKey 
			,DateDiff(year,CommonDate,sysdatetime())		Age
		from ref.DateDimension