-- Build a table named win_percentage_year
-- For each home team id, show the win percentage (W_L home) in every season (year of game date) after the year 2000
-- (game table)

{{ config(materialized='table') }}

SELECT
team_id_home,
year(game_date) as season,
sum(case when wl_home = 'W' then 1 else 0 end)/count(*) as precentage_w
FROM
  {{source('nba_raw_data','game')}}
where season > 2000
group  by all  