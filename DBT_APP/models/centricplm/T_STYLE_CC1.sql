{{ config(materialized='table') }}

WITH

CC1 as (

select 
    id
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
	  ,V.value as color_code
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY code) as color_code_rank
	from {{ source('centricplm','style_production_info') }}
    CROSS APPLY string_split(code, ',') V
)

select * from CC1