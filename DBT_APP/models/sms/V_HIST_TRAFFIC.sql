select
    store_id,
    traffic,
    CONVERT(VARCHAR,[Date],23) as [date]
from 
    {{ source('sftp', 'smstraffic_historical') }}
WHERE
    CONVERT(VARCHAR,[Date],23) < '2023-01-09'