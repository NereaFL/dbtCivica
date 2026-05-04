{{
  config(
    materialized='incremental',
    unique_key='_row',
    incremental_strategy = 'merge'
  )
}}


WITH src_budget AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id
        , quantity
        , month
        , _fivetran_synced AS date_load
    FROM src_budget
    )

SELECT * FROM renamed_casted
{% if is_incremental() %}
        WHERE updated_at < (SELECT MAX(update_at) FROM {{ this }})
    {% endif %}