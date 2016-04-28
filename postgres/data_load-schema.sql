--
-- PostgreSQL database load phase
--

CREATE TABLE load_data(
    id BIGSERIaL PRIMaRY KEY,
    transaction_id text,
    transaction_status text,
    transaction_cat text default null,
    transaction_desc text default null,
    signed_date date,
    fiscal_year int,
    award_action_type text,
    award_assistance_type text default null,
    award_pricing_type text,
    award_id text,
    award_desc text,
    award_amount numeric,
    award_mod text,
    award_mod_reason text,
    agency_name text,
    funding_bureau_cat text,
    funding_bureau text,
    recipient_name text,
    recipient_streetaddress text,
    recipient_city text,
    recipient_state text,
    recipient_zip text,
    recipient_country text,
    recipient_duns text,
    product_code text,
    geography_city text,
    geography_state text,
    geography_zip text,
    geography_country text,
    last_modified_date date
);

insert into load_data(
	  transaction_id,
    transaction_status,
    transaction_cat,
    transaction_desc,
    signed_date,
    fiscal_year,
    award_action_type,
    award_assistance_type,
    award_pricing_type,
    award_id,
    award_desc,
    award_amount,
    award_mod,
    award_mod_reason,
    agency_name,
    funding_bureau_cat,
    funding_bureau,
    recipient_name,
    recipient_streetaddress,
    recipient_city,
    recipient_state,
    recipient_zip,
    recipient_country,
    recipient_duns,
    product_code,
    geography_city,
    geography_state,
    geography_zip,
    geography_country,
    last_modified_date
)
select
    unique_transaction_id,
    transaction_status,
    'contract',
    'contracts',
    signeddate,
    cast(fiscal_year as int) fiscal_year,
    nullif(coalesce(lower(substring(contractactiontype from 4)), 'n\a'), ''),
    'n\a',
    coalesce(nullif(lower(substring(typeofcontractpricing from 4)), ''), 'n\a'),
    case
      when idvpiid is not null then trim(idvpiid)
      else trim(piid)
    end as award_id,
    coalesce(nullif(lower(descriptionofcontractrequirement), ''), 'n\a'),
    dollarsobligated,
    modnumber,
    coalesce(nullif(trim(lower(substring(reasonformodification from 4))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(maj_fund_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(contractingofficeagencyid from 7))), ''), 'n\a'),
    coalesce(nullif(trim(lower(vendorname)), ''), 'n\a'),
    coalesce(nullif(trim(lower(streetaddress)), ''), 'n\a'),
    coalesce(nullif(trim(lower(city)), ''), 'n\a'),
    coalesce(nullif(trim(lower(state)), ''), 'n\a'),
    coalesce(nullif(trim(substring(zipcode from 1 for 5)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(vendorcountrycode from 6))), ''), 'n\a'),
    coalesce(nullif(trim(lower(dunsnumber)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(productorservicecode from 7))), ''), 'n\a'),
    coalesce(nullif(trim(lower(placeofperformancecity)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(pop_state_code from 5))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(placeofperformancezipcode from 1 for 5))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(placeofperformancecountrycode from 6))), ''), 'usa'),
    last_modified_date
  from
    base_contracts;


insert into load_data(
	  transaction_id,
    transaction_status,
    transaction_cat,
    transaction_desc,
    signed_date,
    fiscal_year,
    award_action_type,
    award_assistance_type,
    award_pricing_type,
    award_id,
    award_desc,
    award_amount,
    award_mod,
    award_mod_reason,
    agency_name,
    funding_bureau_cat,
    funding_bureau,
    recipient_name,
    recipient_streetaddress,
    recipient_city,
    recipient_state,
    recipient_zip,
    recipient_country,
    recipient_duns,
    product_code,
    geography_city,
    geography_state,
    geography_zip,
    geography_country,
    last_modified_date
)
select
    unique_transaction_id,
    transaction_status,
    'grant',
    'grants',
    obligation_action_date,
    cast(fiscal_year as int) fiscal_year,
    coalesce(nullif(lower(substring(action_type from 4)), ''), 'n\a'),
    coalesce(nullif(lower(substring(assistance_type from 5)), ''), 'n\a'),
    'n\a',
    trim(federal_award_id),
    coalesce(nullif(lower(project_description), ''), 'n\a'),
    fed_funding_amount,
    coalesce(federal_award_mod, '0'),
    'n\a',
    coalesce(nullif(trim(lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(agency_code from 7))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(lower(recipient_name)), ''), 'n\a'),
    coalesce(nullif(trim(lower(receip_addr1)), ''), 'n\a'),
    coalesce(nullif(trim(lower(recipient_city_name)), ''), 'n\a'),
    coalesce(nullif(trim(lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(recipient_zip from 1 for 5))), ''), 'n\a'),
    case
    	when a.recipient_country_code = b.country_code then lower(trim(b.country_name))
    	else coalesce(nullif(trim(lower(recipient_country_code)), ''), 'n\a')
    end,
    coalesce(nullif(trim(lower(duns_no)), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(lower(principal_place_cc)), ''), 'n\a'),
    coalesce(nullif(trim(lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(principal_place_zip from 1 for 5))), ''), 'n\a'),
    case
    	when a.principal_place_country_code = b.country_code then lower(trim(b.country_name))
    	else coalesce(nullif(trim(lower(principal_place_country_code)), ''), 'united states of america')
    end,
    last_modified_date
  from
    base_grants a left join country_codes_names b
    on a.recipient_country_code = b.country_code or a.principal_place_country_code = b.country_code
    where federal_award_id is not null;

insert into load_data(
	  transaction_id,
    transaction_status,
    transaction_cat,
    transaction_desc,
    signed_date,
    fiscal_year,
    award_action_type,
    award_assistance_type,
    award_pricing_type,
    award_id,
    award_desc,
    award_amount,
    award_mod,
    award_mod_reason,
    agency_name,
    funding_bureau_cat,
    funding_bureau,
    recipient_name,
    recipient_streetaddress,
    recipient_city,
    recipient_state,
    recipient_zip,
    recipient_country,
    recipient_duns,
    product_code,
    geography_city,
    geography_state,
    geography_zip,
    geography_country,
    last_modified_date
)
select
    unique_transaction_id,
    transaction_status,
    'loan',
    'loans',
    obligation_action_date,
    cast(fiscal_year as int) fiscal_year,
    coalesce(nullif(lower(substring(action_type from 4)), ''), 'n\a'),
    coalesce(nullif(lower(substring(assistance_type from 5)), ''), 'n\a'),
    'n\a',
    trim(federal_award_id),
    coalesce(nullif(lower(project_description), ''), 'n\a'),
    fed_funding_amount,
    coalesce(federal_award_mod, '0'),
    'n\a',
    coalesce(nullif(trim(lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(agency_code from 7))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(lower(recipient_name)), ''), 'n\a'),
    coalesce(nullif(trim(lower(receip_addr1)), ''), 'n\a'),
    coalesce(nullif(trim(lower(recipient_city_name)), ''), 'n\a'),
    coalesce(nullif(trim(lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(recipient_zip from 1 for 5))), ''), 'n\a'),
    case
    	when a.recipient_country_code = b.country_code then lower(trim(b.country_name))
    	else coalesce(nullif(trim(lower(recipient_country_code)), ''), 'n\a')
    end,
    coalesce(nullif(trim(lower(duns_no)), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(lower(principal_place_cc)), ''), 'n\a'),
    coalesce(nullif(trim(lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(principal_place_zip from 1 for 5))), ''), 'n\a'),
    case
    	when a.principal_place_country_code = b.country_code then lower(trim(b.country_name))
    	else coalesce(nullif(trim(lower(principal_place_country_code)), ''), 'united states of america')
    end,
    last_modified_date
  from
    base_loans a left join country_codes_names b
    on a.recipient_country_code = b.country_code or a.principal_place_country_code = b.country_code
    where federal_award_id is not null;


insert into load_data(
	  transaction_id,
    transaction_status,
    transaction_cat,
    transaction_desc,
    signed_date,
    fiscal_year,
    award_action_type,
    award_assistance_type,
    award_pricing_type,
    award_id,
    award_desc,
    award_amount,
    award_mod,
    award_mod_reason,
    agency_name,
    funding_bureau_cat,
    funding_bureau,
    recipient_name,
    recipient_streetaddress,
    recipient_city,
    recipient_state,
    recipient_zip,
    recipient_country,
    recipient_duns,
    product_code,
    geography_city,
    geography_state,
    geography_zip,
    geography_country,
    last_modified_date
)
select
    unique_transaction_id,
    transaction_status,
    'other fin',
    'other financial assistance',
    obligation_action_date,
    cast(fiscal_year as int) fiscal_year,
    coalesce(nullif(lower(substring(action_type from 4)), ''), 'n\a'),
    coalesce(nullif(lower(substring(assistance_type from 5)), ''), 'n\a'),
    'n\a',
    trim(federal_award_id),
    coalesce(nullif(lower(project_description), ''), 'n\a'),
    fed_funding_amount,
    coalesce(federal_award_mod, '0'),
    'n\a',
    coalesce(nullif(trim(lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(agency_code from 7))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(lower(recipient_name)), ''), 'n\a'),
    coalesce(nullif(trim(lower(receip_addr1)), ''), 'n\a'),
    coalesce(nullif(trim(lower(recipient_city_name)), ''), 'n\a'),
    coalesce(nullif(trim(lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(recipient_zip from 1 for 5))), ''), 'n\a'),
    case
    	when a.recipient_country_code = b.country_code then lower(trim(b.country_name))
    	else coalesce(nullif(trim(lower(recipient_country_code)), ''), 'n\a')
    end,
    coalesce(nullif(trim(lower(duns_no)), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(lower(principal_place_cc)), ''), 'n\a'),
    coalesce(nullif(trim(lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(lower(substring(principal_place_zip from 1 for 5))), ''), 'n\a'),
    case
    	when a.principal_place_country_code = b.country_code then lower(trim(b.country_name))
    	else coalesce(nullif(trim(lower(principal_place_country_code)), ''), 'united states of america')
    end,
    last_modified_date
  from
    base_fin a left join country_codes_names b
    on a.recipient_country_code = b.country_code or a.principal_place_country_code = b.country_code
    where federal_award_id is not null
