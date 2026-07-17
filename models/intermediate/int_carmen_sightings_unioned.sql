-- Unions the 8 regional staging views into a single 1NF sighting log.
-- This is the last "flat" model before we normalize into fct/dim tables
-- in the marts/core layer (step 3 of the assessment).

with unioned as (

    select * from {{ ref('stg_carmen__africa') }}
    union all
    select * from {{ ref('stg_carmen__america') }}
    union all
    select * from {{ ref('stg_carmen__asia') }}
    union all
    select * from {{ ref('stg_carmen__atlantic') }}
    union all
    select * from {{ ref('stg_carmen__australia') }}
    union all
    select * from {{ ref('stg_carmen__europe') }}
    union all
    select * from {{ ref('stg_carmen__indian') }}
    union all
    select * from {{ ref('stg_carmen__pacific') }}

)

select * from unioned
