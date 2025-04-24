{{ config(materialized='table') }}


WITH 
CA_SK as (
    SELECT 
	   'CA_SK' as instance
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
    FROM {{ source('ca_sk','gift_card') }}
)

select * from CA_SK