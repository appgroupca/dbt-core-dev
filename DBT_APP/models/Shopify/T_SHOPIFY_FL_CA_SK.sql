{{ config(materialized='table') }}

with 

final as (

SELECT
 REGION = 'CA'
,BRAND_H = 'SK'
--,[fulfillment_id]
,[order_line_id]
,FD.[order_id]
,[product_id]
,[variant_id]
--,[id]
--,FH_CA_SK.PO
,MAX(FH_CA_SK.FULFILLMENT_DATE) AS FULFILLMENT_DATE
--,FH_CA_SK.TRACKING_COMPANY
--,FH_CA_SK.TRACKING_NUMBER_LINE_ITEMS
--,FH_CA_SK.TRACKING_STATUS
--,FH_CA_SK.TRACKING_URL
--,FH_CA_SK.TRACKING_NUMBER_ORDER_HEADER
,[vendor]
,[title]
,[name]
,[variant_title]
,[sku]
,[price]
,SUM([quantity]) AS Qty

FROM [SHOPIFY_PROD].[ca_sk].[fulfillment_order_line] AS FD WITH (NOLOCK)

LEFT JOIN FH_CA_SK WITH (NOLOCK)
ON FH_CA_SK.[id] = FD.[fulfillment_id]

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