{{ config(materialized='view') }}


select 
    column_0 as store_id,
    sum(column_2) as traffic,
    MAX(LEFT(column_1,10)) as [date]
from
    {{ source('sftp', 'smstraffic') }}
group by column_0,column_1

