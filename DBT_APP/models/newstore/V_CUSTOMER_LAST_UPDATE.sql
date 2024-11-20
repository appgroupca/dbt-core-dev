
select 
     TENANT
    ,NAME
    ,PUBLISHED_DATE
    ,CUSTOMER_ID
    ,EMAIL
    ,FIRST_NAME
    ,LAST_NAME
    ,PHONE
    ,REVISION
from (
    SELECT
        *
        ,row_number() over (partition by TENANT,CUSTOMER_ID order by REVISION desc)  as RN
    FROM {{ ref('V_CUSTOMER_UPDATED') }}
) t
WHERE RN = 1