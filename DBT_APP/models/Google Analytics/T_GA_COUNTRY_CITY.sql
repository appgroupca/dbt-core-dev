WITH SFCC AS (

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
,[country]
,[city]
,[new_users]
,[sessions]
,[transaction_revenue]
,[transactions]
,[users]
,bounce_rate

FROM [SHOPIFY_PROD].[google_analytics].[country_city_breakdown]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = [profile]

WHERE CONVERT(VARCHAR,[country_city_breakdown].[date],23) < '2022-06-08'

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
,[date]
,[profile]
,[country]
,[city]
,[new_users]
,[sessions]
,[transaction_revenue]
,[transactions]
,[users]
,bounce_rate

FROM [SHOPIFY_PROD].[google_analytics].[country_city_breakdown]

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
AND [country_city_breakdown].[DATE] BETWEEN '2022-06-08' AND '2023-07-01'

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
,[country_city_breakdown].[date]
,RIGHT([country_city_breakdown].[property],7) AS [profile]
,[country]
,[city]
,new_users
,[sessions]
,purchase_revenue AS transaction_revenue
,[ecommerce_purchases] AS transactions
,[total_users] AS users
,bounce_rate*100 AS bounce_rate


FROM [SHOPIFY_PROD].[google_analytics_4].[country_city_breakdown]

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
AND CONVERT(VARCHAR,[country_city_breakdown].[DATE] ,23) > '2023-07-01'
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
--,[country]
--,[city]
--,new_users
--,[sessions]
--,transaction_revenue
--,transactions
--,[users]
--,bounce_rate

--FROM GA_UNION