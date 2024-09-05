{{ config(materialized='table') }}

with 

final as (

SELECT
 REGION = 'CA'
,BRAND = 'SK'
,BRANCH = 'C31'
,OD.[order_id]
,OD.[id]
,OD.[product_id]
,OD.[variant_id]
,OH_CA_SK.PO
,OH_CA_SK.PRE_ORDER_TAG
,OH_CA_SK.NEWSTORE_FAILED_TAG
,OH_CA_SK.RISKIFIED_DECLINED_TAG
,OH_CA_SK.SFCC_TAG
,OH_CA_SK.CURRENCY
,OH_CA_SK.FINANCIAL_STATUS
,OH_CA_SK.FULFILLMENT_STATUS AS ORDER_STATUS
,OH_CA_SK.PROCESSED_AT_FULL
,OH_CA_SK.PROCESSED_AT
,OH_CA_SK.CREATED_AT_FULL
,OH_CA_SK.CREATED_AT
,OH_CA_SK.CANCELLED_AT_FULL
,OH_CA_SK.CANCELLED_AT
,OH_CA_SK.CANCEL_REASON
,OH_CA_SK.CLOSED_AT_FULL
,OH_CA_SK.CLOSED_AT
,OH_CA_SK.EMAIL
,OH_CA_SK.NOTE
,OD.[vendor] AS BRAND_ITEM
,OD.[title] AS STYLE
,OD.[variant_title] AS VARIANT
,OD.[name] AS FULL_NAME
,OD.[sku] AS SKU
,OD.[price] AS PRICE
,OD.[total_discount] AS TOTAL_DISCOUNT
,OD.[quantity] AS QTY
,OD.[pre_tax_price] AS SUBTOTAL
,CASE WHEN OH_CA_SK.CANCEL_REASON = 'fraud' THEN 0 ELSE OD.[quantity] END AS QTY_ADJ
,CASE WHEN OH_CA_SK.CANCEL_REASON = 'fraud' THEN 0 ELSE OD.[pre_tax_price] END AS SUBTOTAL_ADJ
,ISNULL(OD.[fulfillment_status],'') AS FULFILLMENT_STATUS
,ISNULL(OD.[tax_code],'') AS TAX_CODE
,OH_CA_SK.SHIPPING_ADDRESS_NAME
,OH_CA_SK.SHIPPING_FIRST_NAME
,OH_CA_SK.SHIPPING_LAST_NAME
,OH_CA_SK.SHIPPING_COMPANY
,OH_CA_SK.SHIPPING_PHONE
,OH_CA_SK.SHIPPING_ADDRESS_1
,OH_CA_SK.SHIPPING_ADDRESS_2
,OH_CA_SK.SHIPPING_CITY
,OH_CA_SK.SHIPPING_ZIP_CODE
,OH_CA_SK.SHIPPING_PROVINCE
,OH_CA_SK.SHIPPING_PROVINCE_CODE
,OH_CA_SK.SHIPPING_COUNTRY
,OH_CA_SK.SHIPPING_COUNTRY_CODE
,OH_CA_SK.BILLING_ADDRESS_NAME
,OH_CA_SK.BILLING_FIRST_NAME
,OH_CA_SK.BILLING_LAST_NAME
,OH_CA_SK.BILLING_COMPANY
,OH_CA_SK.BILLING_PHONE
,OH_CA_SK.BILLING_ADDRESS_1
,OH_CA_SK.BILLING_ADDRESS_2
,OH_CA_SK.BILLING_CITY
,OH_CA_SK.BILLING_ZIP_CODE
,OH_CA_SK.BILLING_PROVINCE
,OH_CA_SK.BILLING_PROVINCE_CODE
,OH_CA_SK.BILLING_COUNTRY
,OH_CA_SK.BILLING_COUNTRY_CODE

FROM [SHOPIFY_PROD].[ca_sk].[order_line] AS OD WITH (NOLOCK)

LEFT JOIN OH_CA_SK WITH (NOLOCK)
ON OH_CA_SK.[id] = OD.[order_id]

    )

select * from final