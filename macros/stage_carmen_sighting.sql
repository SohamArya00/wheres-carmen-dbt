{% macro stage_carmen_sighting(source_relation, region_name) %}
{#
    Applies consistent typing / light cleanup to a raw Carmen Sandiego region
    seed and tags each row with its originating region. Every region's raw
    seed already conforms to the shared data dictionary column-for-column,
    so this macro just standardises types, trims strings, and adds
    provenance (region_name + a stable surrogate key) rather than doing any
    heavy per-source mapping.
#}

select
    {{ dbt_utils.generate_surrogate_key([
        'date_witness', 'witness', 'agent', 'date_agent', 'city', 'latitude', 'longitude'
    ]) }} as sighting_id,

    '{{ region_name }}'                        as region,

    cast(date_witness as date)                 as date_witness,
    trim(witness)                               as witness,
    trim(agent)                                 as agent,
    cast(date_agent as date)                    as date_agent,
    trim(city_agent)                            as city_agent,

    upper(trim(country_code))                   as country_code,
    trim(city)                                  as city,
    cast(latitude as float)                     as latitude,
    cast(longitude as float)                    as longitude,

    cast(has_weapon as boolean)                 as has_weapon,
    cast(has_hat as boolean)                    as has_hat,
    cast(has_jacket as boolean)                 as has_jacket,

    lower(trim(behavior))                       as behavior

from {{ source_relation }}

{% endmacro %}
