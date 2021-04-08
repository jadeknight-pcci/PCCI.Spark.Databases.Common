CREATE   VIEW [dbo].[ColumnAlignment] as 
		SELECT 
		TableId 
		,ColumnId 
		,ColumnName 
		,DataType 
		,ColumnTabs 
		,ColumnNameLength 
		,MaxColumnNameLength 
		,MaxColumnTabs
		,SPACE(MaxColumnNameLength - ColumnNameLength ) + dbo.RepeatCharacters(char(9),3)	ColumnAlignment
		,CHARINDEX(REPLACE(SPACE(MaxColumnNameLength - ColumnNameLength ),'    ',char(9)),' ')
		--case 
		--	when charindex(REPLACE(SPACE(MaxColumnNameLength - ColumnNameLength ),'    ',char(9)),' ') > 0
		--	then replace(REPLACE(SPACE(MaxColumnNameLength - ColumnNameLength ),'    ',char(9)),' ','') + char(9)
		--	else REPLACE(SPACE(MaxColumnNameLength - ColumnNameLength ),'    ',char(9))
		--	end 
		ColumnEnd
		,IsIdentity
		,HasDefault
		FROM
			(
				SELECT 
					 TableId
					,ColumnId
					,ColumnName 
					,DataType 
					,CASE 
						WHEN Len(char(9) + char(9) + ',' + ColumnName)%4 > 0
						THEN 1
						ELSE 0
					END																
					+ Len(char(9) + char(9) + ',' + ColumnName)/4										ColumnTabs
					,Len(char(9) + char(9) + ',' + ColumnName)											ColumnNameLength
					,MAX(Len(char(9) + char(9) + ',' + ColumnName)) OVER (PARTITION BY TableId)			MaxColumnNameLength
					,CASE 
						WHEN (MAX(Len(char(9) + char(9) + ',' + ColumnName))	OVER (PARTITION BY TableId))%4 > 0
						THEN 3
						ELSE 2
					END																
					+ (MAX(Len(char(9) + char(9) + ',' + ColumnName))	OVER (PARTITION BY TableId))/4	MaxColumnTabs
					,IsNullable 
					,IsIdentity
					,HasDefault
				FROM 
					(
						SELECT 
							TableId 
							,ColumnId
							,SchemaName 
							,TableName 
							,FQTableName
							,CASE 
								WHEN ColumnName = 'Id'
								THEN TableName + 'Key'
								ELSE ColumnName
							END									ColumnName
							,DataType 
							,IsNullable
							,IsIdentity
							,HasDefault
						FROM dbo.ColumnDescriptions 
					)cd
				
			) t