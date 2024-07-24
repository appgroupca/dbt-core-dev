{{ config(materialized='table') }}

WITH
CC1 as (
    
	select * 
	FROM {{ ref('T_STYLE_CC1')}}
	
),CN1 as (
	
	select *
	FROM {{ ref('T_STYLE_CN1')}}

),AD1 as (
	
	select *
	FROM {{ ref('T_STYLE_AD1')}}

),AD2 as (
	
	select *
	FROM {{ ref('T_STYLE_AD2')}}

),AD3 as (
	
	select *
	FROM {{ ref('T_STYLE_AD3')}}

),AD4 as (
	
	select *
	FROM {{ ref('T_STYLE_AD4')}}

),CA1 as (
	
	select *
	FROM {{ ref('T_STYLE_CA1')}}

)

select c1.[id]
      ,c1.[app_erpsent_sample]
      ,c1.[app_erpsent_regular]
      ,c1.[development_type]
	  ,c1.[app_fabric_group]
	  ,c1.[app_delivery_period]
	  ,c1.[country]
	  ,c1.[designated_supplier]
	  ,c1.[active_style]
	  ,c1.[season]
	  ,c1.[brand]
      ,c1.[style_name]
      ,c1.[collection]    
      ,c1.[supplier]
	  ,c1.color_code
	  ,c2.colorways
	  ,c3.delivery1
	  ,c4.delivery2
	  ,c5.delivery3
	  ,c6.delivery4
	  ,c7.color_active
from CC1 C1
Left join CN1 c2 on c1.id=c2.id and c1.color_code_rank=c2.color_name_rank
Left join AD1 c3 on c1.id=c3.id and c1.color_code_rank=c3.app_del1_rank
Left join AD2 c4 on c1.id=c4.id and c1.color_code_rank=c4.app_del2_rank
Left join AD3 c5 on c1.id=c5.id and c1.color_code_rank=c5.app_del3_rank
Left join AD4 c6 on c1.id=c6.id and c1.color_code_rank=c6.app_del4_rank
Left join CA1 c7 on c1.id=c7.id and c1.color_code_rank=c7.color_active_rank
