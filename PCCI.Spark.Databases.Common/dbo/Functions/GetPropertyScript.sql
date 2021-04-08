/* Test Values 
DECLARE @FQObjectName		VARCHAR(200)	= 'Schema.Table.Column'			-- SchemaName.TableName.ColumnName
DECLARE @ObjectType			VARCHAR(200)	= 'Column'
DECLARE @PropertyName		VARCHAR(200)	= 'PropertyName' 				-- Name of the property
DECLARE @PropertyValue		VARCHAR(1000)	= 'PropertyValue'				-- Value of the property
DECLARE @OverWriteInd		BIT				=  0							-- If 0 then fail if xolumn exits
*/
CREATE       FUNCTION [dbo].[GetPropertyScript]
	(
		 @FQObjectName		VARCHAR(200)					-- SchemaName.TableName.ColumnName
		,@ObjectType		VARCHAR(200)
		,@PropertyName		VARCHAR(200)					-- Name of the property
		,@PropertyValue		VARCHAR(1000)					-- Value of the property
		,@OverWriteInd		BIT				=  0			-- If 0 then fail if column exits
	)
RETURNS VARCHAR(1000)
AS 
BEGIN 

	DECLARE @SchemaName VARCHAR(200)
	DECLARE @TableName  VARCHAR(200)
	DECLARE @ColumnName VARCHAR(200)
	DECLARE @Sql		VARCHAR(MAX) 

		SELECT 
			@SchemaName = Value 
		FROM DelimitedStringToTable(@FQObjectName,'.')
		WHERE ValueOrder = 1
		SELECT 
			@TableName = Value 
		FROM DelimitedStringToTable(@FQObjectName,'.')
		WHERE ValueOrder = 2
		SELECT 
			@ColumnName = Value 
		FROM DelimitedStringToTable(@FQObjectName,'.')
		WHERE ValueOrder = 3

SELECT @SQL = replace(replace(replace('
exec sp_addextendedproperty  
     @name = N''${Name}'' 
    ,@value = N''${Value}''
    ,@level0type = N''Schema'', @level0name = ''${SchemaName}'''
	,'${PropertyName}',@PropertyName)
	,'${PropertyValue}',@PropertyValue)
	,'${SchemaName}',@SchemaName)
IF @ObjectType IN ('Table','View','Column','Index','Constraint')
SELECT @Sql = @Sql + replace('
    ,@level1type = N''Table'',  @level1name = ''${TableName}''','${TableName}',@TableName)
IF @ObjectTYPE IN ('Column','Index','Constraint')
SELECT @Sql = @Sql + replace('
    ,@level2type = N''Column'', @level2name = ''${ColumnName}'''
	,'${ColumnName}',@ColumnName)

SELECT @Sql = REPLACE(Replace(@Sql,'${Name}',@PropertyName),'${Value}',@PropertyValue)
RETURN
@Sql 

END