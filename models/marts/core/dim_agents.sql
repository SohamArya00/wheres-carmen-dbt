-- One row per distinct field agent + their reporting HQ city.
-- Splitting this out removes the agent/city_agent repeating group
-- from the fact table (progress toward 3NF).

with source as (
    select distinct
        agent,
        city_agent
    from {{ ref('int_carmen_sightings_unioned') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['agent', 'city_agent']) }} as agent_id,
    agent,
    city_agent
from source
