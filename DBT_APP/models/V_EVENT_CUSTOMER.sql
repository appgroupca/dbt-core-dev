{{ config(materialized='view') }}


select 
      json_value(body, '$.payload.id') as id
    , json_value(body, '$.payload.email') as Email
    , json_value(body, '$.payload.first_name') as First_Name
    , json_value(body, '$.payload.last_name') as Last_Name
    , json_value(body, '$.payload.phone') as Phone
    , json_value(body, '$.payload.source.location_id') as store_creation_name
    , json_value(body, '$.payload.source.associate_name') as store_creation_associate_name
    , json_value(body, '$.payload.source.associate_email') as store_creation_associate_email
    , json_value(body, '$.payload.created_at') as created_at
    , json_value(body, '$.published_at') as event_published_at


from {{ source('newstore', 'event') }}

where json_value(body, '$.name') = 'customer.created'