{{ config(materialized='table') }}


WITH
MAIN as (
	select [id]
      ,style_name
	  ,SUBSTRING(parent_season,1, 4) AS Season
	  ,SUBSTRING(parent_season, CHARINDEX(' ', parent_season) + 1, LEN( parent_season)) AS Brand
      ,[category_1] as collection
      ,P.value as main_material
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY main_material) as app_main_rank
	from {{ source('centricplm','style_material_feature') }}
     CROSS APPLY string_split(main_material, ',') P
)

select * from MAIN