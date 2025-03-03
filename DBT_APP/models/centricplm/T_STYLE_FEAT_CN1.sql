{{ config(materialized='table') }}

WITH
CN1 as (

SELECT
	id
	,active_style
	,development_type
	,SUBSTRING(Season,1, 4) AS Season
	,SUBSTRING(season, CHARINDEX(' ', season) + 1, LEN( season)) AS Brand
    ,style_name
    ,[collection]
	,[features]
	,P.value as colorways
	,ROW_NUMBER()OVER(PARTITION BY id ORDER BY colorways) as color_name_rank
FROM {{ source('centricplm','style_production_info') }}
	CROSS APPLY string_split(colorways, ',') P
)

select * from CN1