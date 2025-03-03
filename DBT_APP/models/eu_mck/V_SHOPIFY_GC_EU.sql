{{ config(materialized='view') }}


WITH 
EU_MCK as (
    SELECT 
	   'EU_MCK' as instance
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
    FROM {{ source('eu_mck','gift_card') }}
)

select * from EU_MCK