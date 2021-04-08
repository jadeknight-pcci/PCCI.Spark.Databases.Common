CREATE   view [dbo].[ForeignKeyResolution]
AS 
	SELECT 
		 pfk.SchemaName
		,pfk.TableName 
		,pfk.ColumnName
		,pfk.ColumnType
		,pfk.ColumnLength
		,pfk.ColumnPrecision
		,pfk.ColumnScale
		,pfk.ReferencedSchema 
		,pfk.ReferencedTable
		,pfk.ReferencedColumn
		,pfk.ReferencedType
		,pfk.ReferencedLength
		,pfk.ReferencedPrecision
		,pfk.ReferencedScale
		,pfk.CurrentForeignKey
		,pfk.DistinctRelationshipCount
		,CASE 
			WHEN
			   pfk.ReferencedType			!=	pfk.ColumnType
			OR pfk.ReferencedLength			!=	pfk.ColumnLength
			OR pfk.ReferencedPrecision		!=	pfk.ColumnPrecision
			OR pfk.ReferencedScale			!=	pfk.ColumnScale
			THEN 'BEGIN' + char(13) + 'PRINT(''Cannot create  ' + ProposedKeyName + ' on ' + SchemaName + '.' + TableName + '.' + columnname + ' due to a data type mismatch '')' + char(13) + 'END' + char(13) 
			ELSE ''
			END IsValid
		, CASE 
			WHEN 
				pfk.ReferencedType			!=	pfk.ColumnType
			OR pfk.ReferencedLength			!=	pfk.ColumnLength
			OR pfk.ReferencedPrecision		!=	pfk.ColumnPrecision
			OR pfk.ReferencedScale			!=	pfk.ColumnScale
			THEN ''
			WHEN IsNull(CurrentForeignKey,'') != ProposedKeyName 
			THEN 'ALTER Table ' + SchemaName + '.' + TableName + char(13)
				+'ADD Constraint ' + proposedkeyname + ' FOREIGN KEY (' + ColumnName + ')' + char(13)
				+'REFERENCES ' + referencedschema + '.' + referencedtable + '(' + referencedcolumn + ')' + char(13)
				+'GO'
			END  ResolutionScript
	,IsNull('Alter Table ' + SchemaName + '.' + TableName + '
	DROP Constraint ' + CurrentForeignKey  + '
','')																													DropScript
from ForeignKeyValidation pfk