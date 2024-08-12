SELECT DISTINCT
 ISNULL(JSON_VALUE(body, '$.tenant'),'') AS TENANT
,ISNULL(JSON_VALUE(body, '$.name'),'') AS [NAME]
,ISNULL(JSON_VALUE(body,'$.published_at'),'') AS PUBLISHED_DATE
,ISNULL(JSON_VALUE(body,'$.payload.created_at'),'') AS CREATION_DATE
,ISNULL(JSON_VALUE(body, '$.payload.id'),'') AS CUSTOMER_ID
,ISNULL(JSON_VALUE(body, '$.payload.email'),'') AS EMAIL
,ISNULL(JSON_VALUE(body, '$.payload.first_name'),'') AS FIRST_NAME
,ISNULL(JSON_VALUE(body, '$.payload.last_name'),'') AS LAST_NAME
,ISNULL(JSON_VALUE(body, '$.payload.phone'),'') AS PHONE
,ISNULL(JSON_VALUE(body, '$.payload.source.location_id'),'') AS LOCATION_ID
,ISNULL(JSON_VALUE(body, '$.payload.source.associate_id'),'') AS ASSOCIATE_ID
,ISNULL(JSON_VALUE(body, '$.payload.source.associate_name'),'') AS ASSOCIATE_NAME
,ISNULL(JSON_VALUE(body, '$.payload.source.associate_email'),'') AS ASSOCIATE_EMAIL

FROM {{ source('newstore', 'event') }}

WHERE JSON_VALUE(body,'$.name') = 'customer.created'