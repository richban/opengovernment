-- replace values for foreign entities

-- Update #1 Geography

update load_data_2 set
	geography_country = 'usa'
	where geography_country = 'united states of america';

-- Update #2

update load_data_2 set
	geography_state = 'forgn',
	geography_city = 'forgn',
	geography_zip = 'forgn'
where geography_country != 'usa' or geography_country = 'N\A';

-- Update #3

update load_data_2 set
	geography_city = 'N\A'
where geography_city ~ '(\d+)';


-- Update #4

update load_data_2
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
	else
		lower(geography_state)
	end
where length(geography_state) <3;

select
lower(state),
lower(city),
max(lower(zip)),
lower(country),
count(*)
from geo group by 1,2,4;

--
-- Replace Emty cells Agency
--

update load_data set
	funding_bureau =
	case trim(lower(funding_bureau))
		when '' then 'N\A'
	else
		trim(lower(funding_bureau))
	end,
	funding_bureau_id =
	case trim(lower(funding_bureau_id))
		when '' then 'N\A'
	else
		trim(lower(funding_bureau_id))
	end
where trim(lower(funding_bureau_id)) = '';

