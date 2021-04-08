CREATE   view dbo.CSharpObjects as 
SELECT 
schema_name(st.schema_id) +'.' +  st.name FQTableName
,schema_name(st.schema_id) SchemaName
,st.name TableName
,string_agg('public string ' + sc.name + ' {get;set;}',char(13) + char(9) + char(9)) within group (order by column_id)property
,string_agg('item"' + sc.name + '".ToString()',',' + char(13) + char(9) + char(9)) within group (order by column_id) DataTableToString
,string_agg('_dataTable.Columns.Add("' + sc.name + '",typeof(string));',char(13) + char(9) + char(9)) within group (order by column_id) DataTableBuilder
,column_id																																		Ordinal
from sys.columns sc
join sys.tables st
on st.object_id = sc.object_id 
group by st.schema_id , st.name,sc.column_id