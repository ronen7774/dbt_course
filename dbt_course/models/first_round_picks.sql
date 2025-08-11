-- Build a table named first_round_picks
-- showing all first-round (round_number) draft picks by season, including player name, team id, and their round pick.
-- (draft_history table)

{{ config(materialized='table') }}

select 
    season, 
    player_name, 
    team_id, 
    round_pick
from {{ source('nba_raw_data', 'DRAFT_HISTORY') }} 
where round_number = 1
