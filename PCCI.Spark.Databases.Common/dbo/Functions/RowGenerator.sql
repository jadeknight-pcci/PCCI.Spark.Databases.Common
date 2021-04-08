/*
	EXEC RowGenerator @TotalRows = 10000000

*/
CREATE   FUNCTION RowGenerator 
	(
		@TotalRows BIGINT
	)
	RETURNS @RowGen TABLE (RowId BIGINT)
AS
BEGIN
	DECLARE @BatchSize		BIGINT	= 30000
	DECLARE @WholeBatches	BIGINT	= @TotalRows/@BatchSize
	DECLARE @PartialBatch	BIGINT	= @TotalRows % @BatchSize 
	DECLARE @CurrentBatch	BIGINT	= 0
	DECLARE @StartTime		DATETIME2 = SYSDATETIME()
	DECLARE @EndTime		DATETIME2 = NULL
	DECLARE @BatchGen			TABLE 
		(
			RowId BIGINT
		);

		;
		WITH n(n) AS
		(
			SELECT 1 n
			UNION ALL
			SELECT n+1 FROM n WHERE n <  @BatchSize 
		)
		INSERT INTO @BatchGen (RowId) select n from n 
		OPTION (MAXRECURSION 30000)

		WHILE @CurrentBatch < @WholeBatches 
			BEGIN
				INSERT INTO @RowGen (RowId) 
				SELECT 	(@CurrentBatch * @BatchSize ) + RowId FROM @BatchGen
				SELECT @CurrentBatch = @CurrentBatch + 1
			END
			IF @PartialBatch > 0
				BEGIN
					INSERT INTO @RowGen (RowId) 
					SELECT RowId + (@BatchSize * @CurrentBatch) FROM @BatchGen
					WHERE RowId + (@BatchSize * @CurrentBatch) <= @TotalRows
				END
			RETURN
	END