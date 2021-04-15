SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [clm].[ClaimTransaction](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ClaimLineId] [bigint] NOT NULL,
	[ClaimId] [bigint] NOT NULL,
	[ClaimNumber] [varchar](30) NOT NULL,
	[LineNumber] [int] NOT NULL,
	[TransactionType] [varchar](5) NULL,
	[TransactionNumber] [varchar](30) NULL,
	[ClaimType] [varchar](30) NOT NULL,
	[MemberNumber] [varchar](30) NULL,
	[Product] [varchar](30) NOT NULL,
	[ProviderNumber] [varchar](30) NULL,
	[PaymentDateId] [int] NULL,
	[DischargeDateId] [int] NULL,
	[ServiceDateId] [int] NULL,
	[TypeofService] [varchar](30) NULL,
	[PlaceofService] [varchar](5) NULL,
	[DischargeStatus] [int] NULL,
	[Units] [decimal](27, 9) NULL,
	[InpatientDayTotal] [int] NULL,
	[AuthorizationNumber] [varchar](30) NULL,
	[PaymentStatus] [varchar](10) NULL,
	[AllowedAmt] [decimal](27, 3) NULL,
	[PaymentAmt] [decimal](27, 3) NULL,
	[WithholdAmt] [decimal](27, 3) NULL,
	[CopayAmt] [decimal](27, 3) NULL,
	[CobAmt] [decimal](27, 3) NULL,
	[SourceCLaimNumber] [varchar](30) NOT NULL,
	[CreateDate] [datetime2](7) NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[EtlCreateDate] [datetime2](7) NOT NULL,
	[EtlUpdateDate] [datetime2](7) NOT NULL,
	[EtlCreateBy] [varchar](30) NOT NULL,
	[EtlUpdateBy] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [clm].[ClaimTransaction] ADD  CONSTRAINT [pkClaimTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [clm].[ClaimTransaction] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [clm].[ClaimTransaction] ADD  DEFAULT (sysdatetime()) FOR [EtlCreateDate]
GO
ALTER TABLE [clm].[ClaimTransaction] ADD  DEFAULT (sysdatetime()) FOR [EtlUpdateDate]
GO
ALTER TABLE [clm].[ClaimTransaction] ADD  DEFAULT (user_name()) FOR [EtlCreateBy]
GO
ALTER TABLE [clm].[ClaimTransaction] ADD  DEFAULT (user_name()) FOR [EtlUpdateBy]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [clm].[insUpdTrgClaimTransaction]
ON [clm].[ClaimTransaction]
AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
		SET NOCOUNT ON;
		INSERT INTO logs.ClaimTransaction
	(
		 Id
		,ClaimId 
		,ClaimLineId 
		,SourceClaimNumber
		,LineNumber
		,Product 
		,CreateDate
		,ConsDate 
		,ActionInd
	)
		SELECT
		 IsNull(i.Id				,d.Id					)	Id
		,IsNull(i.ClaimId			,d.ClaimId				)	ClaimId
		,IsNull(i.ClaimLineId		,d.ClaimLineId			)	ClaimLineId
		,IsNull(i.SourceClaimNumber	,d.SourceClaimNumber 	)	SourceClaimNumber
		,IsNull(i.LineNumber		,d.LineNumber			)	LineNumber
		,IsNull(i.Product			,d.Product				)	Product
		,IsNull(i.CreateDate		,d.CreateDate 			)	CreateDate 
		,SYSDATETIME()											ConsDate
		,CASE 
			WHEN i.Id = d.Id 
			THEN 'U'																-- Set Action to Updated.
			WHEN d.Id is null
			THEN 'I'																-- Set Action to Insert.
			WHEN i.Id is null 
			THEN 'D'																-- Set Action to Deleted.
			ELSE NULL																-- Skip. It may have been a "failed delete".   
			END										Action
		FROM inserted i
		FULL JOIN deleted d
		on d.Id = i.Id 
		and d.CreateDate = i.CreateDate 
END
GO
ALTER TABLE [clm].[ClaimTransaction] ENABLE TRIGGER [insUpdTrgClaimTransaction]
GO
EXEC sys.sp_addextendedproperty @name=N'ClaimTransaction', @value=N'ClaimTransaction' , @level0type=N'SCHEMA',@level0name=N'clm', @level1type=N'TABLE',@level1name=N'ClaimTransaction'
GO
