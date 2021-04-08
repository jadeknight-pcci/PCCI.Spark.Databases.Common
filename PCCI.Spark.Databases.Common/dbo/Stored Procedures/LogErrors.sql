﻿CREATE   PROCEDURE dbo.LogErrors
 @ObjectID       INT,
 @DatabaseID     INT = NULL,
 @AdditionalInfo NVARCHAR(MAX) = NULL
AS
BEGIN
 SET NOCOUNT ON;

 DECLARE 
  @ProcedureName NVARCHAR(400);

 SELECT
  @DatabaseID = COALESCE(@DatabaseID, DB_ID()),
  @ProcedureName = COALESCE
  (
   QUOTENAME(DB_NAME(@DatabaseID)) + '.'
   + QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectID, @DatabaseID)) 
   + '.' + QUOTENAME(OBJECT_NAME(@ObjectID, @DatabaseID)),
   ERROR_PROCEDURE()
  );

 INSERT EDW_CTRL_DEMO.dbo.ErrorLog
 (
  DatabaseID,
  ObjectID,
  ProcedureName,
  ErrorLine,
  ErrorMessage,
  AdditionalInfo
 )
 SELECT
  @DatabaseID,
  @ObjectID,
  @ProcedureName,
  ERROR_LINE(),
  ERROR_MESSAGE(),
  @AdditionalInfo;
END