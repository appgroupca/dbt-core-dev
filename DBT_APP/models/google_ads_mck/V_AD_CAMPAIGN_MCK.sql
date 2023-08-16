with 

stat as (

	select * from {{ ref('T_AD_CAMPAIGN_STATS')}}
), 

accounts as (

 select * from {{ ref('T_AD_ACCOUNT_HISTORY')}}
 where is_most_recent_record=1

), 

campaigns as (

   select * from {{ ref('T_AD_CAMPAIGNS')}}
	where is_most_recent_record=1
), 

fields as (

    select
        stat.date_day,
        accounts.account_name,
        accounts.account_id,
        accounts.currency_code,
        campaigns.campaign_name,
        campaigns.campaign_id,
        campaigns.advertising_channel_type,
        campaigns.advertising_channel_subtype,
        campaigns.status,
        sum(stat.spend) as spend,
        sum(stat.clicks) as clicks,
        sum(stat.impressions) as impressions

    from stat
    left join campaigns
        on stat.campaign_id = campaigns.campaign_id
    left join accounts
        on campaigns.account_id = accounts.account_id
    group by stat.date_day,
        accounts.account_name,
        accounts.account_id,
        accounts.currency_code,
        campaigns.campaign_name,
        campaigns.campaign_id,
        campaigns.advertising_channel_type,
        campaigns.advertising_channel_subtype,
        campaigns.status
)

select *
from fields