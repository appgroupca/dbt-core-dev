with report as (

    select *
    from {{ ref('T_META_BASIC_AD') }}

), 

accounts as (

    select *
    from {{ ref('T_META_ACCOUNT_HISTORY') }}
    where is_most_recent_record = 1

),

campaigns as (

    select *
    from {{ ref('T_META_CAMPAIGN_HISTORY') }}
    where is_most_recent_record = 1

),

ad_sets as (

    select *
    from {{ ref('T_META_AD_SET_HISTORY') }}
    where is_most_recent_record = 1

),

ads as (

    select *
    from {{ ref('T_META_AD_HISTORY') }}
    where is_most_recent_record = 1

),

actions as (

    select *
    from {{ ref('T_META_ACTIONS') }}

),

joined as (

    select 
        report.date_day,
        accounts.account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_sets.ad_set_id,
        ad_sets.ad_set_name,
        ads.ad_id,
        ads.ad_name,
        sum(report.clicks) as clicks,
        ISNULL(sum(report.impressions),0) as impressions,
        sum(report.spend) as spend,
        ISNULL(actions.purchase_value,0) as purchase_value,
        ISNULL(round(actions.purchase_value/NULLIF(sum(report.spend),0),2),0) as roas


    from report 
    left join accounts
        on report.account_id = accounts.account_id
    left join ads 
        on report.ad_id = ads.ad_id
    left join campaigns
        on ads.campaign_id = campaigns.campaign_id
    left join ad_sets
        on ads.ad_set_id = ad_sets.ad_set_id
    left join actions
        on ads.ad_id = actions.ad_id and report.date_day = actions.date_day
    GROUP BY report.date_day,
        accounts.account_id,
        accounts.account_name,
        campaigns.campaign_id,
        campaigns.campaign_name,
        ad_sets.ad_set_id,
        ad_sets.ad_set_name,
        ads.ad_id,
        ads.ad_name,
        actions.purchase_value
)

select *
from joined