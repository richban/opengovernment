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
    lower(transaction_status),
    'contract',
    'contracts',
    signeddate,
    cast(fiscal_year as int) fiscal_year,
    coalesce(nullif(trim(both '   ' from lower(substring(contractactiontype from 4))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(substring(typeofcontractpricing from 4))), ''), 'n\a'),
    case
      when idvpiid is not null then trim(both '   ' from idvpiid)
      else coalesce(nullif(trim(both '  ' from piid), ''), 'n\a')
    end as award_id,
    coalesce(nullif(trim(both '   ' from lower(descriptionofcontractrequirement)), ''), 'n\a'),
    dollarsobligated,
    coalesce(nullif(trim(both '   ' from modnumber), ''), '0'),
    coalesce(nullif(trim(both '   ' from lower(substring(reasonformodification from 4))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(maj_fund_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(contractingofficeagencyid from 7))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(vendorname)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(streetaddress)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(city)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(state)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from substring(zipcode from 1 for 5)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(vendorcountrycode from 6))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(dunsnumber)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(productorservicecode from 7))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(placeofperformancecity)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(pop_state_code from 5))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(placeofperformancezipcode from 1 for 5))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(placeofperformancecountrycode from 6))), ''), 'united states of america'),
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
    lower(transaction_status),
    'grant',
    'grants',
    obligation_action_date,
    cast(fiscal_year as int) fiscal_year,
    coalesce(nullif(trim(both '   ' from lower(substring(action_type from 4))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(assistance_type from 5))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from federal_award_id), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(project_description)), ''), 'n\a'),
    fed_funding_amount,
    coalesce(nullif(trim(both '   ' from federal_award_mod), ''), '0'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(agency_code from 7))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(recipient_name)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(receip_addr1)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(recipient_city_name)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(recipient_zip from 1 for 5))), ''), 'n\a'),
    case
    	when lower(a.recipient_country_code) = lower(b.country_code) then lower(trim(both '   ' from b.country_name))
    	else coalesce(nullif(trim(both '  ' from lower(recipient_country_code)), ''), 'n\a')
    end,
    coalesce(nullif(trim(both '   ' from lower(duns_no)), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(principal_place_cc)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(principal_place_zip from 1 for 5))), ''), 'n\a'),
    case
    	when lower(a.principal_place_country_code) = lower(c.country_code) then lower(trim(both '   ' from c.country_name))
    	else coalesce(nullif(trim(both '  ' from lower(principal_place_country_code)), ''), 'united states of america')
    end,
    last_modified_date
  from
    base_grants a left join country_codes_names b
    on lower(a.recipient_country_code) = lower(b.country_code)
    left join country_codes_names c on lower(a.principal_place_country_code) = lower(c.country_code)
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
    lower(transaction_status),
    'loan',
    'loans',
    obligation_action_date,
    cast(fiscal_year as int) fiscal_year,
    coalesce(nullif(trim(both '   ' from lower(substring(action_type from 4))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(assistance_type from 5))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from federal_award_id), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(project_description)), ''), 'n\a'),
    fed_funding_amount,
    coalesce(nullif(trim(both '   ' from federal_award_mod), ''), '0'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(agency_code from 7))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(recipient_name)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(receip_addr1)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(recipient_city_name)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(recipient_zip from 1 for 5))), ''), 'n\a'),
    case
    	when lower(a.recipient_country_code) = lower(b.country_code) then lower(trim(both '   ' from b.country_name))
    	else coalesce(nullif(trim(both '  ' from lower(recipient_country_code)), ''), 'n\a')
    end,
    coalesce(nullif(trim(both '   ' from lower(duns_no)), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(principal_place_cc)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(principal_place_zip from 1 for 5))), ''), 'n\a'),
    case
    	when lower(a.principal_place_country_code) = lower(c.country_code) then lower(trim(both '   ' from c.country_name))
    	else coalesce(nullif(trim(both '  ' from lower(principal_place_country_code)), ''), 'united states of america')
    end,
    last_modified_date
  from
    base_loans a left join country_codes_names b
    on lower(a.recipient_country_code) = lower(b.country_code)
    left join country_codes_names c on lower(a.principal_place_country_code) = lower(c.country_code)
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
    lower(transaction_status),
    'other fin',
    'other financial assistance',
    obligation_action_date,
    cast(fiscal_year as int) fiscal_year,
    coalesce(nullif(trim(both '   ' from lower(substring(action_type from 4))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(assistance_type from 5))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from federal_award_id), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(project_description)), ''), 'n\a'),
    fed_funding_amount,
    coalesce(nullif(trim(both '   ' from federal_award_mod), ''), '0'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(substring(maj_agency_cat from 7))), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(agency_code from 7))), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(recipient_name)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(receip_addr1)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(recipient_city_name)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(recipient_zip from 1 for 5))), ''), 'n\a'),
    case
    	when lower(a.recipient_country_code) = lower(b.country_code) then lower(trim(both '   ' from b.country_name))
    	else coalesce(nullif(trim(both '  ' from lower(recipient_country_code)), ''), 'n\a')
    end,
    coalesce(nullif(trim(both '   ' from lower(duns_no)), ''), 'n\a'),
    'n\a',
    coalesce(nullif(trim(both '   ' from lower(principal_place_cc)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(principal_place_state)), ''), 'n\a'),
    coalesce(nullif(trim(both '   ' from lower(substring(principal_place_zip from 1 for 5))), ''), 'n\a'),
    case
    	when lower(a.principal_place_country_code) = lower(c.country_code) then lower(trim(both '   ' from c.country_name))
    	else coalesce(nullif(trim(both '  ' from lower(principal_place_country_code)), ''), 'united states of america')
    end,
    last_modified_date
  from
    base_fin a left join country_codes_names b
    on lower(a.recipient_country_code) = lower(b.country_code)
    left join country_codes_names c on lower(a.principal_place_country_code) = lower(c.country_code)
    where federal_award_id is not null;
