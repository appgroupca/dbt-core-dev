{{ config(materialized='incremental') }}


SELECT
LEFT([column_1],10) AS [DATE]
--,[column_0] AS RAW_BRANCH
,ISNULL(BOB.BRANCH,[column_0]) AS BRANCH
--,SUM([column_2]) AS TRAFFIC
,CASE WHEN ISNULL(BOB.BRANCH,[column_0]) = 'F61' THEN ROUND(SUM([column_2])*0.25,0) ELSE ROUND(SUM([column_2])*0.80,0) END AS TRAFFIC
,MAX(_fivetran_synced) as _fivetran_synced

 

FROM {{ source('sms', 'traffic') }}

 

LEFT JOIN {{ source('m3', 'Z_PBI_BRANCH_OLD_BRANCH') }} AS BOB WITH (NOLOCK)
ON BOB.[OLD_BRANCH] COLLATE SQL_Latin1_General_CP1_CI_AS = [column_0]

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}

GROUP BY
LEFT([column_1],10)
,[column_0]
,BOB.BRANCH
