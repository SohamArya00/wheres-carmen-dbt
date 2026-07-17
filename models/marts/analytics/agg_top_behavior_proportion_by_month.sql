-- Q(d): For each calendar month, what proportion of sightings exhibit one
-- of the three behaviors identified in (c)?
--
-- Depends on agg_top_3_behaviors rather than hardcoding the three
-- behaviors, so this view stays correct if the underlying data changes.

with top_behaviors as (
    select behavior from {{ ref('agg_top_3_behaviors') }}
),

monthly as (
    select
        extract(month from date_witness) as sighting_month,
        count(*) as total_sightings,
        sum(case when behavior in (select behavior from top_behaviors) then 1 else 0 end)
            as top_behavior_count
    from {{ ref('fct_sightings') }}
    group by 1
)

select
    sighting_month,
    total_sightings,
    top_behavior_count,
    round(top_behavior_count::float / nullif(total_sightings, 0), 4) as top_behavior_proportion
from monthly
order by sighting_month
