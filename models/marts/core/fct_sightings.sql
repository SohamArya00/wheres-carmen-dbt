-- Central fact table: one row per Carmen Sandiego sighting, with agent,
-- witness, and location attributes normalized out to their own
-- dimensions. This is the >1NF result required by step 3.

with sightings as (
    select * from {{ ref('int_carmen_sightings_unioned') }}
),

agents as (
    select * from {{ ref('dim_agents') }}
),

witnesses as (
    select * from {{ ref('dim_witnesses') }}
),

locations as (
    select * from {{ ref('dim_locations') }}
)

select
    s.sighting_id,
    s.region,
    s.date_witness,
    s.date_agent,
    a.agent_id,
    w.witness_id,
    l.location_id,
    s.has_weapon,
    s.has_hat,
    s.has_jacket,
    s.behavior
from sightings s
left join agents a
    on s.agent = a.agent
    and s.city_agent = a.city_agent
left join witnesses w
    on s.witness = w.witness
left join locations l
    on s.city = l.city
    and s.country_code = l.country_code
    and s.latitude = l.latitude
    and s.longitude = l.longitude
