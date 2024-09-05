{{ config(materialized='table') }}

SELECT
 ACC.[REGION]
,ACC.[BRAND]
,CASE
	WHEN [REGION] = 'CA' THEN 'C31'
	WHEN [REGION] = 'US' THEN 'U31'
	WHEN [REGION] = 'EU' THEN 'N31'
	WHEN [REGION] = 'UK' THEN 'N31'
		END AS BRANCH
,CASE
	WHEN [REGION] = 'CA' THEN 'CAD'
	WHEN [REGION] = 'US' THEN 'USD'
	WHEN [REGION] = 'EU' THEN 'EUR'
	WHEN [REGION] = 'UK' THEN 'GBP'
		END AS CURRENCY 
,[date_breakdown].[date]
,[total_users] AS [Traffic]

FROM [SHOPIFY_PROD].[google_analytics_4].[date_breakdown]

LEFT JOIN [M3RPTDEV].[dbo].[Z_PBI_GA_ACCOUNT_DATA] AS ACC
ON ACC.[ID] = RIGHT([property],9)

LEFT JOIN [SHOPIFY_PROD].[google_analytics_4].[items_purchased]
ON [items_purchased].[property] = [date_breakdown].[property]
AND [items_purchased].[date] = [date_breakdown].[date]