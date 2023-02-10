{{ config(materialized='view') }}


select 
    json_value(body, '$.payload.id') as id
    , json_value(body, '$.payload.email') as Email
    , json_value(body, '$.payload.first_name') as First_Name

from {{ source('newstore', 'event') }}

where json_value(body, '$.name') = 'customer.created'