{{ config(materialized='view') }}


WITH 
US_SK as (
    SELECT 
	   'US_SK' as instance
	    ,[id]
      ,[customer_id]
      ,[user_id]
      ,[balance]
      ,[code]
      ,[created_at]
      ,[currency]
      ,[disabled_at]
      ,[expires_on]
      ,[initial_value]
      ,[last_characters]
      ,[note]
      ,[updated_at]
    FROM {{ source('us_sk','gift_card') }}
)

select * from US_SK