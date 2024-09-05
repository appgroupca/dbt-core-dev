WITH 

SFCC AS (

SELECT
 ACC.[RANK]
,ACC.[ID]
,ACC.[ID_NAME]
,ACC.[GA_VERSION]
,ACC.[REGION]
,ACC.[BRAND]
,ACC.[SYSTEM]

,[date]
,[profile]

,[device_category]
--,[new_users]
,[sessions]
,[transaction_revenue]

--,[pageviews_per_session]
--,[transactions]
--,[bounce_rate]
--,[users]
--,[revenue_per_transaction]
--,[transactions_per_session]

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics].[device_breakdown]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = [profile]

WHERE CONVERT(VARCHAR,[device_breakdown].[date],23) < '2022-06-08'

AND [profile] IN (
'184177819'
,'200205575'
,'200239410'
,'200212235'
,'200218405'
,'200223743'
)

),

GA3 AS (

SELECT
 ACC.[RANK]
,ACC.[ID]
,ACC.[ID_NAME]
,ACC.[GA_VERSION]
,ACC.[REGION]
,ACC.[BRAND]
,ACC.[SYSTEM]

,[date]
,[profile]

,[device_category]
--,[new_users]
,[sessions]
,[transaction_revenue]

--,[pageviews_per_session]
--,[transactions]
--,[bounce_rate]
--,[users]
--,[revenue_per_transaction]
--,[transactions_per_session]

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics].[device_breakdown]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = [profile]

WHERE 
[profile] IN (
'268823372'
,'268842968'
,'268858621'
,'268827615'
,'268860137'
,'268838830'
)
AND [device_breakdown].[DATE] BETWEEN '2022-06-08' AND '2023-07-01'

--ORDER BY [DATE]

),

GA4 AS (

SELECT
 ACC.[RANK]
,ACC.[ID]
,ACC.[ID_NAME]
,ACC.[GA_VERSION]
,ACC.[REGION]
,ACC.[BRAND]
,ACC.[SYSTEM]

,[device_breakdown].[date]
,RIGHT([device_breakdown].[property],7) AS [profile]

,[device_category]
--,[active_users] AS new_users
,[sessions]
,purchase_revenue AS transaction_revenue
--,[pageviews_per_session]
--,[ecommerce_purchases] AS transactions
--,[bounce_rate]*100 AS bounce_rate
--,[total_users] AS users
--,[average_purchase_revenue] AS revenue_per_transaction
--,[transactions_per_session]

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics_4].[device_breakdown]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = RIGHT([property],9)

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
AND CONVERT(VARCHAR,[device_breakdown].[date],23) > '2023-07-01'
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
-- [RANK]
--,[ID]
--,[ID_NAME]
--,[GA_VERSION]
--,[REGION]
--,[BRAND]
--,[SYSTEM]
--,GA_UNION.[date]
--,[profile]
--,[device_category]
--,[sessions]
--,transaction_revenue
----,CASE WHEN [GA_VERSION] = 'GA4' THEN 'CAD' ELSE GA_UNION.currency END AS currency
----,CASE WHEN [GA_VERSION] = 'GA4' THEN 1 ELSE FX_RATE.RATE END AS Rate
----,CASE WHEN [GA_VERSION] = 'GA4' THEN transaction_revenue ELSE FX_RATE.RATE*transaction_revenue END AS transaction_revenue_CAD

--FROM GA_UNION

----LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_CALENDAR_DATA] AS CAL
----ON CAL.[DATE] = GA_UNION.[date]

----LEFT JOIN [sharepoint_fpa].[fx_fx] AS FX_RATE
----ON FX_RATE.[YEAR_FX] = CAL.FISCAL_YEAR 
----AND FX_RATE.[PERIOD] = CAL.FISCAL_PERIOD
----AND FX_RATE.[CURRENCY] COLLATE SQL_Latin1_General_CP1_CI_AS = GA_UNION.[Currency]

--ORDER BY GA_UNION.[date] DESC