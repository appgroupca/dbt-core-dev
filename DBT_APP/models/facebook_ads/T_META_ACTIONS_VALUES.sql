{{ config(materialized='table') }}

with

final as (
    
    select 
        ad_id,
        date as date_day,
        value as purchase_value
    from {{source('facebook_ads','basic_ad_action_values')}}
    where [action_type] = 'purchase'

)

select * 
from final