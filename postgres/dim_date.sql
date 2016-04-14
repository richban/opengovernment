drop table if exists dim_date;

create table dim_date(
    id SERIAL PRIMARY KEY not null,
    full_date date,
    year numeric,
    month numeric,
    month_name text,
    day numeric,
    day_year numeric,
    weekday_name text,
    calendar_week numeric,
    quartal text
);


insert into dim_date (
    full_date,
    year,
    month,
    month_name,
    day,
    day_year,
    weekday_name,
    calendara_week,
    quartal
)
SELECT
	  date AS DATE,
	  EXTRACT(YEAR FROM date) AS YEAR,
	  EXTRACT(MONTH FROM date) AS MONTH,
	  to_char(date, 'TMMonth') AS MonthName,
	  EXTRACT(DAY FROM date) AS DAY,
	  EXTRACT(doy FROM date) AS DayOfYear,
	  to_char(date, 'TMDay') AS WeekdayName,
	  EXTRACT(week FROM date) AS CalendarWeek,
	  'Q' || to_char(date, 'Q') AS Quartal
FROM (
		SELECT '2000-01-01'::DATE + SEQUENCE.DAY AS date
	  FROM generate_series(0,10000) AS SEQUENCE(DAY)
	  GROUP BY SEQUENCE.DAY
    ) DQ
ORDER BY 1;
