{{ config(materialized='view') }}

SELECT
CONVERT(VARCHAR,[Date],23) AS [DATE]
--,[store_id] AS RAW_BRANCH
,ISNULL(BOB.BRANCH,[store_id]) AS BRANCH
,ROUND(ISNULL([traffic],0),0) AS TRAFFIC

 

FROM {{ source('sms', 'storetraffic_manual') }}

 

LEFT JOIN {{ source('m3', 'Z_PBI_BRANCH_OLD_BRANCH') }} AS BOB WITH (NOLOCK)
ON BOB.[OLD_BRANCH] COLLATE SQL_Latin1_General_CP1_CI_AS = [store_id]