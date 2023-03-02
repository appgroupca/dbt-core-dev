SELECT DISTINCT
 ISNULL(JSON_VALUE(body, '$.tenant'),'') AS TENANT
,ISNULL(JSON_VALUE(body, '$.payload.customer_id'),'') AS CUSTOMER_ID
,ISNULL(JSON_VALUE(body, '$.name'),'') AS [NAME]
,ISNULL(JSON_VALUE(body,'$.published_at'),'') AS PUBLISHED_AT
,ISNULL(JSON_VALUE(body,'$.payload.created_at'),'') AS SHIPPING_DATE
,ISNULL(JSON_VALUE(body,'$.payload.id'),'') AS ID
,ISNULL(JSON_VALUE(body,'$.payload.type'),'') AS [TYPE]
,ISNULL(JSON_VALUE(body,'$.payload.first_name'),'') AS SHIPPING_FIRST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.last_name'),'') AS SHIPPING_LAST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.address_line_1'),'') AS SHIPPING_ADDRESS_LINE_1
,ISNULL(JSON_VALUE(body,'$.payload.zip_code'),'') AS SHIPPING_ZIP_CODE
,ISNULL(JSON_VALUE(body,'$.payload.city'),'') AS SHIPPING_CITY
,ISNULL(JSON_VALUE(body,'$.payload.state'),'') AS SHIPPING_STATE
,ISNULL(JSON_VALUE(body,'$.payload.country_code'),'') AS SHIPPING_COUNTRY_CODE

FROM {{ source('newstore', 'event') }}

WHERE
JSON_VALUE(body,'$.name') = 'customer.address_created' 
AND JSON_VALUE(body,'$.payload.type') = 'shipping'