WITH 

SFCC AS (

SELECT
 ACC.[ID_NAME]
,ACC.[GA_VERSION]
,ACC.[REGION]
,ACC.[BRAND]
,ACC.[SYSTEM]
,[DATE]
,CASE
WHEN [channel_grouping] LIKE '%Klarna%'
OR [channel_grouping] LIKE '%shop.app%'
OR [channel_grouping] LIKE '%shop_app%'
OR [channel_grouping] LIKE '%hooks.stripe.com / referral%' THEN 'Payment Processor'
WHEN [channel_grouping] LIKE 'facebook / cpc%'
OR [channel_grouping] LIKE 'facebook / paid%'
OR [channel_grouping] LIKE 'ig / cpc%'
OR [channel_grouping] LIKE 'fb / cpc%'
OR [channel_grouping] LIKE 'Pinterest / cpc%'
OR [channel_grouping] LIKE 'influencer / %' THEN 'Paid Social'
WHEN [channel_grouping] LIKE 'google / cpc%'
OR [channel_grouping] LIKE 'bing / cpc%'
OR [channel_grouping] LIKE 'google / product_sync%' THEN 'Paid Search'
WHEN [channel_grouping] LIKE 'instagram / social%'
OR [channel_grouping] LIKE 'IGShopping / Social%'
OR [channel_grouping] LIKE 'instagram / Stories_bio%'
OR [channel_grouping] LIKE '%facebook / referral%'
OR [channel_grouping] LIKE '%instagram / referral%'
OR [channel_grouping] LIKE 'facebook.com / referral%'
OR [channel_grouping] LIKE 'instagram.com / referral%'
OR [channel_grouping] LIKE 'l.instagram.com / referral%'
OR [channel_grouping] LIKE 'l.facebook.com / referral%'
OR [channel_grouping] LIKE 'm.facebook.com / referral%'
OR [channel_grouping] LIKE 'instagram.com / referral%'
OR [channel_grouping] LIKE 'lm.facebook.com / referral%'
OR [channel_grouping] LIKE 'pinterest.com / referral%' THEN 'Organic Social'
WHEN [channel_grouping] LIKE 'cj / %'
OR [channel_grouping] LIKE 'brokescholar.com / referral%'
OR [channel_grouping] LIKE 'wethrift.com / referral%' THEN 'Affiliate'
WHEN [channel_grouping] LIKE 'condenast / display%'
OR [channel_grouping] LIKE 'display / condenast%'
OR [channel_grouping] LIKE 'papermag.com / referral%' THEN 'Display'
WHEN [channel_grouping] LIKE 'Klaviyo / email%'
OR [channel_grouping] LIKE 'sfmc / email%'
OR [channel_grouping] LIKE 'Klaviyo / %'
OR [channel_grouping] LIKE 'newsletter / email%'
OR [channel_grouping] LIKE 'Klaviyo / flow|'
OR [channel_grouping] LIKE 'bm23 / email%'
OR [channel_grouping] LIKE 'email / email%'
OR [channel_grouping] LIKE 'email / sfcc%'
OR [channel_grouping] LIKE 'newsletter / email%'
OR [channel_grouping] LIKE 'klaviyo / %'
OR [channel_grouping] LIKE 'klaviyo / redirect%'
OR [channel_grouping] LIKE 'klaviyo / (no set)%'
OR [channel_grouping] LIKE 'klaviyo / campaign%'
OR [channel_grouping] LIKE 'email / klaviyo%' THEN 'Email'
WHEN [channel_grouping] LIKE '%/ referral%' THEN 'Referral'
WHEN [channel_grouping] LIKE 'google / organic%'
OR [channel_grouping] LIKE 'bing / organic%'
OR [channel_grouping] LIKE 'duckduckgo / organic%'
OR [channel_grouping] LIKE 'baidu / organic%'
OR [channel_grouping] LIKE 'naver / organic%'
OR [channel_grouping] LIKE 'ecosia.org / organic%'
OR [channel_grouping] LIKE 'sogou / organic%'
OR [channel_grouping] LIKE 'yandex / organic%'
OR [channel_grouping] LIKE 'qwant.com / organic%'
OR [channel_grouping] LIKE 'yahoo / organic%' THEN 'Organic Search'
WHEN [channel_grouping] LIKE '(direct) / (none)'
OR [channel_grouping] LIKE 'mackage.ca / referral%'
OR [channel_grouping] LIKE 'mackage.eu / referral%'
OR [channel_grouping] LIKE 'mackage.com / referral%'
OR [channel_grouping] LIKE 'mackage.co.uk / referral%'
OR [channel_grouping] LIKE 'appgroup.ca / referral%' THEN 'Direct'
ELSE [channel_grouping] END AS [channel_grouping]
,[channel_grouping] AS [session_source_medium]

,revenue_per_transaction AS revenue
,[new_users]
,[sessions]
,[transactions]
,[bounce_rate]
,[users]

FROM [SHOPIFY_PROD].[google_analytics].[default_channel]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = [profile]

WHERE 
[profile] IN (
'184177819'
,'200205575'
,'200239410'
,'200212235'
,'200218405'
,'200223743'
)
AND [default_channel].[DATE]  < '2022-06-08'

),

GA3 AS (

SELECT
 ACC.[ID_NAME]
,ACC.[GA_VERSION]
,ACC.[REGION]
,ACC.[BRAND]
,ACC.[SYSTEM]
,[DATE]
,CASE
WHEN [channel_grouping] LIKE '%Klarna%'
OR [channel_grouping] LIKE '%shop.app%'
OR [channel_grouping] LIKE '%shop_app%'
OR [channel_grouping] LIKE '%hooks.stripe.com / referral%' THEN 'Payment Processor'
WHEN [channel_grouping] LIKE 'facebook / cpc%'
OR [channel_grouping] LIKE 'facebook / paid%'
OR [channel_grouping] LIKE 'ig / cpc%'
OR [channel_grouping] LIKE 'fb / cpc%'
OR [channel_grouping] LIKE 'Pinterest / cpc%'
OR [channel_grouping] LIKE 'influencer / %' THEN 'Paid Social'
WHEN [channel_grouping] LIKE 'google / cpc%'
OR [channel_grouping] LIKE 'bing / cpc%'
OR [channel_grouping] LIKE 'google / product_sync%' THEN 'Paid Search'
WHEN [channel_grouping] LIKE 'instagram / social%'
OR [channel_grouping] LIKE 'IGShopping / Social%'
OR [channel_grouping] LIKE 'instagram / Stories_bio%'
OR [channel_grouping] LIKE '%facebook / referral%'
OR [channel_grouping] LIKE '%instagram / referral%'
OR [channel_grouping] LIKE 'facebook.com / referral%'
OR [channel_grouping] LIKE 'instagram.com / referral%'
OR [channel_grouping] LIKE 'l.instagram.com / referral%'
OR [channel_grouping] LIKE 'l.facebook.com / referral%'
OR [channel_grouping] LIKE 'm.facebook.com / referral%'
OR [channel_grouping] LIKE 'instagram.com / referral%'
OR [channel_grouping] LIKE 'lm.facebook.com / referral%'
OR [channel_grouping] LIKE 'pinterest.com / referral%' THEN 'Organic Social'
WHEN [channel_grouping] LIKE 'cj / %'
OR [channel_grouping] LIKE 'brokescholar.com / referral%'
OR [channel_grouping] LIKE 'wethrift.com / referral%' THEN 'Affiliate'
WHEN [channel_grouping] LIKE 'condenast / display%'
OR [channel_grouping] LIKE 'display / condenast%'
OR [channel_grouping] LIKE 'papermag.com / referral%' THEN 'Display'
WHEN [channel_grouping] LIKE 'Klaviyo / email%'
OR [channel_grouping] LIKE 'sfmc / email%'
OR [channel_grouping] LIKE 'Klaviyo / %'
OR [channel_grouping] LIKE 'newsletter / email%'
OR [channel_grouping] LIKE 'Klaviyo / flow|'
OR [channel_grouping] LIKE 'bm23 / email%'
OR [channel_grouping] LIKE 'email / email%'
OR [channel_grouping] LIKE 'email / sfcc%'
OR [channel_grouping] LIKE 'newsletter / email%'
OR [channel_grouping] LIKE 'klaviyo / %'
OR [channel_grouping] LIKE 'klaviyo / redirect%'
OR [channel_grouping] LIKE 'klaviyo / (no set)%'
OR [channel_grouping] LIKE 'klaviyo / campaign%'
OR [channel_grouping] LIKE 'email / klaviyo%' THEN 'Email'
WHEN [channel_grouping] LIKE '%/ referral%' THEN 'Referral'
WHEN [channel_grouping] LIKE 'google / organic%'
OR [channel_grouping] LIKE 'bing / organic%'
OR [channel_grouping] LIKE 'duckduckgo / organic%'
OR [channel_grouping] LIKE 'baidu / organic%'
OR [channel_grouping] LIKE 'naver / organic%'
OR [channel_grouping] LIKE 'ecosia.org / organic%'
OR [channel_grouping] LIKE 'sogou / organic%'
OR [channel_grouping] LIKE 'yandex / organic%'
OR [channel_grouping] LIKE 'qwant.com / organic%'
OR [channel_grouping] LIKE 'yahoo / organic%' THEN 'Organic Search'
WHEN [channel_grouping] LIKE '(direct) / (none)'
OR [channel_grouping] LIKE 'mackage.ca / referral%'
OR [channel_grouping] LIKE 'mackage.eu / referral%'
OR [channel_grouping] LIKE 'mackage.com / referral%'
OR [channel_grouping] LIKE 'mackage.co.uk / referral%'
OR [channel_grouping] LIKE 'appgroup.ca / referral%' THEN 'Direct'
ELSE [channel_grouping] END AS [channel_grouping]
,[channel_grouping] AS [session_source_medium]

,revenue_per_transaction AS revenue
,[new_users]
,[sessions]
,[transactions]
,[bounce_rate]
,[users]

FROM [SHOPIFY_PROD].[google_analytics].[default_channel]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = [profile]

WHERE 
[profile] IN 
(
'268823372'
,'268842968'
,'268858621'
,'268827615'
,'268860137'
,'268838830'
)
AND [default_channel].[DATE] BETWEEN '2022-06-08' AND '2023-07-01'

),

GA4 AS (

SELECT
 ACC.[ID_NAME]
,ACC.[GA_VERSION]
,ACC.[REGION]
,ACC.[BRAND]
,ACC.[SYSTEM]
,[default_channel].[date]
,CASE
WHEN [session_source_medium] LIKE '%Klarna%'
OR [session_source_medium] LIKE '%shop.app%'
OR [session_source_medium] LIKE '%shop_app%'
OR [session_source_medium] LIKE '%hooks.stripe.com / referral%' THEN 'Payment Processor'
WHEN [session_source_medium] LIKE 'facebook / cpc%'
OR [session_source_medium] LIKE 'facebook / paid%'
OR [session_source_medium] LIKE 'ig / cpc%'
OR [session_source_medium] LIKE 'fb / cpc%'
OR [session_source_medium] LIKE 'Pinterest / cpc%'
OR [session_source_medium] LIKE 'influencer / %' THEN 'Paid Social'
WHEN [session_source_medium] LIKE 'google / cpc%'
OR [session_source_medium] LIKE 'bing / cpc%'
OR [session_source_medium] LIKE 'google / product_sync%' THEN 'Paid Search'
WHEN [session_source_medium] LIKE 'instagram / social%'
OR [session_source_medium] LIKE 'IGShopping / Social%'
OR [session_source_medium] LIKE 'instagram / Stories_bio%'
OR [session_source_medium] LIKE '%facebook / referral%'
OR [session_source_medium] LIKE '%instagram / referral%'
OR [session_source_medium] LIKE 'facebook.com / referral%'
OR [session_source_medium] LIKE 'instagram.com / referral%'
OR [session_source_medium] LIKE 'l.instagram.com / referral%'
OR [session_source_medium] LIKE 'l.facebook.com / referral%'
OR [session_source_medium] LIKE 'm.facebook.com / referral%'
OR [session_source_medium] LIKE 'instagram.com / referral%'
OR [session_source_medium] LIKE 'lm.facebook.com / referral%'
OR [session_source_medium] LIKE 'pinterest.com / referral%' THEN 'Organic Social'
WHEN [session_source_medium] LIKE 'cj / %'
OR [session_source_medium] LIKE 'brokescholar.com / referral%'
OR [session_source_medium] LIKE 'wethrift.com / referral%' THEN 'Affiliate'
WHEN [session_source_medium] LIKE 'condenast / display%'
OR [session_source_medium] LIKE 'display / condenast%'
OR [session_source_medium] LIKE 'papermag.com / referral%' THEN 'Display'
WHEN [session_source_medium] LIKE 'Klaviyo / email%'
OR [session_source_medium] LIKE 'sfmc / email%'
OR [session_source_medium] LIKE 'Klaviyo / %'
OR [session_source_medium] LIKE 'newsletter / email%'
OR [session_source_medium] LIKE 'Klaviyo / flow|'
OR [session_source_medium] LIKE 'bm23 / email%'
OR [session_source_medium] LIKE 'email / email%'
OR [session_source_medium] LIKE 'email / sfcc%'
OR [session_source_medium] LIKE 'newsletter / email%'
OR [session_source_medium] LIKE 'klaviyo / %'
OR [session_source_medium] LIKE 'klaviyo / redirect%'
OR [session_source_medium] LIKE 'klaviyo / (no set)%'
OR [session_source_medium] LIKE 'klaviyo / campaign%'
OR [session_source_medium] LIKE 'email / klaviyo%' THEN 'Email'
WHEN [session_source_medium] LIKE '%/ referral%' THEN 'Referral'
WHEN [session_source_medium] LIKE 'google / organic%'
OR [session_source_medium] LIKE 'bing / organic%'
OR [session_source_medium] LIKE 'duckduckgo / organic%'
OR [session_source_medium] LIKE 'baidu / organic%'
OR [session_source_medium] LIKE 'naver / organic%'
OR [session_source_medium] LIKE 'ecosia.org / organic%'
OR [session_source_medium] LIKE 'sogou / organic%'
OR [session_source_medium] LIKE 'yandex / organic%'
OR [session_source_medium] LIKE 'qwant.com / organic%'
OR [session_source_medium] LIKE 'yahoo / organic%' THEN 'Organic Search'
WHEN [session_source_medium] LIKE '(direct) / (none)'
OR [session_source_medium] LIKE 'mackage.ca / referral%'
OR [session_source_medium] LIKE 'mackage.eu / referral%'
OR [session_source_medium] LIKE 'mackage.com / referral%'
OR [session_source_medium] LIKE 'mackage.co.uk / referral%'
OR [session_source_medium] LIKE 'appgroup.ca / referral%' THEN 'Direct'
ELSE [session_source_medium] END AS [channel_grouping]
,[session_source_medium]

,[purchase_revenue] AS revenue
,[new_users]
,[sessions]
,[transactions]
,[bounce_rate]*100 AS [bounce_rate]
,[total_users] AS users

FROM [SHOPIFY_PROD].[google_analytics_4].[default_channel]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = RIGHT([property],9)

WHERE ACC.[ID] IN (
'349706409'
,'342030789'
--,'653193169'
,'353193169'
,'350198448'
,'356619695'
,'355085855'
)
AND CONVERT(VARCHAR,[default_channel].[date],23) > '2023-07-01'

)
--,


--GA_UNION AS (

SELECT *
FROM SFCC

UNION ALL
SELECT *
FROM GA3
 
UNION ALL
SELECT *
FROM GA4

--)

--SELECT
--    [ID_NAME],
--    [GA_VERSION],
--    [REGION],
--    [BRAND],
--    [SYSTEM],
--    [DATE],
--    [channel_grouping],
--    [revenue],
--    [new_users],
--    [sessions],
--    [transactions],
--    [bounce_rate],
--    [users]
-- FROM GA_UNION