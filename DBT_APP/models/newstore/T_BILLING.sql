{{ config(materialized='table') }}

SELECT
 [order_id]
,[customer_id]
,CONCAT('NS-',[channel_type]) AS [channel_type]
,[external_id]
,REPLACE(LEFT([created_at],10),'-','') AS [created_at]
--,[channel_type]
,[is_exchange]
,[customer_email]
,[customer_display_id]
,[customer_name]
,[phone_number]
,[shipping_first_name]
,[shipping_last_name]
,[shipping_zip_code]
,[shipping_city]
,[shipping_country]
,[shipping_phone]
,[shipping_state]
,[billing_first_name]
,[billing_last_name]
,[billing_zip_code]
,[billing_city]
,[billing_country]
,[billing_phone]
,[billing_state]
,CONCAT([billing_address_line_1], ' ',[billing_address_line_2]) AS [billing_address]

FROM [M3RPTDEV].[Newstore].[SalesOrders]

WHERE is_exchange = 'N'