-- 1.Build a table named first_pick_only
-- For each team and season, 
-- show the team’s win percentage and round pick only 
-- for their highest first-round draft pick that year (lowest round_pick).


with highest_pick as (

select 
    full_name,
    season,
    win_percentage,
    round_pick,
    row_number () over (partition by full_name,season order by round_pick asc) as RN
 from {{ ref('win_precentage_draft_picks') }}
 where round_pick is not null
)
select * from highest_pick
where RN =1 