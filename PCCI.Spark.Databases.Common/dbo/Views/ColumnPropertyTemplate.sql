CREATE     VIEW [dbo].[ColumnPropertyTemplate]
AS 
SELECT 
schema_name(st.Schema_id)																																								SchemaName 
,st.name																																												TableName 
,schema_name(st.Schema_id) + '.' + st.name																																				FQTableName
,sc.name																																												ColumnName
,sc.column_id																																											ColumnId
,replace(reserved.Description,'${TableName}',st.name)																																	ReservedDescription
,replace(pattern.Description,'${ColumnPrefix}',substring(sc.name,0,PatIndex(pattern.RuleValue,sc.name)))																				PatternDescription
,'The ' + replace(st.name,sc.name,'') + ' ' + sc.name + '.'																																DefaultDescription
FROM sys.tables				st
JOIN sys.columns			sc
ON sc.object_id = st.object_id 
LEFT JOIN dbo.NameRules								reserved
ON reserved.ObjectType		= 'Column'  
AND reserved.RuleType		= 'Reserved Name' 
AND reserved.RuleValue		= sc.name 
LEFT JOIN dbo.NameRules								pattern
ON pattern.ObjectType		= 'Column'  
AND pattern.RuleType		= 'Pattern' 
AND reserved.Id	is null
AND PatIndex(pattern.RuleValue,sc.name) > 0