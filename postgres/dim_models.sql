/*** FactSpending ***/
drop table fact_spending;
create table fact_spending
(
	 id SERIAL PRIMARY KEY not null
	,recipient_id  int not null
	,product_id int not null
	,award_amount numeric
	,transactions int
	,update_date date not null
);

----------------------------------------------------------------

insert into fact_spending (recipient_id, product_id, award_amount, transactions , update_date)
select 
 coalesce(dr.id, 0) recipient_id
,coalesce(dp.id, 0) product_id
,sum(award_amount) award_amount
,count(*) transactions
,current_date update_date
from load_data oo
left join dim_recipient dr
	 on oo.recipient_name = dr.name
	and oo.recipient_streetaddress = dr.streetaddress
	and oo.recipient_duns = dr.duns
left join dim_product dp
	 on oo.product_code = dp.name
group by
 coalesce(dr.id, 0)
,coalesce(dp.id, 0);


/*** DIM Recipient ***/

DROP TABLE dim_recipient;
CREATE TABLE dim_recipient
(
     id SERIAL PRIMARY KEY
    ,name text
    ,streetaddress text
    ,duns text
);

-----------------------------------------------------

insert into dim_recipient (name, streetaddress, duns)
select distinct
    coalesce(recipient_name, '')
    ,coalesce(recipient_streetaddress, '')
    ,coalesce(recipient_duns, '')
from load_data
except
select name, streetaddress, duns 
from dim_recipient;

/*** DIM Product ***/

DROP TABLE dim_product;
CREATE TABLE dim_product 
(
     id SERIAL PRIMARY KEY
    ,product_name text
);

------------------------------------------------------

insert into dim_product (name)
select distinct
	 coalesce(product_code, 'UNKW')
from load_data
exept
select product_name
from dim_product;


/*** DIM Date ***/

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


/*** DIM Agency ***/

DROP TABLE IF EXISTS dim_agency;

CREATE TABLE dim_agency(
    id SERIAL PRIMARY KEY,
    awarding_agency text,
    funding_agency text,
    bureau text
);

insert into dim_agency(
    awarding_agency,
    funding_agency,
    bureau
)
select distinct
    agency_name,
    funding_bureau_cat,
    funding_burea
from geo
except
select
    agency_name,
    funding_bureau_cat,
    funding_bureau
from dim_agency;

/*** Dim Transaction ***/

DROP TABLE IF EXISTS dim_transaction_type;

CREATE TABLE dim_transaction_type(
    id SERIAL PRIMARY KEY,
    status text,
    category_type text,
    category_desc text
);

INSERT INTO dim_transaction_type(
    status,
    category_type,
    category_desc
)
select distinct
    transaction_status,
    transaction_category,
    transaction_desc
from load_data
except
select
    transaction_status,
    transaction_category,
    transaction_desc
from dim_transaction_type;

/*** Dim Place of Performance ***/

DROP TABLE IF EXISTS dim_place;

CREATE TABLE dim_place(
    id SERIAL PRIMARY KEY,
    state text,
    city text,
    zip text,
    country text
);

INSERT INTO dim_place(
    state,
    city,
    zip,
    country
)
SELECT DISTINCT
    state,
    city,
    zip,
    country
from load_data
except
SELECT
    state,
    city,
    zip,
    country,
from dim_place;

