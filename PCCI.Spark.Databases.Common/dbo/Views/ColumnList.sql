CREATE      VIEW [dbo].[ColumnList]
AS 
SELECT

	 TableObject_Id
	,ColumnId
	,FQName
	,SchemaName
	,TableName
	,ColumnCreator
	,ColumnName
	,ColumnDataType
	,ClassAutoProperty
	,((MaxLen%4 + maxLen + 16) -(NameLength%4 + NameLength))/4 + case when  maxlen%4 = 0 or(namelength = maxlen and namelength%4 = 0) then 0 else 1 end TabsToAdd
	,NameLength
	,MaxLen
	,ColumnName  + dbo.AddTabs(((MaxLen%4 + maxLen + 16) -(NameLength%4 + NameLength))/4 + case when  maxlen%4 = 0 or(namelength = maxlen and namelength%4 = 0) then 0 else 1 end) + ColumndataType ProperColumn
FROM (
SELECT 
	 st.object_id																						TableObject_Id
	,sc.column_id																						ColumnId
	,schema_name(st.schema_id) + '.' + st.name															FQName
	,schema_name(st.schema_id)																			SchemaName
	,st.Name																							TableName
	,sc.name +
	 + char(9) + char(9) + char(9) + char(9) + char(9) + char(9) + 
	 type_name(user_type_id) 
	 + 
	IsNull( CASE
		WHEN type_name(user_type_id) IN (
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
		WHEN type_name(user_type_id) IN ('char','nchar','nvarchar','varchar')
		THEN IsNull('(' + cast(nullif(max_length,-1) as varchar) + ')','')
		WHEN type_name(user_type_id) IN ('float')
		THEN IsNull('(' + cast(NullIf(precision,0) as varchar) + ')','')
		WHEN type_name(user_type_id) in ('decimal','real')
		THEN IsNull(('('  + IsNull(CAST(precision as varchar),'')) +IsNull(',' + nullif(cast(scale as varchar),'0'),'') + ')','')
		WHEN type_name(user_Type_id) in ('sysname','varbinary','binary')
		THEN ''
	END	,'') ColumnCreator
	,sc.name																							ColumnName
	, type_name(user_type_id)  + IsNull(replace( + CASE
		WHEN type_name(user_type_id) IN (
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
		WHEN type_name(user_type_id) IN ('char','nchar','nvarchar','varchar')
		THEN IsNull('(' + cast(nullif(max_length,-1) as varchar) + ')','')
		WHEN type_name(user_type_id) IN ('float')
		THEN IsNull('(' + cast(NullIf(precision,0) as varchar) + ')','')
		WHEN type_name(user_type_id) in ('decimal','real')
		THEN IsNull(('('  + IsNull(CAST(precision as varchar),'')) +IsNull(',' + nullif(cast(scale as varchar),'0'),'') + ')','')
		WHEN type_name(user_Type_id) in ('sysname','varbinary','binary')
		THEN ''
	END			,'()',''),'')																														ColumnDataType
		,char(9) + char(9) + 'public ' + 
	 CASE
		WHEN type_name(user_type_id) IN (
											 'datetime'
											,'datetime2'
										)
		THEN 'DateTime'						
		WHEN type_name(user_type_id) IN (
											 'int'
											,'smallint'
											,'tinyint'
											,'bigint'
										)
		THEN 'int'
		WHEN type_name(user_type_id) IN (
											 'int'
											,'bigint'
										)
		THEN 'Int.64'
		WHEN type_name(user_type_id) IN
										(
											'bit'
										)
		THEN 'bool'
		WHEN type_name(user_type_id) IN 
										(
											 'char'
											,'varchar'
											,'nvarchar'
											,'nchar'
										)
		then 'string'
		WHEN type_name(user_type_id) IN 
										(
											'decimal'
											,'real'
										)
		THEN 'decimal'
	END + ' ' + sc.name + ' { get; set;}'																	ClassAutoProperty
	,len(sc.name) NameLength
	,max(len(sc.name)) over (partition by st.object_id)			MaxLen
FROM sys.tables				st
JOIN sys.columns			sc
ON sc.object_id = st.object_id
where type_desc = 'user_table'
) k