-- One row per distinct sighting location. city + country_code + lat/long
-- are functionally dependent on each other (a given city always has the
-- same coordinates in this dataset), so pulling them into their own
-- dimension removes that repeating group from the fact table.

with source as (
    select distinct
        city,
        country_code,
        latitude,
        longitude
    from {{ ref('int_carmen_sightings_unioned') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['city', 'country_code', 'latitude', 'longitude']) }} as location_id,
    city,
    country_code,
    latitude,
    longitude
from source
