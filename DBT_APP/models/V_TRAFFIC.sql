{{ config(materialized='view') }}


select 
    column_0 as store_id,
    column_1 as timestamp,
    column_2 as traffic,
    CAST(column_1 AS DATE) date,
    CAST(column_1 AS TIME(0)) time
from
    {{ source('sftp', 'traffic') }}