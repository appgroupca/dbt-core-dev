{{ config(materialized='table') }}

WITH
NODE as (
    
	select * 
	FROM {{ ref('T_MATERIAL_NODE')}}
	
),BOM as (
	
	select *
	FROM {{ ref('T_MATERIAL_BOM')}}

),FEATURES as (
	
	select *
	FROM {{ ref('T_MATERIAL_FEATURES')}}

),MAIN as (
	
	select *
	FROM {{ ref('T_MATERIAL_MAIN')}}

)

select c1.[id]
	  ,c1.[season]
	  ,c1.[brand]
      ,c1.[style_name]
      ,c1.[collection]
      ,c1.[node_name]
      --,c2.[bom_materials]
      ,c3.[features]
      ,c4.[main_material]
from NODE C1
--Left join BOM c2 on c1.id=c2.id and c1.app_node_rank=c2.app_bom_rank
Left join FEATURES c3 on c1.id=c3.id and c1.app_node_rank=c3.app_feature_rank
Left join MAIN c4 on c1.id=c4.id and c1.app_node_rank=c4.app_main_rank
