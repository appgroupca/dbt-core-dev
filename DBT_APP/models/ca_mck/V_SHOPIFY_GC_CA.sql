{{ config(materialized='view') }}


WITH 
CA_MCK as (
    SELECT 
	   'CA_MCK' as instance
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
    FROM {{ source('ca_mck','gift_card') }}
)

select * from CA_MCK