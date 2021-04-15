SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ref].[PlaceOfService](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [int] NOT NULL,
	[Name] [varchar](100) NOT NULL,
	[Description] [varchar](1000) NULL,
	[Source] [varchar](500) NULL,
	[IsCurrent] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[EtlCreateDate] [datetime2](7) NOT NULL,
	[EtlCreateBy] [varchar](30) NOT NULL,
	[EtlUpdateDate] [datetime2](7) NOT NULL,
	[EtlUpdateBy] [varchar](30) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ref].[PlaceOfService] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [ref].[PlaceOfService] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [ref].[PlaceOfService] ADD  DEFAULT (sysdatetime()) FOR [EtlCreateDate]
GO
ALTER TABLE [ref].[PlaceOfService] ADD  DEFAULT (user_name()) FOR [EtlCreateBy]
GO
ALTER TABLE [ref].[PlaceOfService] ADD  DEFAULT (sysdatetime()) FOR [EtlUpdateDate]
GO
ALTER TABLE [ref].[PlaceOfService] ADD  DEFAULT (user_name()) FOR [EtlUpdateBy]
GO
EXEC sys.sp_addextendedproperty @name=N'PlaceOfService', @value=N'PlaceOfService' , @level0type=N'SCHEMA',@level0name=N'ref', @level1type=N'TABLE',@level1name=N'PlaceOfService'
GO
