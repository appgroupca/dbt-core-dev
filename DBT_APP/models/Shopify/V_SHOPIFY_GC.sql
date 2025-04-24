{{ config(materialized='view') }}

WITH CA_GC
as (
		SELECT * from {{ref("V_SHOPIFY_GC_CA")}}
 	),

US_GC
as (
	SELECT * from {{ref("V_SHOPIFY_GC_US")}}
),

EU_GC
as (
	SELECT * from {{ref("V_SHOPIFY_GC_EU")}}
),

UK_GC
as (
	SELECT * from {{ref("V_SHOPIFY_GC_UK")}}
),

SKCA_GC
as (
	SELECT * from {{ref("V_SHOPIFY_GC_SK_CA")}}
),

SKUS_GC
as (
	SELECT * from {{ref("V_SHOPIFY_GC_SK_US")}}
)

select * from CA_GC
UNION ALL
select * from US_GC
UNION ALL
select * from EU_GC
UNION ALL
select * from UK_GC
UNION ALL
select * from SKCA_GC
UNION ALL
select * from SKUS_GC;