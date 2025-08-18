
{{
    config( 
        materialized='incremental',
        incremental_strategy= 'merge',
        unique_key =  'season',
        on_schema_change  =  'append_new_columns'
    )

}}

with totals as (
    
    select 
        year(game_date_est::date) as season,
        sum(pts_home + pts_away) as total_points,
        count(game_id) as total_games,
        sum(case when pts_home > pts_away then 1 else 0 end) as total_home_wins
    from {{ source('nba_raw_data', 'LINE_SCORE') }}
    {% if is_incremental() %}
        where year(game_date_est::date) >= (select max(season) from {{ this }})
    {% endif %}
    group by all
)
,final as (
    select
        season,
        round(total_points / total_games, 2) as ppg,
        total_home_wins/total_games as win_percentage
    from totals
)
select * from final