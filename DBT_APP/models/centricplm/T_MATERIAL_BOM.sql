{{ config(materialized='table') }}


WITH
BOM as (
	select [id]
      ,style_name
	  ,SUBSTRING(parent_season,1, 4) AS Season
	  ,SUBSTRING(parent_season, CHARINDEX(' ', parent_season) + 1, LEN( parent_season)) AS Brand
      ,[category_1] as collection
      ,P.value as bom_materials
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY bommain_materials) as app_bom_rank
	from {{ source('centricplm','style_material_feature') }}
     CROSS APPLY string_split(bommain_materials, ',') P
)

select * from BOM