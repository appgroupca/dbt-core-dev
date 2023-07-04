{{ config(materialized='table') }}

with 


final as (
    
    select 
        cast(id as {{ dbt.type_string() }}) as ad_group_id,
        updated_at,
        type as ad_group_type, 
        campaign_id, 
        campaign_name, 
        name as ad_group_name, 
        status as ad_group_status,
        row_number() over (partition by id order by updated_at desc) as is_most_recent_record
    from {{source('google_ads_mck','ad_group_history')}}
)

select * 
from final