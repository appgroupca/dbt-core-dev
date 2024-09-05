WITH

SFCC AS (

SELECT
 CONCAT([GA_VERSION],'-',[BRAND],'-',[REGION],'-',[SYSTEM]) AS ID_NAME
 ,GA_VERSION
,[REGION]
,[BRAND]
,[SYSTEM]
,[DATE] AS [date]

,new_users
,[sessions]
,[bounce_rate]*[sessions]/100 AS Bounces
,[transactions]

,[bounce_rate]
,users
,[users]-[new_users] AS returning_users
--,currency = ''
,transaction_revenue
,revenue_per_transaction

,pageviews_per_session*[sessions] AS pageviews

,pageviews_per_session

,CASE WHEN transaction_revenue = 0 THEN 0 ELSE CAST([sessions] AS FLOAT) / transaction_revenue END AS revenue_per_session

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics].[user_breakdown]

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
AND [user_breakdown].[DATE]  < '2022-06-08'

--ORDER BY [DATE]

),

GA3 AS (

SELECT
 CONCAT([GA_VERSION],'-',[BRAND],'-',[REGION],'-',[SYSTEM]) AS ID_NAME
 ,GA_VERSION
,[REGION]
,[BRAND]
,[SYSTEM]
,[DATE] AS [date]

,new_users
,[sessions]
,[bounce_rate]*[sessions]/100 AS Bounces
,[transactions]

,[bounce_rate]
,users
,[users]-[new_users] AS returning_users
--,currency = ''
,transaction_revenue
,revenue_per_transaction

,pageviews_per_session*[sessions] AS pageviews

,pageviews_per_session

,CASE WHEN transaction_revenue = 0 THEN 0 ELSE CAST([sessions] AS FLOAT) / transaction_revenue END AS revenue_per_session

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics].[user_breakdown]

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
AND [user_breakdown].[DATE] BETWEEN '2022-06-08' AND '2023-07-01'

--ORDER BY [DATE]

),

GA4 AS (

SELECT
 ACC.[ID_NAME]
,ACC.[GA_VERSION]
,ACC.[REGION]
,ACC.[BRAND]
,ACC.[SYSTEM]
,[date_breakdown].[date]

,new_users
,[sessions]
,[sessions]-engaged_sessions AS Bounces
,[transactions]
--,CASE WHEN [purchase_revenue] = 0 THEN 0  ELSE [purchase_revenue] / [average_purchase_revenue] END AS transactions
--[ecommerce_purchases] AS transactions
--,engaged_sessions
,[bounce_rate]*100 AS bounce_rate
,[total_users] AS users
,[total_users]-[new_users] AS returning_users
--,currency = ''
,purchase_revenue AS transaction_revenue
,[average_purchase_revenue] AS revenue_per_transaction

,[screen_page_views] AS pageviews
--,ecommerce_purchases AS items_purchased

,CAST([screen_page_views] AS FLOAT)/CAST([sessions] AS FLOAT) AS pageviews_per_session

,CASE WHEN [ecommerce_purchases] = 0 THEN 0 ELSE CAST([sessions] AS FLOAT) / [ecommerce_purchases] END AS revenue_per_session
--,[bounce_rate]*100 AS bounce_rate

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency


FROM [SHOPIFY_PROD].[google_analytics_4].[date_breakdown]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = RIGHT([property],9)

LEFT JOIN [SHOPIFY_PROD].[google_analytics_4].[items_purchased]
ON [items_purchased].[property] = [date_breakdown].[property]
AND [items_purchased].[date] = [date_breakdown].[date]

WHERE 
ACC.[ID] IN (
'349706409'
,'342030789'
--,'653193169'
,'353193169'
,'350198448'
,'356619695'
,'355085855'
)
AND CONVERT(VARCHAR,[date_breakdown].[date],23) > '2023-07-01'
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
