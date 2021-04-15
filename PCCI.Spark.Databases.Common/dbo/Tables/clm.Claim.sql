SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [clm].[Claim](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ClaimNumber] [varchar](30) NOT NULL,
	[ClaimGuid] [uniqueidentifier] NOT NULL,
	[Product] [varchar](30) NOT NULL,
	[ClaimType] [varchar](30) NOT NULL,
	[MemberNumber] [varchar](30) NOT NULL,
	[PaymentStatus] [varchar](30) NOT NULL,
	[Lines] [int] NOT NULL,
	[BeginServiceDateId] [int] NOT NULL,
	[EndServiceDateId] [int] NOT NULL,
	[LastPaymentDateId] [int] NOT NULL,
	[TotalPaidAmt] [decimal](27, 3) NOT NULL,
	[TotalCOBAmt] [decimal](27, 3) NOT NULL,
	[TotalCopayAmt] [decimal](27, 3) NOT NULL,
	[TotalAllowedAmt] [decimal](27, 3) NOT NULL,
	[TotalWithheldAmt] [decimal](27, 3) NOT NULL,
	[CreateDate] [datetime2](7) NOT NULL,
	[UpdateDate] [datetime2](7) NOT NULL,
	[ETLCreateDate] [datetime2](7) NOT NULL,
	[ETLUpdateDate] [datetime2](7) NOT NULL,
	[ETLCreateBy] [varchar](30) NOT NULL,
	[ETLUpdateBy] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [clm].[Claim] ADD  CONSTRAINT [pkClaim] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
ALTER TABLE [clm].[Claim] ADD  CONSTRAINT [nkClaim] UNIQUE NONCLUSTERED 
(
	[ClaimNumber] ASC,
	[Product] ASC,
	[ClaimType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT ((0)) FOR [TotalPaidAmt]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT ((0)) FOR [TotalCOBAmt]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT ((0)) FOR [TotalCopayAmt]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT ((0)) FOR [TotalAllowedAmt]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT (sysdatetime()) FOR [ETLCreateDate]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT (sysdatetime()) FOR [ETLUpdateDate]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT (user_name()) FOR [ETLCreateBy]
GO
ALTER TABLE [clm].[Claim] ADD  DEFAULT (user_name()) FOR [ETLUpdateBy]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE    TRIGGER [clm].[insUpdTrgClaim]
ON [clm].[Claim]
AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
		SET NOCOUNT ON;
		INSERT INTO logs.Claim
	(
		 Id
		,ClaimGuid 
		,ClaimNumber
		,ClaimType 
		,Product 
		,CreateDate 
		,ActionInd
		,ConsDate 
	)
		SELECT
		 IsNull(i.Id		 ,d.Id				)	Id
		,IsNull(i.ClaimGuid,d.ClaimGuid			)	ClaimGuid
		,IsNull(i.ClaimType	 ,d.ClaimType		)	ClaimType
		,IsNull(i.ClaimNumber,d.ClaimNumber 	)	ClaimNumber
		,IsNull(i.Product	 ,d.Product			)	Product
		,IsNull(i.CreateDate ,d.CreateDate 		)	CreateDate 
		,CASE 
			WHEN i.Id = d.Id 
			THEN 'U'																-- Set Action to Updated.
			WHEN d.Id is null
			THEN 'I'																-- Set Action to Insert.
			WHEN i.Id is null 
			THEN 'D'																-- Set Action to Deleted.
			ELSE NULL																-- Skip. It may have been a "failed delete".   
			END										Action
		,sysdatetime()								ConsDate
		FROM inserted i
		FULL JOIN deleted d
		on d.Id = i.Id 
		and d.CreateDate = i.CreateDate 
END
GO
ALTER TABLE [clm].[Claim] ENABLE TRIGGER [insUpdTrgClaim]
GO
EXEC sys.sp_addextendedproperty @name=N'Claim', @value=N'Claim' , @level0type=N'SCHEMA',@level0name=N'clm', @level1type=N'TABLE',@level1name=N'Claim'
GO
