{{ config(materialized='view') }}


select 
    column_0 as store_id,
    sum(column_2) as traffic,
    LEFT(column_1,10) as [date]
from
    {{ source('sftp', 'smstraffic') }}
group by column_0,LEFT(column_1,10)

UNION ALL

select
    store_id,
    traffic,
    CONVERT(VARCHAR,[Date],23) as [date]
from 
    {{ source('sftp', 'smstraffic_historical') }}
WHERE
    CONVERT(VARCHAR,[Date],23) < '2023-01-09'

