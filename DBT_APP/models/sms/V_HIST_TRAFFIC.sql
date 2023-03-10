select
    store_id,
    traffic,
    CONVERT(VARCHAR,[Date],23) as [date]
from 
    {{ source('sms', 'storetraffic_historical') }}
WHERE
    CONVERT(VARCHAR,[Date],23) < '2023-01-09'