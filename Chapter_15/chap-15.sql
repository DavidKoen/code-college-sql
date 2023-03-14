CREATE TABLE teachers (
 id bigserial,
 first_name varchar(25),
 last_name varchar(50),
 school varchar(50),
 hire_date date,
 salary numeric
);

CREATE TABLE us_counties_2000 (
 geo_name varchar(90),
 state_us_abbreviation varchar(2),
 state_fips varchar(2),
 county_fips varchar(3),
 p0010001 integer,
 p0010002 integer,
 p0010003 integer,
 p0010004 integer,
 p0010005 integer,
 p0010006 integer,
 p0010007 integer,
 p0010008 integer,
 p0010009 integer,
 p0010010 integer,
 p0020002 integer,
 p0020003 integer
);
COPY us_counties_2000
FROM 'C:\01-my-folder\Work\Code College\sql\1.material\practical-sql-main\practical-sql-main\Chapter_06\us_counties_2000.csv'
WITH (FORMAT CSV, HEADER);

CREATE OR REPLACE VIEW nevada_counties_pop_2010 AS
 SELECT geo_name,
 state_fips,
 county_fips,
 p0010001 AS pop_2010
 FROM us_counties_2010
 WHERE state_us_abbreviation = 'NV'
 ORDER BY county_fips;
 
SELECT *
FROM nevada_counties_pop_2010
LIMIT 5;

CREATE OR REPLACE VIEW county_pop_change_2010_2000 AS
 SELECT c2010.geo_name,
 c2010.state_us_abbreviation AS st,
 c2010.state_fips,
 c2010.county_fips,
 c2010.p0010001 AS pop_2010,
 c2000.p0010001 AS pop_2000,
 round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
 / c2000.p0010001 * 100, 1 ) AS pct_change_2010_2000
 FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
 ON c2010.state_fips = c2000.state_fips
 AND c2010.county_fips = c2000.county_fips
 ORDER BY c2010.state_fips, c2010.county_fips;
 
SELECT geo_name,
st,
pop_2010,
pct_change_2010_2000
FROM county_pop_change_2010_2000
WHERE st = 'NV'
LIMIT 5;

SELECT * FROM employees;

CREATE OR REPLACE VIEW employees_tax_dept AS
 SELECT emp_id,
 first_name,
 last_name,
 dept_id
 FROM employees
 WHERE dept_id = 1
 ORDER BY emp_id
 WITH LOCAL CHECK OPTION;
 
INSERT INTO employees_tax_dept (first_name, last_name, dept_id)
VALUES ('Suzanne', 'Legere', 1);

INSERT INTO employees_tax_dept (first_name, last_name, dept_id)
VALUES ('Jamil', 'White', 2);

SELECT * FROM employees_tax_dept;

SELECT * FROM employees;

DELETE FROM employees_tax_dept
WHERE emp_id = 5;

CREATE OR REPLACE FUNCTION
percent_change(new_value numeric,
 old_value numeric,
 decimal_places integer DEFAULT 1)
RETURNS numeric AS
'SELECT round(
 ((new_value - old_value) / old_value) * 100, decimal_places
);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

CREATE OR REPLACE FUNCTION
percent_change(new_value numeric,
 old_value numeric,
 decimal_places integer DEFAULT 1)
RETURNS numeric AS
'SELECT round(
 ((new_value - old_value) / old_value) * 100, decimal_places
);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

SELECT percent_change(110, 108, 2);

SELECT c2010.geo_name,
 c2010.state_us_abbreviation AS st,
 c2010.p0010001 AS pop_2010,
 percent_change(c2010.p0010001, c2000.p0010001) AS pct_chg_func,
 round( (CAST(c2010.p0010001 AS numeric(8,1)) - c2000.p0010001)
 / c2000.p0010001 * 100, 1 ) AS pct_chg_formula
FROM us_counties_2010 c2010 INNER JOIN us_counties_2000 c2000
ON c2010.state_fips = c2000.state_fips
 AND c2010.county_fips = c2000.county_fips
ORDER BY pct_chg_func DESC
LIMIT 5;

ALTER TABLE teachers ADD COLUMN personal_days integer;
SELECT first_name,
 last_name,
 hire_date,
 personal_days
FROM teachers;

CREATE TABLE grades (
 student_id bigint,
 course_id bigint,
 course varchar(30) NOT NULL,
 grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id)
);
INSERT INTO grades
VALUES
 (1, 1, 'Biology 2', 'F'),
 (1, 2, 'English 11B', 'D'),
 (1, 3, 'World History 11B', 'C'),
 (1, 4, 'Trig 2', 'B');
CREATE TABLE grades_history (
 student_id bigint NOT NULL,
 course_id bigint NOT NULL,
 change_time timestamp with time zone NOT NULL,
 course varchar(30) NOT NULL,
 old_grade varchar(5) NOT NULL,
 new_grade varchar(5) NOT NULL,
PRIMARY KEY (student_id, course_id, change_time)
);

SELECT * FROM grades;

CREATE OR REPLACE FUNCTION record_if_grade_changed()
 RETURNS trigger AS
$$
BEGIN
 IF NEW.grade <> OLD.grade THEN
 INSERT INTO grades_history (
 student_id,
 course_id,
 change_time,
 course,
 old_grade,
 new_grade)
 VALUES
 (OLD.student_id,
 OLD.course_id,
 now(),
 OLD.course,
 OLD.grade,
 NEW.grade);
 END IF;
 RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER grades_update
AFTER UPDATE
 ON grades
FOR EACH ROW
EXECUTE PROCEDURE record_if_grade_changed();

UPDATE grades
SET grade = 'C'
WHERE student_id = 1 AND course_id = 1;

SELECT student_id,
 change_time,
 course,
 old_grade,
 new_grade
FROM grades_history;

CREATE TABLE temperature_test (
 station_name varchar(50),
 observation_date date,
 max_temp integer,
 min_temp integer,
 max_temp_group varchar(40),
PRIMARY KEY (station_name, observation_date)
);

CREATE OR REPLACE FUNCTION classify_max_temp()
 RETURNS trigger AS
$$
BEGIN
 CASE
 WHEN NEW.max_temp >= 90 THEN
 NEW.max_temp_group := 'Hot';
 WHEN NEW.max_temp BETWEEN 70 AND 89 THEN
 NEW.max_temp_group := 'Warm';
 WHEN NEW.max_temp BETWEEN 50 AND 69 THEN
 NEW.max_temp_group := 'Pleasant';
 WHEN NEW.max_temp BETWEEN 33 AND 49 THEN
 NEW.max_temp_group := 'Cold';
 WHEN NEW.max_temp BETWEEN 20 AND 32 THEN
 NEW.max_temp_group := 'Freezing';
 ELSE NEW.max_temp_group := 'Inhumane';
 END CASE;
 RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER temperature_insert
 BEFORE INSERT
 ON temperature_test
 FOR EACH ROW
 EXECUTE PROCEDURE classify_max_temp();
 
 INSERT INTO temperature_test (station_name, observation_date, max_temp, min_temp)
VALUES
 ('North Station', '2019/1/19', 10, -3),
 ('North Station', '2019/3/20', 28, 19),
 ('North Station', '2019/2/5', 65, 42),
 ('North Station', '2019/9/8', 93, 74);

SELECT * FROM temperature_test;