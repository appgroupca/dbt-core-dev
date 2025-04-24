{{ config(materialized='table') }}


WITH 
UK_MCK as (
    SELECT 
	   'UK_MCK' as instance
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
    FROM {{ source('uk_mck','gift_card') }}
)

select * from UK_MCK