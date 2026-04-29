{{
  config(
    materialized = 'view'
  )
}}

with source as (

    select * from {{ source('postgre_db', 'addresses') }}

),

renamed as (

    select
        cast(address_id as varchar(36))           as address_id,
        cast(zipcode as varchar(20))              as zipcode,
        cast(country as varchar(100))             as country,
        cast(address as varchar(255))             as address,
        cast(state as varchar(100))               as state,
        cast(_fivetran_deleted as boolean)        as _fivetran_deleted,
        cast(_fivetran_synced as timestamp_tz)    as _fivetran_synced

    from source

)

select * from renamed