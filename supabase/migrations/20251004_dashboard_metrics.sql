-- Función para obtener métricas de corrales
create or replace function get_corral_metrics()
returns table (
  active_count bigint,
  occupancy_rate numeric,
  monthly_change numeric
) 
language plpgsql
security definer
as $$
begin
  return query
  with current_stats as (
    select 
      count(*) as total,
      count(case when exists (
        select 1 from batches b 
        where b.corral_id = c.id 
        and b.status = 'active'
      ) then 1 end) as active,
      sum(capacity) as total_capacity
    from corrals c
  ),
  last_month_stats as (
    select count(*) as active_last_month
    from corrals c
    where exists (
      select 1 from batches b 
      where b.corral_id = c.id 
      and b.status = 'active'
      and b.created_at >= (now() - interval '1 month')
    )
  )
  select 
    cs.active,
    (cs.active::numeric / nullif(cs.total_capacity, 0) * 100)::numeric(5,2),
    ((cs.active - lms.active_last_month)::numeric / nullif(lms.active_last_month, 0) * 100)::numeric(5,2)
  from current_stats cs, last_month_stats lms;
end;
$$;

-- Función para obtener métricas de lotes
create or replace function get_batch_metrics()
returns table (
  active_count bigint,
  general_status text,
  ending_soon bigint
) 
language plpgsql
security definer
as $$
begin
  return query
  with batch_stats as (
    select
      count(*) filter (where status = 'active') as active,
      count(*) filter (where end_date <= (now() + interval '7 days')) as ending_soon
    from batches
  )
  select 
    active,
    case 
      when active = 0 then 'Sin lotes activos'
      when active > (select count(*) from corrals) then 'Sobrecapacidad'
      else 'Normal'
    end,
    ending_soon
  from batch_stats;
end;
$$;

-- Función para obtener métricas de población
create or replace function get_population_metrics()
returns table (
  total_count bigint,
  status_distribution jsonb,
  daily_entries bigint,
  daily_exits bigint
) 
language plpgsql
security definer
as $$
begin
  return query
  with daily_stats as (
    select
      count(*) filter (where created_at::date = current_date) as entries,
      count(*) filter (where status = 'inactive' and updated_at::date = current_date) as exits
    from animals
  ),
  status_stats as (
    select 
      jsonb_object_agg(
        status,
        count(*)
      ) as distribution
    from animals
    group by status
  )
  select
    (select count(*) from animals),
    (select distribution from status_stats),
    (select entries from daily_stats),
    (select exits from daily_stats);
end;
$$;

-- Función para obtener métricas de peso
create or replace function get_weight_metrics()
returns table (
  average_weight numeric,
  daily_gain numeric,
  weekly_trend text
) 
language plpgsql
security definer
as $$
declare
  current_avg numeric;
  week_ago_avg numeric;
begin
  -- Calcular promedio actual
  select avg(weight)
  into current_avg
  from animal_events
  where type = 'weight'
  and event_date = current_date;

  -- Calcular promedio de hace una semana
  select avg(weight)
  into week_ago_avg
  from animal_events
  where type = 'weight'
  and event_date = current_date - interval '7 days';

  return query
  with daily_gain as (
    select 
      avg(
        (e2.weight - e1.weight) / 
        extract(day from e2.event_date - e1.event_date)
      ) as adg
    from animal_events e1
    join animal_events e2 
      on e1.animal_id = e2.animal_id
      and e1.event_date < e2.event_date
      and e1.type = 'weight'
      and e2.type = 'weight'
    where e2.event_date >= current_date - interval '7 days'
  )
  select
    current_avg::numeric(5,2),
    (select adg::numeric(5,2) from daily_gain),
    case
      when current_avg > week_ago_avg then 'Positiva'
      when current_avg < week_ago_avg then 'Negativa'
      else 'Estable'
    end;
end;
$$;