{{ config(materialized='view') }}


select 
    column_0 as store_id,
    sum(column_2) as traffic,
    LEFT(column_1,10) as [date]
from
    {{ source('sms', 'traffic') }}
group by column_0,LEFT(column_1,10)

