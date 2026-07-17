-- Q(a): For each calendar month, which agency region has the most sightings?

with monthly_region_counts as (

    select
        extract(month from date_witness) as sighting_month,
        region,
        count(*) as sighting_count
    from {{ ref('fct_sightings') }}
    group by 1, 2

),

ranked as (

    select
        *,
        row_number() over (
            partition by sighting_month
            order by sighting_count desc
        ) as region_rank
    from monthly_region_counts

)

select
    sighting_month,
    region as top_region,
    sighting_count
from ranked
where region_rank = 1
order by sighting_month
