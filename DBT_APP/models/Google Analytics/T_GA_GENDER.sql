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
,[age_gender].[date]

,[profile]
,[user_age_bracket]
,[user_gender]
,[new_users]
,[sessions]
,[transactions]
,[transactions_per_session]
,[bounce_rate]
,[users]
,[transaction_revenue]
,[revenue_per_transaction]
,[pageviews_per_session]

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics].[age_gender]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = [profile]

--WHERE CONVERT(VARCHAR,[date],23) < '2023-07-01'
WHERE CONVERT(VARCHAR,[age_gender].[date],23) < '2022-06-08'

AND ACC.[ID] IN (
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
,[age_gender].[date]

,[profile]
,[user_age_bracket]
,[user_gender]
,[new_users]
,[sessions]
,[transactions]
,[transactions_per_session]
,[bounce_rate]
,[users]
,[transaction_revenue]
,[revenue_per_transaction]
,[pageviews_per_session]

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics].[age_gender]

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
AND [age_gender].[DATE] BETWEEN '2022-06-08' AND '2023-07-01'

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
,[age_gender].[date]

,RIGHT([age_gender].[property],7) AS [profile]
,[user_age_bracket]
,[user_gender]
,new_users
,[sessions]
,CASE WHEN [purchase_revenue] = 0 THEN 0  ELSE [purchase_revenue] / [average_purchase_revenue] END AS transactions
--,[ecommerce_purchases] AS transactions
,CAST([ecommerce_purchases] AS FLOAT)/CAST([sessions] AS FLOAT) AS transactions_per_session
,[bounce_rate]*100 AS bounce_rate
,[total_users] AS users
,[purchase_revenue] AS transaction_revenue
,[average_purchase_revenue] AS revenue_per_transaction
,CAST([screen_page_views] AS FLOAT)/CAST([sessions] AS FLOAT) AS pageviews_per_session

--,CASE 
--	WHEN ACC.[REGION] = 'US' THEN 'USD'
--    WHEN ACC.[REGION] = 'CA' THEN 'CAD'
--    WHEN ACC.[REGION] = 'UK' THEN 'GBP'
--    WHEN ACC.[REGION] = 'EU' THEN 'EUR'
--    ELSE 'Unknown' 
--	END AS Currency

FROM [SHOPIFY_PROD].[google_analytics_4].[age_gender]

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
AND CONVERT(VARCHAR,[age_gender].[date],23) > '2023-07-01'
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
--,[user_age_bracket]
--,[user_gender]
--,new_users
--,[sessions]
--,transactions
--,transactions_per_session
--,bounce_rate
--,users
--,transaction_revenue
--,revenue_per_transaction
--,pageviews_per_session
----,CASE WHEN [GA_VERSION] = 'GA4' THEN 'CAD' ELSE GA_UNION.currency END AS currency
----,CASE WHEN [GA_VERSION] = 'GA4' THEN 1 ELSE FX_RATE.RATE END AS Rate
----,CASE WHEN [GA_VERSION] = 'GA4' THEN transaction_revenue ELSE FX_RATE.RATE*transaction_revenue END AS transaction_revenue_CAD
----,CASE WHEN [GA_VERSION] = 'GA4' THEN revenue_per_transaction ELSE FX_RATE.RATE*revenue_per_transaction END AS revenue_per_transaction_CAD

--FROM GA_UNION

----LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_CALENDAR_DATA] AS CAL
----ON CAL.[DATE] = GA_UNION.[date]

----LEFT JOIN [sharepoint_fpa].[fx_fx] AS FX_RATE
----ON FX_RATE.[YEAR_FX] = CAL.FISCAL_YEAR 
----AND FX_RATE.[PERIOD] = CAL.FISCAL_PERIOD
----AND FX_RATE.[CURRENCY] COLLATE SQL_Latin1_General_CP1_CI_AS = GA_UNION.[Currency]

--ORDER BY GA_UNION.[date] DESC