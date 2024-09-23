{{ config(materialized='table') }}

with 

final as (

SELECT
 REGION = 'US'
,BRAND = 'MCK'
,BRANCH = 'U31'
,[id] AS [ID]
,[name] AS PO

--,ISNULL(PRE_ORDER_TAG.[value],'') AS PRE_ORDER_TAG
--,ISNULL(NEWSTORE_FAILED_TAG.[value],'') AS NEWSTORE_FAILED_TAG
--,ISNULL(RISKIFIED_DECLINED_TAG.[value],'') AS RISKIFIED_DECLINED_TAG
--,ISNULL(SFCC_TAG.[value],'') AS SFCC_TAG
--,ISNULL(ORDER_DISCOUNT_CODE.[code],'') AS DISCOUNT_CODE
--,ISNULL(ORDER_DISCOUNT_CODE.[type],'') AS DISCOUNT_TYPE
--,ISNULL(ORDER_DISCOUNT_CODE.[amount],'') AS ORDER_DISCOUNT_AMOUNT

,[currency] AS CURRENCY
,[financial_status] AS FINANCIAL_STATUS
,ISNULL([fulfillment_status],'') AS FULFILLMENT_STATUS

,ISNULL([processed_at] AT TIME ZONE 'US Eastern Standard Time','') AS PROCESSED_AT_FULL
,ISNULL(CONVERT(VARCHAR,[order].[processed_at] AT TIME ZONE 'US Eastern Standard Time',23),'') AS PROCESSED_AT
,ISNULL([created_at] AT TIME ZONE 'US Eastern Standard Time','') AS CREATED_AT_FULL
,ISNULL(CONVERT(VARCHAR,[order].[created_at] AT TIME ZONE 'US Eastern Standard Time',23),'') AS CREATED_AT
,ISNULL([cancelled_at] AT TIME ZONE 'US Eastern Standard Time','') AS CANCELLED_AT_FULL
,ISNULL(CONVERT(VARCHAR,[cancelled_at] AT TIME ZONE 'US Eastern Standard Time',23),'') AS CANCELLED_AT

,ISNULL([cancel_reason],'') AS CANCEL_REASON

,ISNULL([closed_at] AT TIME ZONE 'US Eastern Standard Time','') AS CLOSED_AT_FULL
,ISNULL(CONVERT(VARCHAR,[closed_at] AT TIME ZONE 'US Eastern Standard Time',23),'') AS CLOSED_AT

,ISNULL([email],'') AS EMAIL
,ISNULL([note],'') AS NOTE
,ISNULL([shipping_address_name],'') AS SHIPPING_ADDRESS_NAME
,ISNULL([shipping_address_first_name],'') AS SHIPPING_FIRST_NAME
,ISNULL([shipping_address_last_name],'') AS SHIPPING_LAST_NAME
,ISNULL([shipping_address_company],'') AS SHIPPING_COMPANY
,ISNULL([shipping_address_phone],'') AS SHIPPING_PHONE
,ISNULL([shipping_address_address_1],'') AS SHIPPING_ADDRESS_1
,ISNULL([shipping_address_address_2],'') AS SHIPPING_ADDRESS_2
,ISNULL([shipping_address_city],'') AS SHIPPING_CITY
,ISNULL([shipping_address_zip],'') AS SHIPPING_ZIP_CODE
,ISNULL([shipping_address_province],'') AS SHIPPING_PROVINCE
,ISNULL([shipping_address_province_code],'') AS SHIPPING_PROVINCE_CODE
,ISNULL([shipping_address_country],'') AS SHIPPING_COUNTRY
,ISNULL([shipping_address_country_code],'') AS SHIPPING_COUNTRY_CODE
,ISNULL([billing_address_name],'') AS BILLING_ADDRESS_NAME
,ISNULL([billing_address_first_name],'') AS BILLING_FIRST_NAME
,ISNULL([billing_address_last_name],'') AS BILLING_LAST_NAME
,ISNULL([billing_address_company],'') AS BILLING_COMPANY
,ISNULL([billing_address_phone],'') AS BILLING_PHONE
,ISNULL([billing_address_address_1],'') AS BILLING_ADDRESS_1
,ISNULL([billing_address_address_2],'') AS BILLING_ADDRESS_2
,ISNULL([billing_address_city],'') AS BILLING_CITY
,ISNULL([billing_address_zip],'') AS BILLING_ZIP_CODE
,ISNULL([billing_address_province],'') AS BILLING_PROVINCE
,ISNULL([billing_address_province_code],'') AS BILLING_PROVINCE_CODE
,ISNULL([billing_address_country],'') AS BILLING_COUNTRY
,ISNULL([billing_address_country_code],'') AS BILLING_COUNTRY_CODE

FROM [SHOPIFY_PROD].[us_mck].[order] WITH (NOLOCK)

LEFT JOIN [SHOPIFY_PROD].[us_mck].[order_tag] AS PRE_ORDER_TAG WITH (NOLOCK)
ON PRE_ORDER_TAG.[order_id] = [id] 
AND PRE_ORDER_TAG.[value] = 'pre-order'

LEFT JOIN [SHOPIFY_PROD].[us_mck].[order_tag] AS NEWSTORE_FAILED_TAG WITH (NOLOCK)
ON NEWSTORE_FAILED_TAG.[order_id] = [id] 
AND NEWSTORE_FAILED_TAG.[value] = 'newstore_failed'

LEFT JOIN [SHOPIFY_PROD].[us_mck].[order_tag] AS RISKIFIED_DECLINED_TAG WITH (NOLOCK)
ON RISKIFIED_DECLINED_TAG.[order_id] = [id] 
AND RISKIFIED_DECLINED_TAG.[value] = 'Riskified::declined'

LEFT JOIN [SHOPIFY_PROD].[us_mck].[order_tag] AS SFCC_TAG WITH (NOLOCK)
ON SFCC_TAG.[order_id] = [id] 
AND SFCC_TAG.[value] = 'sfcc'

LEFT JOIN [SHOPIFY_PROD].[us_mck].[order_discount_code] AS ORDER_DISCOUNT_CODE WITH (NOLOCK)
ON ORDER_DISCOUNT_CODE.[order_id] = [id]

)

select * from final