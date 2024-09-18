{{ config(materialized='table') }}

with 

final as (

SELECT 
CONVERT(VARCHAR,[DATE],23) AS [Date],

YEAR([Date]) AS [Iso Year],
MONTH([Date]) AS [Iso Month],

CAST(GETDATE() AS DATE) AS [Today],
CASE WHEN GETDATE() > [Date] THEN 'Yes' ELSE 'No' END AS [Actual Date],
CASE WHEN GETDATE() - 1 = [Date] THEN 'Yes' ELSE 'No' END AS [Yesterday Date],

CASE WHEN GETDATE() > [Date] THEN 1 ELSE 0 END AS [Actual Date Integer],
CASE WHEN GETDATE() - 1 = [Date] THEN 1 ELSE 0 END AS [Yesterday Date Integer],

CAST([FISCAL_YEAR] AS INT) AS [Fiscal Year],

CASE 
	WHEN [FISCAL_PERIOD] BETWEEN 1 AND 3 THEN 'Q1' 
	WHEN [FISCAL_PERIOD] BETWEEN 4 AND 6 THEN 'Q2' 
	WHEN [FISCAL_PERIOD] BETWEEN 7 AND 9 THEN 'Q3' 
	WHEN [FISCAL_PERIOD] BETWEEN 10 AND 12 THEN 'Q4' 
		END AS [Fiscal Quarter],

CAST([FISCAL_YEAR] AS CHAR(4)) +  RIGHT('00'+ CAST([FISCAL_PERIOD] AS VARCHAR(2)),2)  as [Fiscal Year Month],
CAST([FISCAL_PERIOD] AS INT) AS [Fiscal Month],
DATENAME(MONTH, DATEADD(MONTH, CAST([FISCAL_PERIOD] AS INT) - 1, 0)) AS [Fiscal Month Description],

LEFT(DATENAME(month, DATEADD(month, CAST([FISCAL_PERIOD] AS INT) - 1, 0)), 3) AS [Fiscal Month Short Description],
CAST([FISCAL_YEAR] AS CHAR(4)) +  RIGHT('00'+ CAST([FISCAL_WEEK] AS VARCHAR(2)),2)  as [Fiscal Year Week],
CAST([FISCAL_WEEK] AS INT) AS [Fiscal Week],

DATEPART(WEEKDAY, CAST([DATE] AS DATE)) AS [Day Of Week],
DATENAME(weekday, [DATE]) AS [Day Name],
LEFT(DATENAME(weekday, [DATE]), 3) AS [Day Name Short],
DATEADD(day, -(DATEPART(WEEKDAY, [DATE]) - 1), [DATE]) AS [Fiscal Current Start Week],
DATEADD(day, -(DATEPART(WEEKDAY, [DATE]) - 7), [DATE]) AS [Fiscal Current End Week],


-- Last Year (LY) Columns
[LY_Date] AS [LY Date],

CAST([LY_Fiscal_Year] AS INT) AS [LY Fiscal Year],

CASE 
	WHEN [LY_Fiscal_Period] BETWEEN 1 AND 3 THEN 'Q1' 
	WHEN [LY_Fiscal_Period] BETWEEN 4 AND 6 THEN 'Q2' 
	WHEN [LY_Fiscal_Period] BETWEEN 7 AND 9 THEN 'Q3' 
	WHEN [LY_Fiscal_Period] BETWEEN 10 AND 12 THEN 'Q4' 
		END AS [LY Fiscal Quarter],

CAST([LY_Fiscal_Year] AS CHAR(4)) + RIGHT('00' + CAST([LY_Fiscal_Period] AS VARCHAR(2)), 2) AS [LY Fiscal Year Month],
CAST([LY_Fiscal_Period] AS INT) AS [LY Fiscal Month],
DATENAME(MONTH, DATEADD(MONTH, CAST([LY_Fiscal_Period] AS INT) - 1, 0)) AS [LY Fiscal Month Description],

LEFT(DATENAME(MONTH, DATEADD(MONTH, CAST([LY_Fiscal_Period] AS INT) - 1, 0)), 3) AS [LY Fiscal Month Short Description],
CAST([LY_Fiscal_Year] AS CHAR(4)) + RIGHT('00' + CAST([LY_Fiscal_Week] AS VARCHAR(2)), 2) AS [LY Fiscal Year Week],
CAST([LY_Fiscal_Week] AS INT) AS [LY Fiscal Week],

DATEPART(WEEKDAY, CAST([LY_Date] AS DATE)) AS [LY Day Of Week],
DATENAME(WEEKDAY, [LY_Date]) AS [LY Day Name],
LEFT(DATENAME(WEEKDAY, [LY_Date]), 3) AS [LY Day Name Short],
DATEADD(DAY, -(DATEPART(WEEKDAY, [LY_Date]) - 1), [LY_Date]) AS [LY Fiscal Current Start Week],
DATEADD(DAY, -(DATEPART(WEEKDAY, [LY_Date]) - 7), [LY_Date]) AS [LY Fiscal Current End Week],

-- Last Last Year (LLY) Columns
[LLY_Date],

CAST([LLY_Fiscal_Year] AS INT) AS [LLY Fiscal Year],

CASE 
	WHEN [LLY_Fiscal_Period] BETWEEN 1 AND 3 THEN 'Q1' 
	WHEN [LLY_Fiscal_Period] BETWEEN 4 AND 6 THEN 'Q2' 
	WHEN [LLY_Fiscal_Period] BETWEEN 7 AND 9 THEN 'Q3' 
	WHEN [LLY_Fiscal_Period] BETWEEN 10 AND 12 THEN 'Q4' 
		END AS [LLY Fiscal Quarter],

CAST([LLY_Fiscal_Year] AS CHAR(4)) + RIGHT('00' + CAST([LLY_Fiscal_Period] AS VARCHAR(2)), 2) AS [LLY Fiscal Year Month],
CAST([LLY_Fiscal_Period] AS INT) AS [LLY Fiscal Month],
DATENAME(MONTH, DATEADD(MONTH, CAST([LLY_Fiscal_Period] AS INT) - 1, 0)) AS [LLY Fiscal Month Description],

LEFT(DATENAME(MONTH, DATEADD(MONTH, CAST([LLY_Fiscal_Period] AS INT) - 1, 0)), 3) AS [LLY Fiscal Month Short Description],
CAST([LLY_Fiscal_Year] AS CHAR(4)) + RIGHT('00' + CAST([LLY_Fiscal_Week] AS VARCHAR(2)), 2) AS [LLY Fiscal Year Week],
CAST([LLY_Fiscal_Week] AS INT) AS [LLY Fiscal Week],

DATEPART(WEEKDAY, CAST([LLY_Date] AS DATE)) AS [LLY Day Of Week],
DATENAME(WEEKDAY, [LLY_Date]) AS [LLY Day Name],
LEFT(DATENAME(WEEKDAY, [LLY_Date]), 3) AS [LLY Day Name Short],
DATEADD(DAY, -(DATEPART(WEEKDAY, [LLY_Date]) - 1), [LLY_Date]) AS [LLY Fiscal Current Start Week],
DATEADD(DAY, -(DATEPART(WEEKDAY, [LLY_Date]) - 7), [LLY_Date]) AS [LLY Fiscal Current End Week],

-- Last Last Last Year (LLLY) Columns
[LLLY_Date],

CAST([LLLY_Fiscal_Year] AS INT) AS [LLLY_Fiscal Year],

CASE 
	WHEN [LLLY_Fiscal_Period] BETWEEN 1 AND 3 THEN 'Q1' 
	WHEN [LLLY_Fiscal_Period] BETWEEN 4 AND 6 THEN 'Q2' 
	WHEN [LLLY_Fiscal_Period] BETWEEN 7 AND 9 THEN 'Q3' 
	WHEN [LLLY_Fiscal_Period] BETWEEN 10 AND 12 THEN 'Q4' 
		END AS [LLLY Fiscal Quarter],

CAST([LLLY_Fiscal_Year] AS CHAR(4)) + RIGHT('00' + CAST([LLLY_Fiscal_Period] AS VARCHAR(2)), 2) AS [LLLY Fiscal Year Month],
CAST([LLLY_Fiscal_Period] AS INT) AS [LLLY Fiscal Month],
DATENAME(MONTH, DATEADD(MONTH, CAST([LLLY_Fiscal_Period] AS INT) - 1, 0)) AS [LLLY Fiscal Month Description],

LEFT(DATENAME(MONTH, DATEADD(MONTH, CAST([LLLY_Fiscal_Period] AS INT) - 1, 0)), 3) AS [LLLY Fiscal Month Short Description],
CAST([LLLY_Fiscal_Year] AS CHAR(4)) + RIGHT('00' + CAST([LLLY_Fiscal_Week] AS VARCHAR(2)), 2) AS [LLLY Fiscal Year Week],
CAST([LLLY_Fiscal_Week] AS INT) AS [LLLY Fiscal Week],

DATEPART(WEEKDAY, CAST([LLLY_Date] AS DATE)) AS [LLLY Day Of Week],
DATENAME(WEEKDAY, [LLLY_Date]) AS [LLLY Day Name],
LEFT(DATENAME(WEEKDAY, [LLLY_Date]), 3) AS [LLLY Day Name Short],
DATEADD(DAY, -(DATEPART(WEEKDAY, [LLLY_Date]) - 1), [LLLY_Date]) AS [LLLY Fiscal Current Start Week],
DATEADD(DAY, -(DATEPART(WEEKDAY, [LLLY_Date]) - 7), [LLLY_Date]) AS [LLLY Fiscal Current End Week],

CASE
    WHEN [Date] = CAST(GETDATE() AS DATE) THEN 'Today'
	WHEN [Date] = CAST(GETDATE() - 1 AS DATE) THEN 'Yesterday'
    WHEN [Date] < CAST(GETDATE() AS DATE) THEN CAST([Date] AS VARCHAR)
	WHEN [Date] > CAST(GETDATE() AS DATE) THEN ''
END AS [Slicer Date]

FROM {{source('m3','Z_PBI_CALENDAR_DATA')}}

  )

select * from final
