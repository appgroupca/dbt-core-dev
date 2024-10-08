{{ config(materialized='table') }}

with

final as (
    
    select 
        updated_time as updated_at,
        created_time as created_at,
        cast(account_id as {{ dbt.type_bigint() }}) as account_id,
        cast(id as {{ dbt.type_bigint() }}) as campaign_id,
        name as campaign_name,
        start_time as start_at,
        stop_time as end_at,
        status,
        daily_budget,
        lifetime_budget,
        budget_remaining,
        row_number() over (partition by id order by updated_time desc) as is_most_recent_record
    from {{source('facebook_ads','campaign_history')}}

)

select * 
from final