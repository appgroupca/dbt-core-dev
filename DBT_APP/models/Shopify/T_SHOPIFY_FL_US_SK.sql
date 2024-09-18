{{ config(materialized='table') }}

with 

final as (

SELECT
 REGION = 'US'
,BRAND_H = 'SK'
--,[fulfillment_id]
,[order_line_id]
,FD.[order_id]
,[product_id]
,[variant_id]
--,[id]
--,FH_US_SK.PO
,MAX(FH_US_SK.FULFILLMENT_DATE) AS FULFILLMENT_DATE
--,FH_US_SK.TRACKING_COMPANY
--,FH_US_SK.TRACKING_NUMBER_LINE_ITEMS
--,FH_US_SK.TRACKING_STATUS
--,FH_US_SK.TRACKING_URL
--,FH_US_SK.TRACKING_NUMBER_ORDER_HEADER
,[vendor]
,[title]
,[name]
,[variant_title]
,[sku]
,[price]
,SUM([quantity]) AS Qty

FROM [SHOPIFY_PROD].[us_sk].[fulfillment_order_line] AS FD WITH (NOLOCK)

LEFT JOIN FH_US_SK WITH (NOLOCK)
ON FH_US_SK.[id] = FD.[fulfillment_id]

GROUP BY
 [order_line_id]
,FD.[order_id]
,[product_id]
,[variant_id]
,[vendor]
,[title]
,[name]
,[variant_title]
,[sku]
,[price]

)

select * from final