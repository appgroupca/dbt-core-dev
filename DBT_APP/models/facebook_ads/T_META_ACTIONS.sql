{{ config(materialized='table') }}

with

final as (
    
    select 
        ad_id,
        date as date_day,
        value as transactions
    from {{source('facebook_ads','basic_ad_actions')}}
    where [action_type] = 'purchase'

)

select * 
from final