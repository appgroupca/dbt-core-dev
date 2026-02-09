{{ config(materialized='view') }}

with vt as (
    select
        -- Normalize collation once for stable comparisons
        cast(store_id  as varchar(50)) collate SQL_Latin1_General_CP1_CI_AS as store_id,
        cast(camera_id as varchar(64)) collate SQL_Latin1_General_CP1_CI_AS as camera_id,
        short_date,
        trend_out
    from {{ source('verkada_traffic', 'verkada_traffic') }}
),

gl as (
    select
        cast(store_id  as varchar(50)) collate SQL_Latin1_General_CP1_CI_AS as store_id,
        cast(camera_id as varchar(64)) collate SQL_Latin1_General_CP1_CI_AS as camera_id,
        cast(go_live_date as date) as go_live_date
    from {{ ref('verkada_store_integration') }}
),

branch_map as (
    select
        cast(OLD_BRANCH as varchar(50))  collate SQL_Latin1_General_CP1_CI_AS as old_branch,
        cast(BRANCH     as varchar(100)) collate SQL_Latin1_General_CP1_CI_AS as branch
    from {{ source('m3', 'Z_PBI_BRANCH_OLD_BRANCH') }}
),

-- Keep only rows for cameras explicitly configured in the seed
filtered as (
    select
        vt.short_date,
        vt.store_id,
        vt.camera_id,
        gl.go_live_date,
        vt.trend_out
    from vt
    inner join gl
      on gl.store_id  = vt.store_id
     and gl.camera_id = vt.camera_id
),


rolled as (
    select
        f.short_date as [DATE],
        coalesce(b.branch, f.store_id) as BRANCH,
        round(sum(f.trend_out) * 0.80, 0) as TRAFFIC
    from filtered f
    left join branch_map b
      on b.old_branch = f.store_id    -- now both sides share the same collation
    where f.go_live_date is not null 
    and f.short_date >= f.go_live_date
    group by short_date,branch,f.store_id
)

select * from rolled