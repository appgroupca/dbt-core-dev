{{ config(materialized='table') }}

with

final as (
    
    select 
        *
    from {{source('loop_ca','return_list')}}

)

select * 
from final