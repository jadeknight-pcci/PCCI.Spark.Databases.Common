CREATE       view [dbo].[ForeignKeyValidation]
AS 
	WITH relationships
		AS 
			(

				SELECT 
					 schema_name(st.schema_id)												SchemaName
					,object_name(st.object_id)												TableName 
					,sc.name																ColumnName
					,type_name(sc.user_type_id)												ColumnType
					,sc.max_length															ColumnLength
					,sc.precision															ColumnPrecision
					,sc.scale																ColumnScale
					,schema_name(refTbl.schema_id)											ReferencedSchema 
					,refTbl.name															ReferencedTable
					,refCol.name															ReferencedColumn
					,type_name(refCol.user_type_id)											ReferencedType
					,refCol.max_length														ReferencedLength
					,refCol.precision														ReferencedPrecision
					,refCol.scale															ReferencedScale
					,scFkey.name															CurrentForeignKey
					,count(sc.column_id) over (partition by st.object_id,reftbl.object_id)	DistinctRelationshipCount
				FROM sys.tables refTbl
				JOIN sys.key_constraints refkey
				ON refkey.parent_object_id = refTbl.object_id 
				JOIN sys.indexes refid
				ON refid.is_primary_key = 1
				and refid.object_id = reftbl.object_id
				JOIN sys.index_columns	refkeycol 
				on refkeycol.index_id = refid.index_id 
				AND refkeycol.object_id = reftbl.object_id
				JOIN sys.columns refCol 
				on refCol.object_id = refTbl.object_id 
				and refcol.column_id = refkeycol.column_id
				JOIN sys.columns sc
				on sc.object_id != refTbl.object_id
				and sc.name like ('%' + refcol.name)
				JOIN sys.tables st
				on st.object_id = sc.object_id
				AND sc.name like ('%' + REPLACE(refTbl.name,'DateDimension','Date') + 'Key')
				LEFT JOIN sys.foreign_keys			scfKey
				ON scFKey.parent_object_id = st.object_id
				AND scFKey.Referenced_object_id = reftbl.object_id
				LEFT JOIN sys.foreign_key_columns	scFkeyCol
				ON scfkeycol.constraint_object_id = scfkey.object_id
				AND scfkeycol.parent_column_id = sc.column_id
				AND scfkeycol.Referenced_column_id = refCol.column_id
				WHERE refTbl.type = 'U'
				AND st.type = 'U'
			)
	SELECT 
		 SchemaName
		,TableName 
		,ColumnName
		,ColumnType
		,ColumnLength
		,ColumnPrecision
		,ColumnScale
		,ReferencedSchema 
		,ReferencedTable
		,ReferencedColumn
		,ReferencedType
		,ReferencedLength
		,ReferencedPrecision
		,ReferencedScale
		,CurrentForeignKey
		,DistinctRelationshipCount
		,'fk' + TableName + ColumnName		ProposedKeyName
	FROM Relationships