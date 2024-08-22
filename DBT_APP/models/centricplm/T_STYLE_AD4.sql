{{ config(materialized='table') }}

WITH
AD4 as (
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
	  ,supplier_number
      ,[collection]      
	  ,P.value as delivery4
	  ,ROW_NUMBER()OVER(PARTITION BY id ORDER BY _4_m_fall) as app_del4_rank
	from {{ source('centricplm','style_production_info') }}
     CROSS APPLY string_split(_4_m_fall, ',') P
)

select * from AD4