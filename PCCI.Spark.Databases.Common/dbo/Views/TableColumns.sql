CREATE VIEW TableColumns AS 
  SELECT 
	sc.Name			ColumnName
	,object_schema_name(sc.object_id) + '.' + object_name(sc.object_id)		TableName
FROM sys.Columns sc