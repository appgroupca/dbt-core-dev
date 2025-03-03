{{ config(materialized='table') }}

WITH
CC1 as (

SELECT
    id
	,active_style
	,development_type
	,SUBSTRING(Season,1, 4) AS Season
	,SUBSTRING(season, CHARINDEX(' ', season) + 1, LEN( season)) AS Brand
    ,style_name
    ,[collection]
	,[features]
	,V.value as color_code
	,ROW_NUMBER()OVER(PARTITION BY id ORDER BY code) as color_code_rank
FROM {{ source('centricplm','style_production_info') }}
	CROSS APPLY string_split(code, ',') V
)

select * from CC1