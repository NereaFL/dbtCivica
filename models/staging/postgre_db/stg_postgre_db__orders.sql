{{
  config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='delete+insert'
  )
}}

with source as (

    select *
    from {{ source('postgre_db', 'orders') }}

    {% if is_incremental() %}
        where order_date >= current_date - interval '3 days'
    {% endif %}

),

renamed as (

    select
        order_id,
        order_date,
        shipping_service,
        shipping_cost,
        address_id,
        created_at,
        promo_id,
        estimated_delivery_at,
        order_cost,
        user_id,
        order_total,
        delivered_at,
        tracking_id,
        status,
        _fivetran_deleted,
        _fivetran_synced

    from source

)

select * from renamed