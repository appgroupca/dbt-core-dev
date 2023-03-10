{{ config(materialized='view') }}

select * from {{ ref("V_TRAFFIC") }}
UNION ALL
select * from {{ ref("V_HIST_TRAFFIC") }}