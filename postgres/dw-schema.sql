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
-- Name: dim_product; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dim_product (
    id integer SERIAL PRIMARY KEY,
    product_detail text,
    claimant_code text,
    it_commercial_item text,
    placeof_manufacture text
);

ALTER TABLE opg.dim_product OWNER TO richban;

--
-- Name: dim_geography; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dim_geography (
    id integer SERIAL PRIMARY KEY,
    state text,
    city text,
    cd text,
    zip text,
    country text
);

ALTER TABLE opg.dim_geography OWNER TO richban;

--
-- Name: dim_agency; Type: Dimension; Schema; opg; Owner: richban;
--

CREATE TABLE dim_agency (
    id integer SERIAL PRIMARY KEY,
    agency_name text,
    agency_office_id text,
    funding_bureau_cat text,
    funding_bureau_id text,
    funding_bureau text,
    funding_bureau_office_id text
);

ALTER TABLE opg.dim_agency OWNER TO richban;

--
-- Name: dim_recipient; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dim_recipient (
    id integer SERIAL PRIMARY KEY,
    name text,
    legal_name text,
    streetaddress text,
    streetaddress2 text,
    state text,
    city text,
    zip text,
    cd text,
    country text,
    duns text,
    parent_name text,
    parent_duns text,
    phoneno text,
    faxno text,
    registration_date date,
    organization_type text
);

ALTER TABLE opg.dim_recipient OWNER TO richban;

--
-- Name: dim_transaction_type; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dim_transaction_type (
    id integer SERIAL PRIMARY KEY,
    status text,
    category_type text,
    category_desc text
);

ALTER TABLE opg.dim_transaction_type OWNER TO richban;

--
-- Name: dim_date; Type: Dimension; Schema: opg; Owner: richban;
--

CREATE TABLE dim_date (
    id integer SERIAL PRIMARY KEY,
    full_date date,
    year integer,
    month integer,
    month_name text,
    day integer,
    day_name text,
    week_day integer
);

ALTER TABLE opg.dim_transaction_type OWNER TO richban;

--
-- Name: ft_transaction; Type: Fact Table; Schema: opg; Owner: richban;
--

CREATE TABLE ft_transaction (
    id integer SERIAL PRIMARY KEY,
    transaction_type_id integer,
    date_id integer,
    product_id integer,
    geography_id integer,
    agency_id integer,
    recipient_id integer,
    transaction_key text,
    award_id text,
    award_action_type text,
    award_ass_type text,
    award_pricing_type text,
    award_desct text,
    award_mod text,
    mod_reason text,
    signed_date date,
    fiscal_year date,
    last_modified_date date,
    date_added date,
    award_amount numeric,
    award_currency text,
);

ALTER TABLE opg.ft_transaction OWNER TO richban;
