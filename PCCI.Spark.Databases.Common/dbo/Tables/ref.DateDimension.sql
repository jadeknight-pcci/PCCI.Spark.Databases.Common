SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ref].[DateDimension](
	[Id] [int] NOT NULL,
	[CommonDate] [date] NOT NULL,
	[DayOfMonth] [tinyint] NOT NULL,
	[DaySuffix] [char](2) NOT NULL,
	[DayOfWeekNumber] [tinyint] NOT NULL,
	[DayOfWeekName] [varchar](10) NOT NULL,
	[IsWeekend] [bit] NOT NULL,
	[IsHoliday] [bit] NOT NULL,
	[DayOfWeekInMonthNbr] [tinyint] NOT NULL,
	[JulianDay] [smallint] NOT NULL,
	[WeekOfMonthNumber] [tinyint] NOT NULL,
	[WeekOfYearNumber] [tinyint] NOT NULL,
	[IsoWeekOfYear] [tinyint] NOT NULL,
	[MonthNumber] [tinyint] NOT NULL,
	[MonthName] [varchar](10) NOT NULL,
	[MonthAbbreviation] [varchar](3) NOT NULL,
	[Quarter] [tinyint] NOT NULL,
	[QuarterName] [varchar](6) NOT NULL,
	[YearNumber] [int] NOT NULL,
	[MonthYearNumber] [char](6) NOT NULL,
	[MonthNameYear] [char](7) NOT NULL,
	[FirstDayOfMonthDate] [date] NOT NULL,
	[LastDayOfMonthDate] [date] NOT NULL,
	[FirstDayOfQuarterDate] [date] NOT NULL,
	[LastDayOfQuarterDate] [date] NOT NULL,
	[FirstDayOfYearDate] [date] NOT NULL,
	[LastDayOfYearDate] [date] NOT NULL,
	[FirstDayOfNextMonthDate] [date] NOT NULL,
	[FirstDayOfNextYearDate] [date] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE CLUSTERED INDEX [idxDateDimensionMonthYearName] ON [ref].[DateDimension]
(
	[Id] ASC,
	[MonthYearNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'DateDimension', @value=N'DateDimension' , @level0type=N'SCHEMA',@level0name=N'ref', @level1type=N'TABLE',@level1name=N'DateDimension'
GO
