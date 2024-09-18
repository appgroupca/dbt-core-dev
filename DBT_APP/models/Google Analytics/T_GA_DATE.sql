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
,[bounce_rate]*100 AS bounce_rate
,[total_users] AS users
,[total_users]-[new_users] AS returning_users
,purchase_revenue AS transaction_revenue
,[average_purchase_revenue] AS revenue_per_transaction
,[screen_page_views] AS pageviews

,CAST([screen_page_views] AS FLOAT)/CAST([sessions] AS FLOAT) AS pageviews_per_session

,CASE WHEN [ecommerce_purchases] = 0 THEN 0 ELSE CAST([sessions] AS FLOAT) / [ecommerce_purchases] END AS revenue_per_session


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
,'353193169'
,'350198448'
,'356619695'
,'355085855'
)
AND CONVERT(VARCHAR,[date_breakdown].[date],23) > '2023-07-01'
