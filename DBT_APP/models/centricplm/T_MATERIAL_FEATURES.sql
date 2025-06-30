{{ config(materialized='table') }}


WITH
FEATURES as (
	select [id]
      ,style_name
	  ,SUBSTRING(parent_season,1, 4) AS Season
	  ,SUBSTRING(parent_season, CHARINDEX(' ', parent_season) + 1, LEN( parent_season)) AS Brand
      ,[category_1] as collection
      ,P.value as features
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY features) as app_feature_rank
	from {{ source('centricplm','style_material_feature') }}
     CROSS APPLY string_split(features, ',') P
)

select * from FEATURES