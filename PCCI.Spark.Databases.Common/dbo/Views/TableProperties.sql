CREATE       view [dbo].[TableProperties]
as
SELECT 
	 cast(schema_name(st.schema_id)	as varchar(300))	SchemaName
	,st.object_id										TableObjectId
	,cast(st.name					as varchar(300))	TableName 
	,cast(tType.Value				as varchar(300))	TableType 
	,cast(tDescription.Value		as varchar(300))	TableDescription
FROM sys.tables st
LEFT JOIN sys.extended_properties tType
on tType.major_id = st.object_id 
and tType.name = 'TableType'
left JOIN sys.extended_properties tDescription
on tDescription.major_id = st.object_id 
and tDescription.name = 'TableDescription'
where schema_name(schema_id) not in ('dbo','tmp')