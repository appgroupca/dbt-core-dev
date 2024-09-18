{{ config(materialized='table') }}

with 

final as (

SELECT *
FROM FL_CA_MCK WITH (NOLOCK)

UNION ALL
SELECT *
FROM FL_CA_SK WITH (NOLOCK)

UNION ALL
SELECT *
FROM FL_US_MCK WITH (NOLOCK)

UNION ALL
SELECT *
FROM FL_US_SK WITH (NOLOCK)

UNION ALL
SELECT *
FROM FL_EU_MCK WITH (NOLOCK)

UNION ALL
SELECT *
FROM FL_UK_MCK WITH (NOLOCK)

)

SELECT
 CONCAT(REGION,'-',BRAND_H,'-',[order_id],'-',[order_line_id]) AS ID_SP_FULFILLMENT
,REGION
,BRAND_H
,[order_line_id]
,[order_id]
,[product_id]
,[variant_id]
,FULFILLMENT_DATE
,[vendor]
,[title]
,[name]
,[variant_title]
,[sku]
,[price]
,Qty

FROM SHOPIFY_UNION WITH (NOLOCK)

)

select * from final