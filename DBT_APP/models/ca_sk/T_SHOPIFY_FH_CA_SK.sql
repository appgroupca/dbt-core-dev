{{ config(materialized='table') }}

with 

final as (

SELECT 
 REGION = 'CA'
,BRAND = 'SK'
,BRANCH = 'C31'
,[id]
,[order_id]
,[name] AS PO
--,LEFT([fulfillment].[created_at],10) AS FULFILLMENT_DATE
,ISNULL([fulfillment].[created_at] AT TIME ZONE 'US Eastern Standard Time','') AS FULFILLMENT_DATE
--,[fulfillment].[created_at] AS FULFILLMENT_DATE
,ISNULL([tracking_company],'') AS TRACKING_COMPANY
,ISNULL([tracking_number],'') AS TRACKING_NUMBER_LINE_ITEMS
,ISNULL([shipment_status],'') AS TRACKING_STATUS
,TRIM('"[]' FROM [tracking_urls]) AS TRACKING_URL
,[tracking_numbers] AS TRACKING_NUMBER_ORDER_HEADER

FROM [SHOPIFY_PROD].[ca_sk].[fulfillment] WITH (NOLOCK)

)

select * from final