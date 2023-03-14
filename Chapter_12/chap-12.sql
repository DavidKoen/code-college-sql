DROP TABLE us_counties_2010;

CREATE TABLE us_counties_2010 (
    geo_name varchar(90),                    -- Name of the geography
    state_us_abbreviation varchar(2),        -- State/U.S. abbreviation
    summary_level varchar(3),                -- Summary Level
    region smallint,                         -- Region
    division smallint,                       -- Division
    state_fips varchar(2),                   -- State FIPS code
    county_fips varchar(3),                  -- County code
    area_land bigint,                        -- Area (Land) in square meters
    area_water bigint,                        -- Area (Water) in square meters
    population_count_100_percent integer,    -- Population count (100%)
    housing_unit_count_100_percent integer,  -- Housing Unit count (100%)
    internal_point_lat numeric(10,7),        -- Internal point (latitude)
    internal_point_lon numeric(10,7),        -- Internal point (longitude)

    -- This section is referred to as P1. Race:
    p0010001 integer,   -- Total population
    p0010002 integer,   -- Population of one race:
    p0010003 integer,       -- White Alone
    p0010004 integer,       -- Black or African American alone
    p0010005 integer,       -- American Indian and Alaska Native alone
    p0010006 integer,       -- Asian alone
    p0010007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0010008 integer,       -- Some Other Race alone
    p0010009 integer,   -- Population of two or more races
    p0010010 integer,   -- Population of two races:
    p0010011 integer,       -- White; Black or African American
    p0010012 integer,       -- White; American Indian and Alaska Native
    p0010013 integer,       -- White; Asian
    p0010014 integer,       -- White; Native Hawaiian and Other Pacific Islander
    p0010015 integer,       -- White; Some Other Race
    p0010016 integer,       -- Black or African American; American Indian and Alaska Native
    p0010017 integer,       -- Black or African American; Asian
    p0010018 integer,       -- Black or African American; Native Hawaiian and Other Pacific Islander
    p0010019 integer,       -- Black or African American; Some Other Race
    p0010020 integer,       -- American Indian and Alaska Native; Asian
    p0010021 integer,       -- American Indian and Alaska Native; Native Hawaiian and Other Pacific Islander
    p0010022 integer,       -- American Indian and Alaska Native; Some Other Race
    p0010023 integer,       -- Asian; Native Hawaiian and Other Pacific Islander
    p0010024 integer,       -- Asian; Some Other Race
    p0010025 integer,       -- Native Hawaiian and Other Pacific Islander; Some Other Race
    p0010026 integer,   -- Population of three races
    p0010047 integer,   -- Population of four races
    p0010063 integer,   -- Population of five races
    p0010070 integer,   -- Population of six races

    -- This section is referred to as P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    p0020001 integer,   -- Total
    p0020002 integer,   -- Hispanic or Latino
    p0020003 integer,   -- Not Hispanic or Latino:
    p0020004 integer,   -- Population of one race:
    p0020005 integer,       -- White Alone
    p0020006 integer,       -- Black or African American alone
    p0020007 integer,       -- American Indian and Alaska Native alone
    p0020008 integer,       -- Asian alone
    p0020009 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0020010 integer,       -- Some Other Race alone
    p0020011 integer,   -- Two or More Races
    p0020012 integer,   -- Population of two races
    p0020028 integer,   -- Population of three races
    p0020049 integer,   -- Population of four races
    p0020065 integer,   -- Population of five races
    p0020072 integer,   -- Population of six races

    -- This section is referred to as P3. RACE FOR THE POPULATION 18 YEARS AND OVER
    p0030001 integer,   -- Total
    p0030002 integer,   -- Population of one race:
    p0030003 integer,       -- White alone
    p0030004 integer,       -- Black or African American alone
    p0030005 integer,       -- American Indian and Alaska Native alone
    p0030006 integer,       -- Asian alone
    p0030007 integer,       -- Native Hawaiian and Other Pacific Islander alone
    p0030008 integer,       -- Some Other Race alone
    p0030009 integer,   -- Two or More Races
    p0030010 integer,   -- Population of two races
    p0030026 integer,   -- Population of three races
    p0030047 integer,   -- Population of four races
    p0030063 integer,   -- Population of five races
    p0030070 integer,   -- Population of six races

    -- This section is referred to as P4. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
    -- FOR THE POPULATION 18 YEARS AND OVER
    p0040001 integer,   -- Total
    p0040002 integer,   -- Hispanic or Latino
    p0040003 integer,   -- Not Hispanic or Latino:
    p0040004 integer,   -- Population of one race:
    p0040005 integer,   -- White alone
    p0040006 integer,   -- Black or African American alone
    p0040007 integer,   -- American Indian and Alaska Native alone
    p0040008 integer,   -- Asian alone
    p0040009 integer,   -- Native Hawaiian and Other Pacific Islander alone
    p0040010 integer,   -- Some Other Race alone
    p0040011 integer,   -- Two or More Races
    p0040012 integer,   -- Population of two races
    p0040028 integer,   -- Population of three races
    p0040049 integer,   -- Population of four races
    p0040065 integer,   -- Population of five races
    p0040072 integer,   -- Population of six races

    -- This section is referred to as H1. OCCUPANCY STATUS
    h0010001 integer,   -- Total housing units
    h0010002 integer,   -- Occupied
    h0010003 integer    -- Vacant
);

COPY us_counties_2010
FROM 'C:\01-my-folder\Work\Code College\sql\1.material\practical-sql-main\practical-sql-main\Chapter_04\us_counties_2010.csv'
WITH (FORMAT CSV, HEADER);

SELECT geo_name,
 state_us_abbreviation,
 p0010001
FROM us_counties_2010
WHERE p0010001 >= (
SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010
 )
ORDER BY p0010001 DESC;

CREATE TABLE us_counties_2010_top10 AS
SELECT * FROM us_counties_2010;

DELETE FROM us_counties_2010_top10
WHERE p0010001 < (
SELECT percentile_cont(.9) WITHIN GROUP (ORDER BY p0010001)
FROM us_counties_2010_top10
 ); 
 
SELECT round(calcs.average, 0) AS average,
 calcs.median,
 round(calcs.average - calcs.median, 0) AS median_average_diff
FROM (
 SELECT avg(p0010001) AS average,
 percentile_cont(.5)
 WITHIN GROUP (ORDER BY p0010001)::numeric(10,1) AS median
 FROM us_counties_2010
 )
AS calcs;

SELECT census.state_us_abbreviation AS st,
 census.st_population,
 plants.plant_count,
 round((plants.plant_count/census.st_population::numeric(10,1))*1000000, 1)
 AS plants_per_million
FROM
 (
 SELECT st,
 count(*) AS plant_count
 FROM meat_poultry_egg_inspect
 GROUP BY st
 )
 AS plants
JOIN
 (
 SELECT state_us_abbreviation,
 sum(p0010001) AS st_population
 FROM us_counties_2010
 GROUP BY state_us_abbreviation
 )
 AS census
ON plants.st = census.state_us_abbreviation
ORDER BY plants_per_million DESC;

SELECT geo_name,
 state_us_abbreviation AS st,
 p0010001 AS total_pop,
 (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
 FROM us_counties_2010) AS us_median
FROM us_counties_2010;

SELECT geo_name,
 state_us_abbreviation AS st,
 p0010001 AS total_pop,
 (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
 FROM us_counties_2010) AS us_median,
 p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
 FROM us_counties_2010) AS diff_from_median
FROM us_counties_2010
WHERE (p0010001 - (SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY p0010001)
 FROM us_counties_2010))
 BETWEEN -1000 AND 1000;
 
CREATE TABLE retirees (
    id int,
    first_name varchar(50),
    last_name varchar(50)
);

INSERT INTO retirees (
	VALUES (1, 'Lee', 'Smith'),
		   (2, 'Janet', 'King')
);

SELECT * FROM retirees;

CREATE TABLE employees (
    id bigserial,
    first_name varchar(50),
    last_name varchar(50)
);
 
SELECT first_name, last_name
FROM employees
WHERE emp_id IN (
SELECT id
FROM retirees);

SELECT first_name, last_name
FROM employees
WHERE EXISTS (
 SELECT id
 FROM retirees
 WHERE id = employees.emp_id);