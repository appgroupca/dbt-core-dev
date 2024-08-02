WITH

REVISION AS (

SELECT
 ISNULL(JSON_VALUE(body, '$.payload.id'),'') AS CUSTOMER_ID
,MAX(ISNULL(JSON_VALUE(body,'$.payload.revision'),'')) AS REVISION

FROM {{ source('newstore', 'event') }}

WHERE JSON_VALUE(body, '$.name') = 'customer.updated' 

GROUP BY JSON_VALUE(body, '$.payload.id')

)

SELECT *

FROM (

SELECT
 JSON_VALUE(body, '$.payload.id') AS CUSTOMER_ID
,ISNULL(JSON_VALUE(body,'$.payload.revision'),'') AS REVISION
,ATTRIBUTE.[NAME]
,CASE 
	WHEN ATTRIBUTE.[NAME] = 'birthday' THEN CONCAT(JSON_VALUE(ATTRIBUTE.[VALUE], '$.month'), '-', JSON_VALUE(ATTRIBUTE.[VALUE], '$.day'))
		ELSE ATTRIBUTE.[VALUE] 
			END AS [VALUE]

FROM {{ source('newstore', 'event') }}

LEFT JOIN REVISION ON REVISION.CUSTOMER_ID = JSON_VALUE(body, '$.payload.id')
CROSS APPLY OPENJSON(JSON_QUERY(body,'$.payload.extended_attributes'))

WITH 
(
 [NAME] VARCHAR(50) '$.name'
,[VALUE] NVARCHAR(MAX) '$.value'
) AS ATTRIBUTE

WHERE 
JSON_VALUE(body, '$.name') = 'customer.updated'  
AND REVISION.REVISION = ISNULL(JSON_VALUE(body,'$.payload.revision'),'')

) AS SOURCE_TABLE

PIVOT (
  MAX([VALUE]) FOR [NAME] IN ([birthdayMonth],[gdpr_accepted],[clientType],[gender],[language])
) AS PIVOT_TABLE