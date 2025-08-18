
{{
    config( 
        schema= 'PUBLIC',
        materialized='incremental',
        incremental_strategy= 'merge',
        unique_key =  'season'
    )

}}


with totals as (
    
    select 
        year(game_date_est::date) as season,
        sum(pts_home + pts_away) as total_points,
        count(game_id) as total_games
    from {{ source('nba_raw_data', 'LINE_SCORE') }}
    {% if is_incremental() %}
        where year(game_date_est::date) >= (select max(season) from {{ this }})
    {% endif %}
    group by 1
)
,final as (
    select 
        season,
        round(total_points / total_games, 2) as ppg
    from totals
)
select * from final