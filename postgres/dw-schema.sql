--
-- PostgresSQL Dimensional Model
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;


--
-- Name opg; Type: SCHEMA; Owner: postgres
--

CREATE SCHEMA opg;

ALTER SCHEMA opg OWNER TO postgres;

SET search_path = opg, pg_catalog;

SET default_tablespace = '';

SEET default_with_oids = false;

--
-- Name: dm_product; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dm_product (
    id integer SERIAL PRIMARY KEY,
    product_name text,
);

ALTER TABLE opg.dm_product OWNER TO richban;

--
-- Name: dm_geography; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dm_geography (
    id SERIAL PRIMARY KEY,
    state text,
    city text,
    zip text,
    country text
);

ALTER TABLE opg.dm_geography OWNER TO richban;

--
-- Name: dm_agency; Type: Dimension; Schema; opg; Owner: richban;
--

CREATE TABLE dm_agency (
    id SERIAL PRIMARY KEY,
    awarding_agency text,
    funding_agency text,
    bureau text
);

ALTER TABLE opg.dm_agency OWNER TO richban;

--
-- Name: dm_recipient; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dm_recipient (
    id SERIAL PRIMARY KEY,
    name text,
    streetaddress text,
    state text,
    city text,
    zip text,
    country text,
    duns text
);

ALTER TABLE opg.dm_recipient OWNER TO richban;

--
-- Name: dm_transaction_type; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dm_transaction_type (
    id SERIAL PRIMARY KEY,
    status text,
    category_type text,
    category_desc text
);

ALTER TABLE opg.dm_transaction_type OWNER TO richban;

--
-- Name: dm_date; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dm_date (
    id SERIAL PRIMARY KEY NOT NULL,
    full_date date,
    year numeric,
    month numeric,
    month_name text,
    day numeric,
    day_year numeric,
    weekday_name text,
    calendar_week text,
    quarter text
);

ALTER TABLE opg.dm_date OWNER TO richban;


--
-- Name: dm_award; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dm_award (
    id SERIAL PRIMARY KEY NOT NULL,
    award_id text NOT NULL,
    award_mod text,
    award_action_type text,
    award_ass_type text,
    award_pricing_type text,
    award_desc text
);

ALTER TABLE opg.dm_award OWNER TO richban;

--
-- Name: ft_transaction; Type: Fact Table; Schema: opg; Owner: richban;
-

CREATE TABLE ft_spending (
    id SERIAL PRIMARY KEY NOT NULL,
    transaction_type_id integer NOT NULL,
    date_id integer NOT NULL,
    product_id integer NOT NULL,
    geography_id integer NOT NULL,
    agency_id integer NOT NULL,
    recipient_id integer NOT NULL,
    award_id integer NOT NULL,
    award_amount numeric,
    transactions integer,
    last_modified_date date,
    date_added date
);

ALTER TABLE opg.ft_transaction OWNER TO richban;

--
-- Data for Name: dm_date; Type: Table Data; Schema: opg; Owner: richban;
--

INSERT INTO dm_date (
    full_date,
    year,
    month,
    month_name,
    day,
    day_year,
    weekday_name,
    calendar_week,
    quarter
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
	  'Q' || to_char(date, 'Q') AS Quarter
FROM (
		SELECT '2000-01-01'::DATE + SEQUENCE.DAY AS date
	  FROM generate_series(0,10000) AS SEQUENCE(DAY)
	  GROUP BY SEQUENCE.DAY
    ) DQ
ORDER BY 1;


--
-- Data for Name: dm_agency; Type: Table Data; Schema: opg; Owner: richban;
--

INSERT INTO dm_agency(
    awarding_agency,
    funding_agency,
    bureau
)
SELECT DISTINCT
    agency_name,
    funding_bureau_cat,
    funding_bureau
FROM load_data
EXCEPT
SELECT
    awarding_agency,
    funding_agency,
    bureau
FROM dm_agency;

--
-- Data for Name: dm_transaction_type; Type: Table Data; Schema: opg; Owner: richban;
--

INSERT INTO dm_transaction_type(
    status,
    category_type,
    category_desc
)
SELECT DISTINCT
    transaction_status,
    transaction_cat,
    transaction_desc
FROM load_data
EXCEPT
SELECT
    status,
    category_type,
    category_desc
FROM dm_transaction_type;

--
-- Data for Name: dm_product Type: Table Data; Schema: opg; Owner: richban;
--

INSERT INTO dm_product (product_name)
SELECT DISTINCT
	 coalesce(product_code, 'n\a')
FROM load_data
EXCEPT
SELECT product_name
FROM dm_product;

--
-- Data for Name: dm_recipient Type: Table Data; Schema: opg; Owner: richban;
--

INSERT INTO dm_recipient (
    name,
    streetaddress,
    state,
    city,
    zip,
    country,
    duns
)
SELECT DISTINCT
    coalesce(recipient_name, 'n\a'),
    coalesce(recipient_streetaddress, 'n\a'),
    coalesce(recipient_state, 'n\a'),
    coalesce(recipient_city, 'n\a'),
    coalesce(recipient_zip, 'n\a'),
    coalesce(recipient_country, 'n\a'),
    coalesce(recipient_duns, 'n\a')
FROM load_data;
EXCEPT
SELECT
    name,
    streetaddress,
    state,
    city,
    zip,
    country,
    duns
FROM dm_recipient;

--
-- Data for Name: dm_geography Type: Table Data; Schema: opg; Owner: richban;
--

INSERT INTO dm_geography(
    state,
    city,
    zip,
    country
)
SELECT DISTINCT
    geography_state,
    geography_city,
    geography_zip,
    geography_country
FROM load_data
EXCEPT
SELECT
    state,
    city,
    zip,
    country
from dm_geography;

--
-- Data for Name: dm_award Type: Table Data; Schema: opg; Owner: richban;
--

INSERT INTO dm_award(
    award_id,
    award_mod,
    award_action_type,
    award_ass_type,
    award_pricing_type,
    award_desc
)
SELECT DISTINCT
    award_id,
    award_mod,
    award_action_type,
    award_assistance_type,
    award_pricing_type,
    award_desc
FROM load_data
EXCEPT
SELECT
    award_id,
    award_mod,
    award_action_type,
    award_ass_type,
    award_pricing_type,
    award_desc
FROM dm_award;


--
-- Data for Name: ft_spending Type: Fact Table; Schema: opg; Owner: richban;
--

INSERT INTO ft_spending (
	transaction_type_id,
	date_id,
	product_id,
	geography_id,
	agency_id,
	recipient_id,
	award_id,
	transaction_id,
	award_amount,
	transactions,
	last_modified_date,
	date_added)
SELECT
 coalesce(dt.id, 0) transaction_type_id
,coalesce(dd.id, 0) date_id
,coalesce(dp.id, 0) product_id
,coalesce(dg.id, 0) geography_id
,coalesce(da.id, 0) agency_id
,coalesce(dr.id, 0) recipient_id
,coalesce(dw.id, 0) award_id
,transaction_id
,sum(award_amount) award_amount
,count(*) transactions
,last_modified_date
,current_date date_added
FROM load_data_2 oo
LEFT JOIN dm_recipient dr
	ON oo.recipient_name = dr.name
	AND oo.recipient_streetaddress = dr.streetaddress
	AND oo.recipient_duns = dr.duns
LEFT JOIN dm_product dp
	ON oo.product_code = dp.product_name
LEFT JOIN dm_date dd
	ON oo.signed_date = dd.full_date
LEFT JOIN dm_geography dg
	ON oo.geography_state = dg.state
	AND oo.geography_city = dg.city
	AND oo.geography_zip = dg.zip
	AND oo.geography_country = dg.country
LEFT JOIN dm_agency da
	ON oo.agency_name = da.awarding_agency
	AND oo.funding_bureau_cat = da.funding_agency
LEFT JOIN dm_transaction_type dt
	ON oo.transaction_cat = dt.category_type
LEFT JOIN dm_award dw
	ON oo.award_id = dw.award_id
	AND oo.award_mod = dw.award_mod
	AND oo.award_desc = dw.award_desc
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 11;
