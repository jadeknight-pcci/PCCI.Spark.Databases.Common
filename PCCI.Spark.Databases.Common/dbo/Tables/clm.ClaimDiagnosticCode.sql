SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [clm].[ClaimDiagnosticCode](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ClaimTransactionId] [bigint] NOT NULL,
	[ClaimLineId] [bigint] NOT NULL,
	[claimId] [bigint] NOT NULL,
	[Code] [varchar](30) NULL,
	[CodeOrigin] [varchar](30) NULL,
	[Name] [varchar](30) NULL,
	[PrimaryInd] [bit] NOT NULL,
	[ETLCreateDate] [datetime2](7) NOT NULL,
	[ETLUpdateDate] [datetime2](7) NOT NULL,
	[ETLCreateBy] [varchar](30) NOT NULL,
	[ETLUpdateBy] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [clm].[ClaimDiagnosticCode] ADD  DEFAULT ((0)) FOR [PrimaryInd]
GO
ALTER TABLE [clm].[ClaimDiagnosticCode] ADD  DEFAULT (sysdatetime()) FOR [ETLCreateDate]
GO
ALTER TABLE [clm].[ClaimDiagnosticCode] ADD  DEFAULT (sysdatetime()) FOR [ETLUpdateDate]
GO
ALTER TABLE [clm].[ClaimDiagnosticCode] ADD  DEFAULT (user_name()) FOR [ETLCreateBy]
GO
ALTER TABLE [clm].[ClaimDiagnosticCode] ADD  DEFAULT (user_name()) FOR [ETLUpdateBy]
GO
EXEC sys.sp_addextendedproperty @name=N'ClaimDiagnosticCode', @value=N'ClaimDiagnosticCode' , @level0type=N'SCHEMA',@level0name=N'clm', @level1type=N'TABLE',@level1name=N'ClaimDiagnosticCode'
GO
