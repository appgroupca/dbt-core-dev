SELECT DISTINCT
 ISNULL(JSON_VALUE(body,'$.tenant'),'') AS TENANT
,ISNULL(JSON_VALUE(body,'$.name'),'') AS [NAME]
,ISNULL(JSON_VALUE(body,'$.published_at'),'') AS PUBLISHED_DATE
,ISNULL(JSON_VALUE(body,'$.payload.id'),'') AS CUSTOMER_ID
,ISNULL(JSON_VALUE(body,'$.payload.email'),'') AS EMAIL
,ISNULL(JSON_VALUE(body,'$.payload.first_name'),'') AS FIRST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.last_name'),'') AS LAST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.phone'),'') AS PHONE
,ISNULL(cast(JSON_VALUE(body,'$.payload.revision') as int),'') AS REVISION

FROM {{ source('newstore', 'event') }}

WHERE
JSON_VALUE(body,'$.name') = 'customer.updated'