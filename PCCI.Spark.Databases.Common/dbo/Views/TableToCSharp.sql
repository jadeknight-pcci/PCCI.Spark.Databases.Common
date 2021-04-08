--	CREATE OR ALTER Procedure CSharpObject
--	(
--		SchemaName varchar(30)
--		,TableName varchar(30)
--		,PathName varchar(200)
--		,OutputName varchar(30)
--	)
--AS 
	CREATE   VIEW dbo.TableToCSharp 
	AS
	SELECT
			 schema_name(st.schema_id)																												SchemaName
			,st.Name																																TableName
			,schema_name(st.schema_id) + '.' + st.name																								FQTableName
			,sc.Name																																ColumnName
			,type_name(user_type_id)																												DataType
			,precision																																Precision
			,scale																																	Scale
			,Max_length																																Max_Length
			,column_id																																ColumnOrder
			,'"' + sc.name + '"'																													QuotedColumnName
			,Upper(left(sc.name,1)) + substring(sc.name,2,len(sc.name))																				ColumnPublicVariable
			,lower(left(sc.name,1)) + substring(sc.name,2,len(sc.name))																				ColumnparameterVariable
			,'_' + lower(left(sc.name,1)) + substring(sc.name,2,len(sc.name)) 																		ColumnhashVariable
			,'_' + lower(left(sc.name,1)) + substring(sc.name,2,len(sc.name))																		ColumnlocalVariable
			,Upper(left(st.name,1)) + substring(st.name,2,len(st.name)) + 'Data'																	TablePublicVariable
			,lower(left(st.name,1)) + substring(st.name,2,len(st.name)) + 'Data'																	TableparameterVariable
			,'_' + lower(left(st.name,1)) + substring(st.name,2,len(st.name)) + 'HashColuns'														TablehashVariable
			,'_' + lower(left(st.name,1)) + substring(st.name,2,len(st.name)) + 'Data'																TablelocalVariable
			,'_' + lower(left(st.name,1)) + substring(st.name,2,len(st.name)) + 'Data'	+ '.Add("' + sc.name + '", Row.in' + sc.name + '_IsNull ? string.Empty : Row.in' + sc.name + '.ToString());'			StringTransform
			,'_' + lower(left(st.name,1)) + substring(st.name,2,len(st.name)) + 'Data'	+ '.Add("' + sc.name + '", Row.in' + sc.name + '_IsNull ' +
				CASE 
					WHEN type_name(sc.user_type_id) like '%DATE%'
					THEN '? string.Empty : DateTime.Parse(Row.in' + sc.name + '));'
					WHEN type_name(sc.user_type_id) like 'BIGINT'
					THEN ' || Row.in' + sc.name + ' == string.Empty ? 0 : Int64.Parse(Row.in' + sc.name + '));'
					WHEN type_name(sc.user_type_id) like '%INT%'
					THEN ' || Row.in' + sc.name + ' == string.Empty ? 0 : Int32.Parse(Row.in' + sc.name + '));'
				END																																																TypedTransforms
			,'<outputColumn' + 
							CASE
								WHEN type_name(sc.user_type_id) like '%DATE%'
								THEN '
						  refId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.Name + '"
                          dataType="dbTimeStamp"
                          lineageId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          name="'+ sc.name + '" />'
								WHEN type_name(sc.user_type_id) IN ('INT','TINYINT','SMALLINT')
								THEN '
                          refId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          dataType="i4"
                          lineageId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          name="' + sc.name + '" />'
								WHEN type_name(sc.user_type_id) in ('BIGINT') 
								THEN '
                          refId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          dataType="i8"
                          lineageId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          name="' + sc.name + '" />'
						  		WHEN type_name(sc.user_type_id) = 'binary'
								THEN '
						  refId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          codePage="1252"
                          dataType="str"
                          length="64"
                          lineageId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          name="' + sc.name + '" />'
								ELSE '
						  refId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          codePage="1252"
                          dataType="str"
                          length="' + cast(IsNull(sc.max_length,64) as varchar) + '"
                          lineageId="Package\stageMembers\${Path}${OutputName}.Columns' + sc.name + '"
                          name="' + sc.name + '" />'
							END																													OutputColumn
					,'<inputColumn
                      refId="Package\${ComponentPath}.Inputs${InputName}.Columnsin' + sc.name + '"
                      cachedCodepage="1252"
                      cachedDataType="str"
                      cachedLength="50"
                      cachedName="MemberID"
                      lineageId="Package\${SourcePath}.Columns' + sc.name + '"
                      name="in' + sc.name + '" />'																						TransformInputColumn
		from sys.columns sc
		join sys.tables st
		on st.object_id = sc.object_id
	
--	SELECT 
--SchemaName
--,TableName
--,FQTableName
--,ColumnName
--,DataType
--,Precision
--,Scale
--,Max_Length
--,ColumnOrder
--,QuotedColumnName
--,ColumnPublicVariable
--,ColumnparameterVariable
--,ColumnhashVariable
--,ColumnlocalVariable
--,TablePublicVariable
--,TableparameterVariable
--,TablehashVariable
--,TablelocalVariable
--,StringTransform 
--,replace(replace(outputcolumn,'${Path}','DataFlowTask\Script Component.Outputs'),'${OutputName}','Output 0')OutputColumn
--,replace(replace(replace(TransformInputColumn,'${Path}','DataFlowTask\Script Component.Inputs'),'${InputName}','Inupt 0'),'${SourcePath}','Package\DataFlowTask\Flat File Source.OutputsFlat File Source Output')TransformInputColumn
--	FROM TableToCSharp
--	where fqTableName = 'star.Claim'
--		order by columnorder