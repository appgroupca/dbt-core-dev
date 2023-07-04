with 

stat as (

    --select *
    --from {{ source('google_ads_mck','ad_stats') }}

    select *
    from {{ ref('T_AD_STATS')}}
), 

accounts as (

    select *
    from {{ ref('T_AD_ACCOUNT_HISTORY')}}
    where is_most_recent_record = 1
), 

campaigns as (

    select *
    from {{ ref('T_AD_CAMPAIGNS')}}
    where is_most_recent_record = 1
), 

ad_groups as (

    select *
    from {{ ref('T_AD_GROUP_HISTORY')}}
    where is_most_recent_record = 1

),

ads as (

    --select *
    --from {{ source('google_ads_mck','ad_history') }}

    select *
    from {{ ref('T_AD_HISTORY')}}
    where is_most_recent_record = 1
), 

fields as (

 select
        stat.date_day,
        accounts.account_name,
        accounts.account_id,
        accounts.currency_code,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        stat.ad_id,
        ads.ad_name,
        ads.ad_status,
        ads.ad_type,
        ads.display_url,
        ads.source_final_urls,
        sum(stat.spend) as spend,
        sum(stat.clicks) as clicks,
        sum(stat.impressions) as impressions

    from stat
    left join ads
        on stat.ad_id = ads.ad_id
        and stat.ad_group_id = ads.ad_group_id
    left join ad_groups
        on ads.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
    left join accounts
        on campaigns.account_id = accounts.account_id
    group by stat.date_day,
        accounts.account_name,
        accounts.account_id,
        accounts.currency_code,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        stat.ad_id,
        ads.ad_name,
        ads.ad_status,
        ads.ad_type,
        ads.display_url,
        ads.source_final_urls
)

select *
from fields
