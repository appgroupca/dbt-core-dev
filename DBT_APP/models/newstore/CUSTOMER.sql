SELECT 
    coalesce(c_upd.TENANT,c_cre.TENANT) as TENANT
    ,coalesce(c_upd.NAME,c_cre.NAME) as NAME
    ,coalesce(c_upd.PUBLISHED_DATE,c_cre.PUBLISHED_DATE) as PUBLISHED_DATE
    ,c_cre.CREATION_DATE
    ,coalesce(c_upd.CUSTOMER_ID,c_cre.CUSTOMER_ID) as CUSTOMER_ID
    ,coalesce(c_upd.EMAIL,c_cre.EMAIL) as EMAIL
    ,coalesce(c_upd.FIRST_NAME,c_cre.FIRST_NAME) as FIRST_NAME
    ,coalesce(c_upd.LAST_NAME,c_cre.LAST_NAME) as LAST_NAME
    ,coalesce(c_upd.PHONE,c_cre.PHONE) as PHONE
    ,c_cre.LOCATION_ID
    ,c_cre.ASSOCIATE_ID
    ,c_cre.ASSOCIATE_NAME
    ,c_cre.ASSOCIATE_EMAIL

from {{ ref('V_CUSTOMER_CREATED') }} as c_cre

FULL OUTER JOIN  {{ ref('V_CUSTOMER_LAST_UPDATE') }} as c_upd
    on c_cre.TENANT = c_upd.TENANT
    and c_cre.CUSTOMER_ID = c_upd.CUSTOMER_ID

--where coalesce(c_cre.CUSTOMER_ID,c_upd.CUSTOMER_ID)='0308c4bf-40fc-4820-84d5-e3d2a85ab183'
