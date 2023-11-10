{{ config(materialized='table') }}

WITH 

final as (
select 
        customer_id as account_id, 
        date as date_day, 
        id as campaign_id, 
        ad_network_type,
        device,
        clicks, 
        cost_micros / 1000000.0 as spend, 
        impressions,
        conversions,
        conversions_value

    from {{ source('google_ads_sk','campaign_stats') }}

)

select * from final