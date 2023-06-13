{{ config(materialized='incremental',
            unique_key=['store_id','dat']) }}


select 
    column_0 as store_id,
    sum(column_2) as traffic,
    LEFT(column_1,10) as dat,
    MAX(_fivetran_synced) as _fivetran_synced
from
    {{ source('sms', 'traffic') }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where _fivetran_synced > (select max(_fivetran_synced) from {{ this }})

{% endif %}
group by column_0,LEFT(column_1,10)

