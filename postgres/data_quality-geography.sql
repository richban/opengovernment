-- replace values for foreign entities

-- Update #0 Correct Coutry full names

create table country_codes_names(
	country_code text,
	country_name text
);

insert into country_codes_names
select distinct
	split_part(placeofperformancecountrycode, ': ', 1) as country_code,
	split_part(placeofperformancecountrycode, ': ', 2) as country_name
from base_contracts;

select distinct
	case
		when a.principal_place_country_code = b.country_code then b.country_name
		else a.principal_place_country_code
	end as country_name
from base_fin a join country_codes_names b
on a.principal_place_country_code = b.country_code;


-- Update #1 Geography

update load_data set
	geography_country = 'united states of america',
  	recipient_country = 'united states of america'
	where
    geography_country = 'usa' or
    recipient_country = 'usa';

-- Update #2

update load_data set
	geography_state = 'forgn',
	geography_city = 'forgn',
	geography_zip = 'forgn'
where geography_country != 'united states of america' or geography_country = 'n\a';

-- Update #3 NOT USED! NEW REPLACEMENT

update load_data_2 set
	geography_city = 'n\a',
  geography_state = 'n\a',
  recipient_state = 'n\a',
  recipient_city = 'n\a'
where
  geography_city ~ '(\d+)' or
  geography_state ~ '(\d+)' or
  recipient_state ~ '(\d+)' or
  recipient_city ~ '(\d+)';


-- Update #4

update load_data
set geography_state =
	case geography_state
  	when 'fl' then 'florida'
    when 'la' then 'louisiana'
    when 'or' then 'oregon'
    when 'ms' then 'mississippi'
    when 'il' then 'illinois'
    when 'in' then 'indiana'
    when 'ut' then 'utah'
    when 'mi' then 'michigan'
    when 'ks' then 'kansas'
    when 'mn' then 'minnesota'
    when 'ne' then 'nebraska'
    when 'ct' then 'connecticut'
    when 'al' then 'alabama'
    when 'ca' then 'california'
    when 'nd' then 'north dakota'
    when 'wa' then 'washington'
    when 'ky' then 'kentucky'
    when 'ri' then 'rhode island'
    when 'va' then 'virginia'
    when 'ia' then 'iowa'
    when 'ny' then 'new york'
    when 'ma' then 'massachusetts'
    when 'tx' then 'texas'
    when 'pa' then 'pennsylvania'
    when 'az' then 'arizona'
    when 'mt' then 'montana'
    when 'nm' then 'new mexico'
    when 'ak' then 'alaska'
    when 'nc' then 'north carolina'
    when 'vt' then 'vermont'
    when 'ar' then 'arkansas'
    when 'mo' then 'missouri'
    when 'wy' then 'wyoming'
    when 'md' then 'maryland'
    when 'vi' then 'virginia'
    when 'ga' then 'georgia'
    when 'wi' then 'wisconsin'
    when 'dc' then 'district of columbia'
    when 'oh' then 'ohio'
    when 'nv' then 'nevada'
    when 'ok' then 'oklahoma'
    when 'co' then 'colorado'
    when 'wv' then 'west virginia'
    when 'de' then 'delaware'
    when 'me' then 'maine'
    when 'tn' then 'tennessee'
    when 'sd' then 'south dakota	'
    when 'nh' then 'new hampshire'
    when 'sc' then 'south carolina'
    when 'id' then 'idaho'
    when 'nj' then 'new rersey'
    when 'mp' then 'northern mariana islands'
    when 'pr' then 'puerto rico'
    when 'gu' then 'guam'
    when 'hi' then 'howland island'
    when 'as' then 'american samoa'
    when 'mh' then 'marshall islands'
    when 'd.c' then 'district of columbia'
    when 'd.c.' then 'district of columbia'
    when 'dc' then 'district of columbia'
	else
		lower(geography_state)
	end
where length(geography_state) < 5;


--
-- Update #5
--

update load_data
set recipient_state =
	case recipient_state
  	when 'fl' then 'florida'
	when 'la' then 'louisiana'
	when 'or' then 'oregon'
	when 'ms' then 'mississippi'
	when 'il' then 'illinois'
	when 'in' then 'indiana'
	when 'ut' then 'utah'
	when 'mi' then 'michigan'
	when 'ks' then 'kansas'
	when 'mn' then 'minnesota'
	when 'ne' then 'nebraska'
	when 'ct' then 'connecticut'
	when 'al' then 'alabama'
	when 'ca' then 'california'
	when 'nd' then 'north dakota'
	when 'wa' then 'washington'
	when 'ky' then 'kentucky'
	when 'ri' then 'rhode island'
	when 'va' then 'virginia'
	when 'ia' then 'iowa'
	when 'ny' then 'new york'
	when 'ma' then 'massachusetts'
	when 'tx' then 'texas'
	when 'pa' then 'pennsylvania'
	when 'az' then 'arizona'
	when 'mt' then 'montana'
	when 'nm' then 'new mexico'
	when 'ak' then 'alaska'
	when 'nc' then 'north carolina'
	when 'vt' then 'vermont'
	when 'ar' then 'arkansas'
	when 'mo' then 'missouri'
	when 'wy' then 'wyoming'
	when 'md' then 'maryland'
	when 'vi' then 'virginia'
	when 'ga' then 'georgia'
	when 'wi' then 'wisconsin'
	when 'dc' then 'district of columbia'
	when 'oh' then 'ohio'
	when 'nv' then 'nevada'
	when 'ok' then 'oklahoma'
	when 'co' then 'colorado'
	when 'wv' then 'west virginia'
	when 'de' then 'delaware'
	when 'me' then 'maine'
	when 'tn' then 'tennessee'
	when 'sd' then 'south dakota	'
	when 'nh' then 'new hampshire'
	when 'sc' then 'south carolina'
	when 'id' then 'idaho'
	when 'nj' then 'new rersey'
	when 'mp' then 'northern mariana islands'
	when 'pr' then 'puerto rico'
	when 'gu' then 'guam'
	when 'hi' then 'howland island'
	when 'as' then 'american samoa'
  when 'mh' then 'marshall islands'
  when 'd.c' then 'district of columbia'
  when 'd.c.' then 'district of columbia'
  when 'dc' then 'district of columbia'
	else
		lower(recipient_state)
	end
where length(recipient_state) < 3;

--
-- Update #3
--

update load_data set
	recipient_state = coalesce(nullif(trim(both '   ' from regexp_replace(recipient_state, '([\-\+\.\"\#\^:,*''\d])+', '', 'g')), ''), 'n\a'),
  recipient_city = coalesce(nullif(trim(both '   ' from regexp_replace(recipient_city, '([\-\+\.\"\#\^:,*''\d])+', '', 'g')), ''), 'n\a'),
  geography_city = coalesce(nullif(trim(both '   ' from regexp_replace(geography_city, '([\-\+\.\"\#\^:,*''\d])+', '', 'g')), ''), 'n\a'),
  geography_state = coalesce(nullif(trim(both '   ' from regexp_replace(geography_state, '([\-\+\.\"\#\^:,*''\d])+', '', 'g')), ''), 'n\a');


--
-- Update #3.1 Correct zipcodes
--

update load_data set
	recipient_zip =
	case
		when length(trim(both ' 	' from regexp_replace(recipient_zip, '(\D)', '', 'g'))) < 5 then 'n\a'
		else trim(both ' 	' from regexp_replace(recipient_zip, '(\D)', '', 'g'))
	end,
	geography_zip =
	case
		when length(trim(both ' 	' from regexp_replace(geography_zip, '(\D)', '', 'g'))) < 5 then 'n\a'
		else trim(both ' 	' from regexp_replace(geography_zip, '(\D)', '', 'g'))
	end;

--
-- Update #7
--

update load_data set
	recipient_city = coalesce(nullif(trim(both '  ' from regexp_replace(recipient_city, '[^a-zA-Z \\]', '')), ''), 'n\a');

update load_data set
	recipient_city = coalesce(nullif(trim(both '   ' from regexp_replace(recipient_city, '/([\-\+\.\"\^:,*''])+/g', '')), ''), 'n\a');


--
-- Update #8
--

update load_data set
recipient_city =
	case
		when recipient_city = 'n\a' and geography_city != 'n\a' then geography_city
		else recipient_city
	end,
recipient_state =
	case
		when recipient_state = 'n\a' and geography_state != 'n\a' then geography_state
		else recipient_state
	end,
recipient_country =
	case
		when recipient_country = 'n\a' and geography_country != 'n\a' then geography_country
		else recipient_country
	end,
recipient_zip =
	case
		when recipient_zip = 'n\a' and geography_zip != 'n\a' then geography_zip
		else recipient_zip
	end,
geography_city =
		case
		when geography_city = 'n\a' and recipient_city != 'n\a' then recipient_city
		else geography_city
	end,
geography_state =
	case
		when geography_state = 'n\a' and recipient_state != 'n\a' then recipient_state
		else geography_state
	end,
geography_country =
	case
		when geography_country = 'n\a' and recipient_country != 'n\a' then recipient_country
		else geography_country
	end,
geography_zip =
	case
		when geography_zip = 'n\a' and recipient_zip != 'n\a' then recipient_zip
		else geography_zip
	end
where geography_country = 'united states of america' and
(recipient_country = 'united states of america' or recipient_country = 'n\a');
