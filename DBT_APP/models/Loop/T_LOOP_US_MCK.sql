{{ config(materialized='table') }}

with 

final as (

SELECT
 Region = 'US'
,Brand = 'MCK'
,rl.[id] as 'Loop RMA ID'
,[destination_id] as 'Loop Return Warehouse ID'
,[package_reference] as 'Return Tracking #'
,[provider_order_id] as 'Shopify Order UUID'
,[label_updated_at]
,[state] as 'Return Status'
,[status_page_url]
,[order_id]
,[return_total] as 'Return Total'
,[discount_total]
,[tax_total]
,[gift_card]
,[order_number]
,[order_name] as 'Shopify Order ID'
,[total] as 'Order Total'
,[currency]
,[product_total] as 'Product Gross Price'
,[label_status]
,[carrier]
,[customer]
,[label_rate]
,[label_url]
,rli.parent_return_reason as 'Parent Return Reason'
,rli.return_reason as 'Return Reason'
,rli.sku as 'SKU'
,rli.variant_id as 'Product Variant'
,rli.title as 'Product Name'
,CAST(rli.barcode AS nvarchar) as 'Product Barcode'
,rl.created_at as 'Date Created'
	  
FROM [SHOPIFY_PROD].[loop_us].[return_list] as rl

LEFT JOIN [SHOPIFY_PROD].[loop_us].[return_list_line_item] as rli 
on rl.id = rli.return_list_id

)

select * from final