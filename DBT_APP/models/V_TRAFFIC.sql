{{ config(materialized='view') }}


select 
    column_0 as store_id,
    sum(column_2) as traffic,
    CAST(column_1 AS DATE) date
from
    {{ source('sftp', 'smstraffic') }}
group by 1

UNION 

select
    store_id,
    traffic,
    date
from
    {{ source('sftp', 'smstraffic_historical') }}    
