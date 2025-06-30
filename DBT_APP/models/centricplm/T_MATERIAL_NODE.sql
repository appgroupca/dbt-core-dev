{{ config(materialized='table') }}


WITH
NODE as (
	select [id]
      ,style_name
	  ,SUBSTRING(parent_season,1, 4) AS Season
	  ,SUBSTRING(parent_season, CHARINDEX(' ', parent_season) + 1, LEN( parent_season)) AS Brand
      ,[category_1] as collection
      ,P.value as node_name
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY node_name) as app_node_rank
	from {{ source('centricplm','style_material_feature') }}
     CROSS APPLY string_split(node_name, ',') P
)

select * from NODE