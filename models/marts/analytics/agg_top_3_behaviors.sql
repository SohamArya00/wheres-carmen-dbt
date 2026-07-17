-- Q(c): Across the entire dataset, what are the three most occurring
-- behaviors of Ms. Sandiego?

select
    behavior,
    count(*) as occurrence_count
from {{ ref('fct_sightings') }}
group by 1
order by occurrence_count desc
limit 3
