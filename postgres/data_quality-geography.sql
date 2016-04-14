--replace null values for foreign entities

update geo set
	state = 'FORGN',
	city = 'FORGN',
	zip = 'FORGN'
where country != 'USA';


-- correct USA states

update geo
set state =
	case state
  	when 'FL' then 'Florida'
	when 'LA' then 'Louisiana'
	when 'OR' then 'Oregon'
	when 'MS' then 'Mississippi'
	when 'IL' then 'Illinois'
	when 'IN' then 'Indiana'
	when 'UT' then 'Utah'
	when 'MI' then 'Michigan'
	when 'KS' then 'Kansas'
	when 'MN' then 'Minnesota'
	when 'NE' then 'Nebraska'
	when 'CT' then 'Connecticut'
	when 'AL' then 'Alabama'
	when 'CA' then 'California'
	when 'ND' then 'North Dakota'
	when 'WA' then 'Washington'
	when 'KY' then 'Kentucky'
	when 'RI' then 'Rhode Island'
	when 'VA' then 'Virginia'
	when 'IA' then 'Iowa'
	when 'NY' then 'New York'
	when 'MA' then 'Massachusetts'
	when 'TX' then 'Texas'
	when 'PA' then 'Pennsylvania'
	when 'AZ' then 'Arizona'
	when 'MT' then 'Montana'
	when 'NM' then 'New Mexico'
	when 'AK' then 'Alaska'
	when 'NC' then 'North Carolina'
	when 'VT' then 'Vermont'
	when 'AR' then 'Arkansas'
	when 'MO' then 'Missouri'
	when 'WY' then 'Wyoming'
	when 'MD' then 'Maryland'
	when 'VI' then 'Virginia'
	when 'GA' then 'Georgia'
	when 'WI' then 'Wisconsin'
	when 'DC' then 'District of Columbia'
	when 'OH' then 'Ohio'
	when 'NV' then 'Nevada'
	when 'OK' then 'Oklahoma'
	when 'CO' then 'Colorado'
	when 'WV' then 'West Virginia'
	when 'DE' then 'Delaware'
	when 'ME' then 'Maine'
	when 'TN' then 'Tennessee'
	when 'SD' then 'South Dakota	'
	when 'NH' then 'New Hampshire'
	when 'SC' then 'South Carolina'
	when 'ID' then 'Idaho'
	when 'NJ' then 'New Jersey'
	else
		state
	end
where length(state) <3;

-- substring zip 5 digit
update geo set
	zip = substring(zip from 1 for 5);

-- Add USA value where is null
update geo set
	country = coalesce(country, 'USA');

-- default null value UNKW
update geo set
	state = 'UNKW',
	city = 'UNKW',
	zip = 'UNKW'
where state is null or city is null or zip is null;

-- incorect fieled default UNKW
update geo set
	city = 'UNKW'
where city ~ '(\d+)';


select
lower(state),
lower(city),
max(lower(zip)),
lower(country),
count(*)
from geo group by 1,2,4;
