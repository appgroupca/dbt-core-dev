{{ config(materialized='table') }}

WITH

CN1 as (
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
	  ,season
      ,style_name
      ,[collection]
	  ,P.value as colorways
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY colorways) as color_name_rank
	from {{ source('centricplm','style_production_info') }}
     CROSS APPLY string_split(colorways, ',') P

)

select * from CN1