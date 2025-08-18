{{
    config( 
        materialized='view'
    )

}}

select
    year,
    player,
    tm as team,
    g as total_games,
    pts as total_points
from {{ source('nba_raw_data', 'SEASONS_STATS') }} 

