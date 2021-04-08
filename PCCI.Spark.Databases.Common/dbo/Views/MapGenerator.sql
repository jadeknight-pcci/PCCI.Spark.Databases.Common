CREATE     view [dbo].[MapGenerator]
	as 
	select 
	object_name(object_id)														TableName
	,column_id																	ColumnNumber
	,type_name(user_type_id)													DataType
	,'Map(m => m.' + name + ').Index(' + cast ((column_id - 1) as varchar) + ');' MapTemplate
from sys.columns  sc