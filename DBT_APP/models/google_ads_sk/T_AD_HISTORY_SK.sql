{{ config(materialized='table') }}

with 

final as (
    
    select 
        ad_group_id, 
        id as ad_id,
        name as ad_name,
        updated_at,
        type as ad_type,
        status as ad_status,
        display_url,
        final_urls as source_final_urls,
        replace(replace(final_urls, '[', ''),']','') as final_urls,
        row_number() over (partition by id, ad_group_id order by updated_at desc) as is_most_recent_record
    from {{ source('google_ads_sk','ad_history') }}
)



select * 
from final