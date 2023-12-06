{{ config(materialized='table') }}

with

final as (
    
    select 
        ad_id,
        date as date_day,
        value as purchase_value
    from {{source('facebook_ads','actions_action_values')}}
    where [index]='11'

)

select * 
from final