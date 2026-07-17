-- One row per distinct witness. Witness names alone aren't a fully
-- reliable natural key (two "John Smith"s could exist), but the source
-- data gives us nothing else to disambiguate a witness by, so this is a
-- pragmatic dimension. Documented as a known limitation in the README.

with source as (
    select distinct
        witness
    from {{ ref('int_carmen_sightings_unioned') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['witness']) }} as witness_id,
    witness
from source
