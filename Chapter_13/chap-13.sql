SELECT upper('hello');

SELECT initcap('at the end of the day');

SELECT position('v' in 'David');

SELECT trim('d' from 'david');

SELECT rtrim('socks', 's');

SELECT substring('The game starts at 7 p.m. on May 2, 2019.' from '\d{4}');

CREATE TABLE crime_reports (
 crime_id bigserial PRIMARY KEY,
 date_1 timestamp with time zone,
 date_2 timestamp with time zone,
 street varchar(250),
 city varchar(100),
 crime_type varchar(100),
 description text,
 case_number varchar(50),
 original_text text NOT NULL
);
COPY crime_reports (original_text)
FROM 'C:\01-my-folder\Work\Code College\sql\1.material\practical-sql-main\practical-sql-main\Chapter_13\crime_reports.csv'
WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

SELECT * FROM crime_reports;

SELECT crime_id,
 regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports;

SELECT crime_id,
 regexp_match(original_text, '-\d{1,2}\/\d{1,2}\/\d{2}')
FROM crime_reports;

SELECT crime_id,
 regexp_match(original_text, '-(\d{1,2}\/\d{1,2}\/\d{1,2})')
FROM crime_reports;

SELECT
 regexp_match(original_text, '(?:C0|SO)[0-9]+') AS case_number,
 regexp_match(original_text, '\d{1,2}\/\d{1,2}\/\d{2}') AS date_1,
 regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):') AS crime_type,
 regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n')
 AS city
FROM crime_reports;