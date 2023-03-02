WITH

CORP AS (

SELECT DISTINCT
 --[TYPE] = 'CREATION'
 --body AS BODY
 ISNULL(JSON_VALUE(body, '$.tenant'),'') AS TENANT
,ISNULL(JSON_VALUE(body, '$.name'),'') AS [NAME]
,MAX(ISNULL(JSON_VALUE(body,'$.published_at'),'')) AS PUBLISHED_DATE
,MAX(ISNULL(JSON_VALUE(body,'$.payload.created_at'),'')) AS CREATION_DATE
,ISNULL(JSON_VALUE(body, '$.payload.id'),'') AS CUSTOMER_ID
,ISNULL(JSON_VALUE(body, '$.payload.email'),'') AS EMAIL
,ISNULL(JSON_VALUE(body, '$.payload.first_name'),'') AS FIRST_NAME
,ISNULL(JSON_VALUE(body, '$.payload.last_name'),'') AS LAST_NAME
,ISNULL(JSON_VALUE(body, '$.payload.last_name'),'') AS PHONE
,ISNULL(JSON_VALUE(body, '$.payload.source.location_id'),'') AS LOCATION_ID
,ISNULL(JSON_VALUE(body, '$.payload.source.associate_id'),'') AS ASSOCIATE_ID
,ISNULL(JSON_VALUE(body, '$.payload.source.associate_name'),'') AS ASSOCIATE_NAME
,ISNULL(JSON_VALUE(body, '$.payload.source.associate_email'),'') AS ASSOCIATE_EMAIL
,BIRTHDAY = ''
,CONTACTABLE_BY_STORE = ''
,EMAIL_OPT_IN = ''
,AGE_RANGE = ''
,CLIENT_TYPE = ''
,GENDER = ''
,PREF_CONTACT_METHOD = ''
,REVISION = 0
,NOTE = ''

FROM {{ source('newstore', 'event') }}

WHERE JSON_VALUE(body,'$.name') = 'customer.created' --AND JSON_VALUE(body, '$.payload.id') =  'd3a06bed-dc66-4e79-b322-0d6ec23cb58f'

GROUP BY
 JSON_VALUE(body, '$.tenant')
,JSON_VALUE(body, '$.name')
,JSON_VALUE(body, '$.payload.id')
,JSON_VALUE(body, '$.payload.email')
,JSON_VALUE(body, '$.payload.first_name')
,JSON_VALUE(body, '$.payload.last_name')
,JSON_VALUE(body, '$.payload.last_name')
,JSON_VALUE(body, '$.payload.source.location_id')
,JSON_VALUE(body, '$.payload.source.associate_id')
,JSON_VALUE(body, '$.payload.source.associate_name')
,JSON_VALUE(body, '$.payload.source.associate_email')

),

REVISION AS (

SELECT
 ISNULL(JSON_VALUE(body, '$.payload.id'),'') AS CUSTOMER_ID
,MAX(ISNULL(JSON_VALUE(body,'$.payload.revision'),'')) AS REVISION

FROM {{ source('newstore', 'event') }}

WHERE JSON_VALUE(body, '$.name') = 'customer.updated' 

GROUP BY JSON_VALUE(body, '$.payload.id')

),

ATTRIBUTES AS (

SELECT *

FROM (

SELECT
 JSON_VALUE(body, '$.payload.id') AS CUSTOMER_ID
--,REVISION.REVISION AS R_REVISION
,ISNULL(JSON_VALUE(body,'$.payload.revision'),'') AS REVISION
,ATTRIBUTE.[NAME]
,CASE WHEN ATTRIBUTE.[NAME] = 'birthday' THEN CONCAT(JSON_VALUE(ATTRIBUTE.[VALUE], '$.month'), '-', JSON_VALUE(ATTRIBUTE.[VALUE], '$.day')) ELSE ATTRIBUTE.[VALUE] END AS [VALUE]

FROM {{ source('newstore', 'event') }}

LEFT JOIN REVISION ON REVISION.CUSTOMER_ID = JSON_VALUE(body, '$.payload.id')
CROSS APPLY OPENJSON(JSON_QUERY(body,'$.payload.extended_attributes'))

WITH 
(
 [NAME] VARCHAR(50) '$.name'
,[VALUE] NVARCHAR(MAX) '$.value'
) AS ATTRIBUTE

WHERE JSON_VALUE(body, '$.name') = 'customer.updated'  AND REVISION.REVISION = ISNULL(JSON_VALUE(body,'$.payload.revision'),'') --AND JSON_VALUE(body,'$.payload.id') = '83ddacd7-9549-4a26-8d90-675f325f4ec7'

) AS SOURCE_TABLE

PIVOT (
  MAX([VALUE]) FOR [NAME] IN ([birthday],[contactableByStore],[emailOptIn],[ageRange],[clientType],[gender],[preferredContactMethod])
) AS PIVOT_TABLE

),

CORP_UPDATE AS (

SELECT DISTINCT
-- [TYPE] = 'UPDATE'
--,body AS BODY
 ISNULL(JSON_VALUE(body,'$.tenant'),'') AS TENANT
,ISNULL(JSON_VALUE(body,'$.name'),'') AS [NAME]
,MAX(ISNULL(JSON_VALUE(body,'$.published_at'),'')) AS PUBLISHED_DATE
,MAX(ISNULL(JSON_VALUE(body,'$.payload.created_at'),'')) AS CREATION_DATE
,ISNULL(JSON_VALUE(body,'$.payload.id'),'') AS CUSTOMER_ID
,ISNULL(JSON_VALUE(body,'$.payload.email'),'') AS EMAIL
,ISNULL(JSON_VALUE(body,'$.payload.first_name'),'') AS FIRST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.last_name'),'') AS LAST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.phone'),'') AS PHONE
,CASE WHEN JSON_VALUE(body,'$.payload.source.location_id') IS NULL THEN CORP.LOCATION_ID ELSE '' END AS LOCATION_ID
,CASE WHEN JSON_VALUE(body,'$.payload.source.associate_id') IS NULL THEN CORP.ASSOCIATE_ID ELSE '' END AS ASSOCIATE_ID
,CASE WHEN JSON_VALUE(body,'$.payload.source.associate_name') IS NULL THEN CORP.ASSOCIATE_NAME ELSE '' END AS ASSOCIATE_NAME
,CASE WHEN JSON_VALUE(body,'$.payload.source.associate_email') IS NULL THEN CORP.ASSOCIATE_EMAIL ELSE '' END AS ASSOCIATE_EMAIL
,ISNULL(ATTRIBUTES.[birthday],'') AS BIRTHDAY
,CASE 
	WHEN ATTRIBUTES.[contactableByStore] = 'true' THEN 'YES'
	WHEN ATTRIBUTES.[contactableByStore] = 'false' THEN 'NO'
      ELSE ISNULL(ATTRIBUTES.[contactableByStore],'') END AS CONTACTABLE_BY_STORE
,CASE 
	WHEN ATTRIBUTES.[emailOptIn] = 'true' THEN 'YES'
	WHEN ATTRIBUTES.[emailOptIn] = 'false' THEN 'NO'
      ELSE ISNULL(ATTRIBUTES.[emailOptIn],'') END AS EMAIL_OPT_IN
,ISNULL(ATTRIBUTES.[ageRange],'') AS AGE_RANGE
,ISNULL(ATTRIBUTES.[clientType],'') AS CLIENT_TYPE
,ISNULL(ATTRIBUTES.[gender],'') AS GENDER
,ISNULL(ATTRIBUTES.[preferredContactMethod],'') AS PREF_CONTACT_METHOD

,ISNULL(JSON_VALUE(body,'$.payload.revision'),'') AS REVISION

,CASE WHEN CORP.CUSTOMER_ID IS NULL THEN 'CUSTOMER CREATION EVENT MISSING' ELSE '' END AS NOTE

FROM {{ source('newstore', 'event') }}

LEFT JOIN ATTRIBUTES ON ATTRIBUTES.CUSTOMER_ID = JSON_VALUE(body,'$.payload.id')
LEFT JOIN CORP ON CORP.CUSTOMER_ID = JSON_VALUE(body,'$.payload.id')

WHERE
JSON_VALUE(body,'$.name') = 'customer.updated' AND ATTRIBUTES.REVISION = ISNULL(JSON_VALUE(body,'$.payload.revision'),'')
--AND JSON_VALUE(body,'$.payload.id') = '83ddacd7-9549-4a26-8d90-675f325f4ec7'
--AND JSON_VALUE(body, '$.payload.id') = '67bb7ac2-f9da-4860-a94d-ac956c4bd5c6'

GROUP BY
 --body
 JSON_VALUE(body, '$.tenant')
,JSON_VALUE(body, '$.name')
,JSON_VALUE(body, '$.payload.id')
,CORP.CUSTOMER_ID
,JSON_VALUE(body, '$.payload.email')
,JSON_VALUE(body, '$.payload.first_name')
,JSON_VALUE(body, '$.payload.last_name')
,JSON_VALUE(body, '$.payload.phone')
,JSON_VALUE(body, '$.payload.source.location_id')
,JSON_VALUE(body, '$.payload.source.associate_id')
,JSON_VALUE(body, '$.payload.source.associate_name')
,JSON_VALUE(body, '$.payload.source.associate_email')
,CORP.LOCATION_ID
,CORP.ASSOCIATE_ID
,CORP.ASSOCIATE_NAME
,CORP.ASSOCIATE_EMAIL
,ATTRIBUTES.[birthday]
,ATTRIBUTES.[contactableByStore]
,ATTRIBUTES.[emailOptIn]
,ATTRIBUTES.[ageRange]
,ATTRIBUTES.[clientType]
,ATTRIBUTES.[gender]
,ATTRIBUTES.[preferredContactMethod]
,JSON_VALUE(body,'$.payload.revision')

),

UNION_TABLE AS (

SELECT *
FROM CORP

UNION ALL
SELECT *
FROM CORP_UPDATE

),

REVISION_ADJ AS (

SELECT
 CUSTOMER_ID
,TENANT
,MAX(REVISION) AS REVISION

FROM UNION_TABLE

GROUP BY CUSTOMER_ID, TENANT

),

BILLING_ID AS (

SELECT
 MAX(ISNULL(JSON_VALUE(body,'$.payload.created_at'),'')) AS CREATION_DATE
,ISNULL(JSON_VALUE(body, '$.tenant'),'') AS TENANT
,ISNULL(JSON_VALUE(body, '$.payload.customer_id'),'') AS CUSTOMER_ID

FROM {{ source('newstore', 'event') }}

WHERE JSON_VALUE(body,'$.name') = 'customer.address_created' AND JSON_VALUE(body, '$.payload.type') = 'billing'

GROUP BY JSON_VALUE(body, '$.tenant'),JSON_VALUE(body, '$.payload.customer_id')

),

L_BILLING AS (

SELECT DISTINCT
 BILLING_ID.TENANT
,BILLING_ID.CUSTOMER_ID
--,ISNULL(JSON_VALUE(body, '$.name'),'') AS [NAME]
--,ISNULL(LEFT(JSON_VALUE(body,'$.published_at'),10),'') AS PUBLISHED_AT
,LEFT(BILLING_ID.CREATION_DATE,10) AS LATEST_BILLING_DATE
--,ISNULL(JSON_VALUE(body,'$.payload.id'),'') AS ID
--,ISNULL(JSON_VALUE(body,'$.payload.type'),'') AS [TYPE]
,ISNULL(JSON_VALUE(body,'$.payload.first_name'),'') AS LATEST_BILLING_FIRST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.last_name'),'') AS LATEST_BILLING_LAST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.address_line_1'),'') AS LATEST_BILLING_ADDRESS_LINE_1
--,ISNULL(JSON_VALUE(body,'$.payload.address_line1'),'') AS LATEST_BILLING_ADDRESS_LINE_1_BUG
,ISNULL(JSON_VALUE(body,'$.payload.zip_code'),'') AS LATEST_BILLING_ZIP_CODE
,ISNULL(JSON_VALUE(body,'$.payload.city'),'') AS LATEST_BILLING_CITY
,ISNULL(JSON_VALUE(body,'$.payload.state'),'') AS LATEST_BILLING_STATE
,ISNULL(JSON_VALUE(body,'$.payload.country_code'),'') AS LATEST_BILLING_COUNTRY_CODE

FROM {{ source('newstore', 'event') }}

INNER JOIN BILLING_ID
ON BILLING_ID.CREATION_DATE = ISNULL(JSON_VALUE(body,'$.payload.created_at'),'')
AND BILLING_ID.TENANT = JSON_VALUE(body,'$.tenant') 
AND BILLING_ID.CUSTOMER_ID = JSON_VALUE(body,'$.payload.customer_id')

WHERE JSON_VALUE(body,'$.name') = 'customer.address_created' AND JSON_VALUE(body,'$.payload.type') = 'billing'
--AND JSON_VALUE(body,'$.payload.customer_id') = 'acce35e5-28db-4ef4-8dbe-763759a409c8'

),

SHIPPING_ID AS (

SELECT
 MAX(ISNULL(JSON_VALUE(body,'$.payload.created_at'),'')) AS CREATION_DATE
,ISNULL(JSON_VALUE(body,'$.tenant'),'') AS TENANT
,ISNULL(JSON_VALUE(body,'$.payload.customer_id'),'') AS CUSTOMER_ID

FROM {{ source('newstore', 'event') }}

WHERE  JSON_VALUE(body,'$.name') = 'customer.address_created' AND JSON_VALUE(body, '$.payload.type') = 'shipping'

GROUP BY JSON_VALUE(body,'$.tenant'),JSON_VALUE(body,'$.payload.customer_id')

),

L_SHIPPING AS (

SELECT DISTINCT
 SHIPPING_ID.TENANT
,SHIPPING_ID.CUSTOMER_ID
--,ISNULL(JSON_VALUE(body, '$.name'),'') AS [NAME]
--,ISNULL(LEFT(JSON_VALUE(body,'$.published_at'),10),'') AS PUBLISHED_AT
,LEFT(SHIPPING_ID.CREATION_DATE,10) AS LATEST_SHIPPING_DATE
--,ISNULL(JSON_VALUE(body,'$.payload.id'),'') AS ID
--,ISNULL(JSON_VALUE(body,'$.payload.type'),'') AS [TYPE]
,ISNULL(JSON_VALUE(body,'$.payload.first_name'),'') AS LATEST_SHIPPING_FIRST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.last_name'),'') AS LATEST_SHIPPING_LAST_NAME
,ISNULL(JSON_VALUE(body,'$.payload.address_line_1'),'') AS LATEST_SHIPPING_ADDRESS_LINE_1
--,ISNULL(JSON_VALUE(body,'$.payload.address_line1'),'') AS LATEST_SHIPPING_ADDRESS_LINE_1_BUG
,ISNULL(JSON_VALUE(body,'$.payload.zip_code'),'') AS LATEST_SHIPPING_ZIP_CODE
,ISNULL(JSON_VALUE(body,'$.payload.city'),'') AS LATEST_SHIPPING_CITY
,ISNULL(JSON_VALUE(body,'$.payload.state'),'') AS LATEST_SHIPPING_STATE
,ISNULL(JSON_VALUE(body,'$.payload.country_code'),'') AS LATEST_SHIPPING_COUNTRY_CODE

FROM {{ source('newstore', 'event') }}

INNER JOIN SHIPPING_ID
ON SHIPPING_ID.CREATION_DATE = ISNULL(JSON_VALUE(body,'$.payload.created_at'),'')
AND SHIPPING_ID.TENANT = JSON_VALUE(body,'$.tenant') 
AND SHIPPING_ID.CUSTOMER_ID = JSON_VALUE(body,'$.payload.customer_id')

WHERE JSON_VALUE(body,'$.name') = 'customer.address_created' AND JSON_VALUE(body,'$.payload.type') = 'shipping'
--AND JSON_VALUE(body,'$.payload.customer_id') = 'acce35e5-28db-4ef4-8dbe-763759a409c8'

)

SELECT
 REVISION_ADJ.TENANT
,[NAME]
,LEFT(PUBLISHED_DATE,10) AS PUBLISHED_DATE
,CASE WHEN CREATION_DATE = '' THEN LEFT(PUBLISHED_DATE,10) ELSE LEFT(CREATION_DATE,10) END AS CREATION_DATE
,REVISION_ADJ.CUSTOMER_ID
,EMAIL
,FIRST_NAME
,LAST_NAME
,PHONE
,ISNULL(LOCATION_ID,'') AS LOCATION_ID
,ISNULL(ASSOCIATE_ID,'') AS ASSOCIATE_ID
,ISNULL(ASSOCIATE_NAME,'') AS ASSOCIATE_NAME
,ISNULL(ASSOCIATE_EMAIL,'') AS ASSOCIATE_EMAIL
,BIRTHDAY
,CONTACTABLE_BY_STORE
,EMAIL_OPT_IN
,AGE_RANGE
,CLIENT_TYPE
,GENDER
,PREF_CONTACT_METHOD
,REVISION_ADJ.REVISION AS REVISION
,NOTE
,ISNULL(LATEST_BILLING_FIRST_NAME,'') AS LATEST_BILLING_FIRST_NAME
,ISNULL(LATEST_BILLING_LAST_NAME,'') AS LATEST_BILLING_LAST_NAME
,ISNULL(LATEST_BILLING_ADDRESS_LINE_1,'') AS LATEST_BILLING_ADDRESS_LINE_1
,ISNULL(LATEST_BILLING_ZIP_CODE,'') AS LATEST_BILLING_ZIP_CODE
,ISNULL(LATEST_BILLING_CITY,'') AS LATEST_BILLING_CITY
,ISNULL(LATEST_BILLING_STATE,'') AS LATEST_BILLING_STATE
,ISNULL(LATEST_BILLING_COUNTRY_CODE,'') AS LATEST_BILLING_COUNTRY_CODE
,ISNULL(LATEST_SHIPPING_FIRST_NAME,'') AS LATEST_SHIPPING_FIRST_NAME
,ISNULL(LATEST_SHIPPING_LAST_NAME,'') AS LATEST_SHIPPING_LAST_NAME 
,ISNULL(LATEST_SHIPPING_ADDRESS_LINE_1,'') AS LATEST_SHIPPING_ADDRESS_LINE_1
,ISNULL(LATEST_SHIPPING_ZIP_CODE,'') AS LATEST_SHIPPING_ZIP_CODE
,ISNULL(LATEST_SHIPPING_CITY,'') AS LATEST_SHIPPING_CITY
,ISNULL(LATEST_SHIPPING_STATE,'') AS LATEST_SHIPPING_STATE
,ISNULL(LATEST_SHIPPING_COUNTRY_CODE,'') AS LATEST_SHIPPING_COUNTRY_CODE

FROM REVISION_ADJ

LEFT JOIN UNION_TABLE ON UNION_TABLE.CUSTOMER_ID = REVISION_ADJ.CUSTOMER_ID AND UNION_TABLE.REVISION = REVISION_ADJ.REVISION
LEFT JOIN L_BILLING ON L_BILLING.CUSTOMER_ID = REVISION_ADJ.CUSTOMER_ID AND L_BILLING.TENANT = REVISION_ADJ.TENANT
LEFT JOIN L_SHIPPING ON L_SHIPPING.CUSTOMER_ID = REVISION_ADJ.CUSTOMER_ID AND L_SHIPPING.TENANT = REVISION_ADJ.TENANT

--WHERE REVISION_ADJ.CUSTOMER_ID = 'da2c4930-65a1-473a-8a0c-66ab26fd9f8c'

--ORDER BY CREATION_DATE ASC