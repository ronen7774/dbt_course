with states as (

    select *  from {{ref('state_mapping')}}
)

,teams as(
select 
    full_name,
    state
 from {{ source('nba_raw_data', 'TEAM') }} )

 , final as (
    select
        teams.full_name,
        case
            when states.code is null then -1
            else states.code
            end as state_code
    from   teams
    left join  states
    using(state)
 )

 select * from final