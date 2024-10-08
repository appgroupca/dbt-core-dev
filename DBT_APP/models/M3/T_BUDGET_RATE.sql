{{ config(materialized='table') }}

with 

final as (

  SELECT
	--DIVI AS DIVISION,
    'CONVERT TO CAD' AS RATE_TYPE,
    [CUCD] AS CURRENCY,
    --LOCD AS LOCAL_CURRENCY,
    [ARAT] AS RATE,
	DATEADD(DAY,0, CONVERT(DATE, CONVERT(VARCHAR(8), CUTD), 112)) AS FROM_DATE,
	DATEADD(DAY, -1, CONVERT(DATE, CONVERT(VARCHAR(8), LEAD(CUTD, 1, '20250106') OVER (PARTITION BY [CUCD] ORDER BY [cuTd])))) AS TO_DATE

  FROM {{source('m3','CCURRA')}}
  WHERE
    CONO = '100'
    AND deleted = 'N'
    AND CRTP = '3'
    AND LOCD IN ('CAD')
    AND DIVI = 'CAN'

)

select * from final