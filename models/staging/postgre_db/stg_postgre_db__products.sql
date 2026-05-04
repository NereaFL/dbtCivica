{{
  config(
    materialized='incremental',
    unique_key='product_id',
    incremental_strategy = 'append'
  )
}}

with 

source as (

    select * from {{ source('postgre_db', 'products') }}

),

renamed as (

    select
        product_id,
        price,
        name,
        inventory,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed