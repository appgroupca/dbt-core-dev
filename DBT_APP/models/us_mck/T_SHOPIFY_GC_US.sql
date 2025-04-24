{{ config(materialized='table') }}


WITH 
US_MCK as (
    SELECT 
	   'US_MCK' as instance
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
    FROM {{ source('us_mck','gift_card') }}
)

select * from US_MCK