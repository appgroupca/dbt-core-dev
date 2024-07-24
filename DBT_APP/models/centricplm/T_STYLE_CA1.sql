{{ config(materialized='table') }}

WITH
CA1 as (
	select id
      ,app_erpsent_sample
      ,app_erpsent_regular
      ,development_type
	  ,app_fabric_group
	  ,app_delivery_period
	  ,supplier
	  ,country
	  ,designated_supplier
	  ,active_style
	  ,SUBSTRING(Season,1, 4) AS Season
	  ,SUBSTRING(season, CHARINDEX(' ', season) + 1, LEN( season)) AS Brand
      ,style_name
      ,collection
	  ,P.value as color_active
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY active_colorway) as color_active_rank
	from {{ source('centricplm','style_production_info') }}
      CROSS APPLY string_split(active_colorway, ',') P

)

select * from CA1