{{ config(materialized='table') }}

with 

final as (

SELECT
	--DIVI AS DIVISION,
    'CONVERT TO CAD' AS RATE_TYPE,
    --'CAD' AS CURRENCY,
    [currency] AS CURRENCY,
    RATE,
	DATEADD(DAY,0, CONVERT(DATE, CONVERT(VARCHAR(8), [Start_Date]), 112)) AS FROM_DATE,
	DATEADD(DAY, -1, CONVERT(DATE, CONVERT(VARCHAR(8), LEAD([Start_Date], 1, '20250106') OVER (PARTITION BY [currency] ORDER BY [Start_Date])))) AS TO_DATE

  FROM [M3RPTDEV].[sharepoint_fpa].[fx_fx]

  )

select * from final