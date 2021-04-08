CREATE TABLE [dbo].[NameRules] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [ObjectType]  VARCHAR (50)  NULL,
    [RuleType]    VARCHAR (50)  NULL,
    [RuleValue]   VARCHAR (50)  NULL,
    [Description] VARCHAR (500) NULL,
    [IsCurrent]   BIT           DEFAULT ((1)) NOT NULL,
    [CreateDate]  DATETIME2 (7) DEFAULT (sysdatetime()) NOT NULL,
    [CreateBy]    VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL,
    [UpdateDate]  DATETIME2 (7) DEFAULT (sysdatetime()) NOT NULL,
    [UpdateBy]    VARCHAR (30)  DEFAULT (suser_sname()) NOT NULL
);