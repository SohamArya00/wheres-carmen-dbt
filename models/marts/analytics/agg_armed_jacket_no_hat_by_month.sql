-- Q(b): For each calendar month, what proportion of sightings show Carmen
-- as armed AND wearing a jacket AND NOT wearing a hat?

select
    extract(month from date_witness) as sighting_month,
    count(*) as total_sightings,
    sum(case when has_weapon and has_jacket and not has_hat then 1 else 0 end)
        as armed_jacket_no_hat_count,
    round(
        sum(case when has_weapon and has_jacket and not has_hat then 1 else 0 end)::float
        / nullif(count(*), 0),
        4
    ) as armed_jacket_no_hat_proportion
from {{ ref('fct_sightings') }}
group by 1
order by 1
