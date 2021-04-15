SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ref].[RiskGroup](
	[Id] [int] NOT NULL,
	[Code] [int] NULL,
	[Name] [varchar](100) NULL,
	[Description] [varchar](300) NULL,
	[ProductId] [int] NOT NULL,
	[IsEligible] [bit] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[CreateDate] [datetime2](7) NOT NULL,
	[CreateBy] [varchar](30) NOT NULL,
	[UpdateDate] [datetime2](7) NOT NULL,
	[UpdateBy] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ref].[RiskGroup] ADD  DEFAULT ((1)) FOR [IsEligible]
GO
ALTER TABLE [ref].[RiskGroup] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [ref].[RiskGroup] ADD  DEFAULT (sysdatetime()) FOR [CreateDate]
GO
ALTER TABLE [ref].[RiskGroup] ADD  DEFAULT (user_name()) FOR [CreateBy]
GO
ALTER TABLE [ref].[RiskGroup] ADD  DEFAULT (sysdatetime()) FOR [UpdateDate]
GO
ALTER TABLE [ref].[RiskGroup] ADD  DEFAULT (user_name()) FOR [UpdateBy]
GO
EXEC sys.sp_addextendedproperty @name=N'RiskGroup', @value=N'RiskGroup' , @level0type=N'SCHEMA',@level0name=N'ref', @level1type=N'TABLE',@level1name=N'RiskGroup'
GO
