CREATE      VIEW [dbo].[ColumnDescriptions]
AS 
SELECT 
 CAST(SchemaId				as varchar(300))	SchemaId
,CAST(TableId				as varchar(300))	TableId
,CAST(ColumnId				as varchar(300))	ColumnId
,CAST(SchemaName			as varchar(300))	+ '.' + CAST(TableName				as varchar(300))	FQTableName
,CAST(SchemaName			as varchar(300))	SchemaName
,CAST(TableName				as varchar(300))	TableName
,CAST(ColumnName			as varchar(300))	ColumnName
,CAST(DataType				as varchar(300))	DataType
,CAST(ColumnDescription		as varchar(300))	ColumnDescription
,IsNullable
,IsIdentity
,HasDefault
FROM (
select 
	 st.schema_id																SchemaId
	,st.object_id																TableId
	,sc.column_id																ColumnId
	,schema_name(st.schema_id)													SchemaName
	,st.Name																	TableName
	,sc.name																	ColumnName
	,UPPER(
		type_name(sc.user_type_id) + ' ' + IsNull
			(
				CASE
					WHEN type_name(sc.user_type_id) IN (
														 'datetime'
														,'datetime2'
														,'int'
														,'smallint'
														,'tinyint'
														,'bigint'
														,'bit'
														,'uniqueidentifier'
														,'sql_variant'
														,'datetimeoffset'
													)
					THEN ''
					WHEN type_name(sc.user_type_id) IN ('char','nchar','nvarchar','varchar')
					THEN IsNull('(' + cast(nullif(max_length,-1) as varchar) + ')','')
					WHEN type_name(sc.user_type_id) IN ('float')
					THEN IsNull( '(' + cast(NullIf(sc.precision,0) as varchar) + ')','')
					WHEN type_name(sc.user_type_id) in ('decimal')
					THEN IsNull(('('  + IsNull(CAST(sc.precision as varchar),'')) +IsNull(',' + nullif(cast(sc.scale as varchar),'0') + ')','') ,'')
					WHEN type_name(sc.user_type_id) in ('sysname','varbinary','binary')
					THEN ''
				END
				,'')
			)	DataType
	,ep.Value	ColumnDescription
	,CASE
		WHEN is_nullable = 1
		THEN 'NULL'
		WHEN is_nullable = 0
		THEN 'NOT NULL'
	 END IsNullable
	,CASE WHEN sc.is_identity = 1
	THEN char(9) + 'IDENTITY(1,1)'
	ELSE char(9) 
	END IsIdentity
	,CASE
		when con.definition is not null
		THEN 'DEFAULT' + char(9) + substring(con.definition,2,len(con.definition)-2)
		else ''
		end HasDefault
from sys.tables					st 
JOIN sys.columns				sc
on sc.object_id = st.object_id 
LEFT JOIN sys.extended_properties	ep
on st.object_id = IsNull(ep.Major_id ,st.object_id)
and sc.column_id = IsNull(ep.minor_id ,sc.column_id)
LEFT JOIN sys.default_constraints con
ON con.parent_object_id = sc.object_id 
AND con.parent_column_id = sc.column_id
) t