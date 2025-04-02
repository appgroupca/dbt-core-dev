{% snapshot T_NS_INV_SNAPSHOT %}

{{
    config(
        target_schema='snapshots',
        unique_key='id',
        strategy='timestamp',
        updated_at='_fivetran_synced'
    )
}}



SELECT * FROM {{ source('newstore_inventory', 'inventory') }}

{% endsnapshot %}