-- Central fact table: one row per Carmen Sandiego sighting, with agent,
-- witness, and location attributes normalized out to their own
-- dimensions. This is the >1NF result required by step 3.

with sightings as (
    select * from {{ ref('int_carmen_sightings_unioned') }}
)

-- Dimension surrogate keys are computed directly here with the exact same
-- expression used in dim_agents / dim_witnesses / dim_locations, rather
-- than joining back to those dimensions on raw column equality. Joining
-- on float columns (latitude/longitude) is unreliable: floating-point
-- representation can differ enough between two independently-cast copies
-- of "the same" value that an equality join silently drops the match.
-- Deriving the key with an identical expression on both sides avoids
-- that class of bug entirely.

select
    s.sighting_id,
    s.region,
    s.date_witness,
    s.date_agent,
    {{ dbt_utils.generate_surrogate_key(['s.agent', 's.city_agent']) }} as agent_id,
    {{ dbt_utils.generate_surrogate_key(['s.witness']) }} as witness_id,
    {{ dbt_utils.generate_surrogate_key(['s.city', 's.country_code', 's.latitude', 's.longitude']) }} as location_id,
    s.has_weapon,
    s.has_hat,
    s.has_jacket,
    s.behavior
from sightings s
