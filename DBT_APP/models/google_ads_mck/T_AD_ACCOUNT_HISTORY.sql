{{ config(materialized='table') }}

with 

final as (

select 
        id as account_id,
        updated_at,
        currency_code,
        auto_tagging_enabled,
        time_zone,
        descriptive_name as account_name,
        row_number() over (partition by id order by updated_at desc) as is_most_recent_record
    from {{source('google_ads_mck','account_history')}}

	)

select * from final