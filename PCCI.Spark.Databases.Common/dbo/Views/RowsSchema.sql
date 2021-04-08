CREATE   VIEW RowsSchema as 
select 
schema_name(st.schema_id) SchemaName 
,string_agg('select
''' + schema_name(st.schema_id) + '.' + st.name + '''				TableName
,FORMAT(count(*),''N0'') Rows
from ' + schema_name(st.schema_id) + '.' + st.name + '
','UNION' + char(13)) within group (order by object_id)				RowCounter
from sys.tables st
group by st.schema_id