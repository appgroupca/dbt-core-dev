{{ config(materialized='table') }}

with 

final as (

SELECT *
FROM LOOP_CA_MCK
 
UNION ALL
SELECT *
FROM LOOP_CA_SK

UNION ALL
SELECT *
FROM LOOP_US_MCK

UNION ALL
SELECT *
FROM LOOP_US_SK

UNION ALL
SELECT *
FROM LOOP_EU_MCK

UNION ALL
SELECT *
FROM LOOP_UK_MCK

)

SELECT
 ROW_NUMBER() OVER(ORDER BY [Shopify Order UUID] ASC) AS LOOP_ROW_ID
--,CONCAT([Shopify Order ID],'-',[Product Variant]) AS ID
,CONCAT('RETURN-',[Shopify Order ID],'-',REPLACE([SKU], '_', '/')) AS ID
,LOOP_TYPE = 'RETURN'
,[Shopify Order ID] AS LOOP_SHOPIFY_ORDER_ID
,[Product Variant] AS LOOP_PRODUCT_VARIANT
,Region AS LOOP_REGION
,Brand AS LOOP_BRAND
,[Loop RMA ID] AS LOOP_RMA_ID
,[Loop Return Warehouse ID] AS LOOP_RETURN_WAREHOUSE_ID
,[Return Tracking #] AS LOOP_RETURN_TRACKING
,[Shopify Order UUID] AS LOOP_SHOPIFY_ORDER_UUID
,[label_updated_at] AS LOOP_LABEL_UPDATED_AT
,[Return Status] AS LOOP_RETURN_STATUS
,[status_page_url] AS LOOP_STATUS_PAGE_URL
,[order_id] AS LOOP_ORDER_ID
,[Return Total] AS LOOP_RETURN_TOTAL
,[discount_total] AS LOOP_DISCOUNT_TOTAL
,[tax_total] AS LOOP_TAX_TOTAL
,[gift_card] AS LOOP_GIFT_CARD
,[order_number] AS LOOP_ORDER_NUMBER
,[Order Total] AS LOOP_ORDER_TOTAL
,[currency] AS LOOP_CURRENCY
,[Product Gross Price] AS LOOP_PRODUCT_GROSS_PRICE
,[label_status] AS LOOP_LABEL_STATUS
,[carrier] AS LOOP_CARRIER
,[customer] AS LOOP_CUSTOMER
,[label_rate] AS LOOP_LABEL_RATE
,[label_url] AS LOOP_LABEL_URL
,[Parent Return Reason] AS LOOP_PARENT_RETURN_REASON
,[Return Reason] AS LOOP_RETURN_REASON
--,[SKU] AS LOOP_SKU
,REPLACE([SKU], '_', '/') AS LOOP_SKU
,[Product Name] AS LOOP_PRODUCT_NAME
,[Product Barcode] AS LOOP_PRODUCT_BARCODE
,[Date Created] AS [LOOP_DATE]

FROM LOOP_UNION

select * from final