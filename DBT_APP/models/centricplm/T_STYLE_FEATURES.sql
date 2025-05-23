{{ config(materialized='table') }}

WITH
CC1 as (
    
	select * 
	FROM {{ ref('T_STYLE_FEAT_CC1')}}
	
),CN1 as (
	
	select *
	FROM {{ ref('T_STYLE_FEAT_CN1')}}

),CA1 as (
	
	select *
	FROM {{ ref('T_STYLE_FEAT_CA1')}}
)

SELECT
    c1.[id]
	,c1.[active_style]
    ,c1.[development_type]
	,c1.[Season]
	,c1.[Brand]
    ,c1.[style_name]
    ,c1.[collection]
	,c1.[features]
	,c1.[color_code]
    ,c2.[colorways]
    ,c7.[color_active]

FROM CC1 c1

    LEFT JOIN CN1 c2 on c1.id=c2.id and c1.color_code_rank=c2.color_name_rank
    LEFT JOIN CA1 c7 on c1.id=c7.id and c1.color_code_rank=c7.color_active_rank

WHERE c7.color_active='true' and c1.development_type='REGULAR' and c1.active_style='1'