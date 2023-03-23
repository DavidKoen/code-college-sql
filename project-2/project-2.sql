CREATE TABLE zip_codes (
	zip_code CHAR(4) PRIMARY KEY CHECK(LENGTH(zip_code) <= 4),
	city VARCHAR(30) NOT NULL,
	province VARCHAR(30) NOT NULL,
	CONSTRAINT city_province_unique UNIQUE (city, province)
);	

INSERT INTO zip_codes
(
	zip_code,
	city,
	province
)
VALUES
('5605', 'Bisho', 'Eastern Cape'),
('5200', 'East London', 'Eastern Cape'),
('9300', 'Bloemfontein', 'Free State'),
('1911', 'Sasolburg', 'Free State'),
('2000', 'Johannesburg', 'Gauteng'),
('1447', 'Alberton', 'Gauteng'),
('3200', 'Pietermaritzburg', 'KwaZulu-Natal'),
('4000', 'Durban', 'KwaZulu-Natal'),
('0699', 'Polokwane', 'Limpopo'),
('0480', 'Bela-Bela', 'Limpopo'),
('1200', 'Mbombela', 'Mpumalanga'),
('1920', 'Pilgrim''s Rest', 'Mpumalanga'),
('8300', 'Kimberly', 'Northern Cape'),
('2735', 'Upington',  'Northern Cape'),
('7105', 'Cape Town', 'Western Cape'),
('7103', 'George', 'Western Cape'),
('9103', 'Brits', 'North West'),
('9108', 'Rustenburg', 'North West');

CREATE TABLE professions (
	prof_id BIGSERIAL CONSTRAINT professions_id_key PRIMARY KEY,
	profession VARCHAR(30) NOT NULL,
	CONSTRAINT profession_unique UNIQUE (profession)
);

INSERT INTO professions(profession)
VALUES 
('doctor'),
('teacher'), 
('software developer'),
('student'),
('cargo and freight agent'), --5
('real estate agent'),
('bench jeweler'),
('secretary');

CREATE TABLE statuses (
	status_id BIGSERIAL CONSTRAINT status_id_key_2 PRIMARY KEY,
	status VARCHAR(30) UNIQUE NOT NULL
);

INSERT INTO statuses(status)
VALUES
('single'),
('divorced');

CREATE TABLE seekings
(
	seeking_id BIGSERIAL CONSTRAINT seeking_id_key PRIMARY KEY,
	seeking VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO seekings
(
	seeking
)
VALUES
('single male'),
('single female'),
('same profession'),
('employed'),
('student'),
('retired'),
('over 50'),
('under 25'),
('under 50');

CREATE TABLE my_contacts (
	contact_id BIGSERIAL CONSTRAINT contact_id_key PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,		
	phone VARCHAR(10) UNIQUE NOT NULL,
	email VARCHAR(30) UNIQUE NOT NULL,
	gender CHAR(1) NOT NULL,
	birthday date NOT NULL,
	zip_code CHAR(4) REFERENCES zip_codes(zip_code) ON DELETE CASCADE,
	status_id bigint REFERENCES statuses(status_id) ON DELETE CASCADE,
	prof_id bigint REFERENCES professions(prof_id) ON DELETE CASCADE
);

INSERT INTO my_contacts (
	first_name,	
	last_name,	
	phone,
	email,
	gender,
	birthday,
	zip_code,
	status_id,
	prof_id
) VALUES 
	('Tom','Smith','0780615009','tom@gmail.com', 'F',  '1973-09-29', '7103',1,1), 
    ('Gugu','Ndaba','0780615012','gugu@gmail.com', 'F', '1941-10-26', NULL,2,2), -- NULL to showcase purpose of LEFT JOIN
    ('Jo','Nala','0780615078','jo@gmail.com', 'M', '1986-07-24', '1911',1,3),
    ('Mary','Smith','0610615009','mary@gmail.com', 'F', '1993-09-05', '0699',2,4),
    ('Kyle','Koo','0710615009','kyle@gmail.com', 'M', '1997-03-04', '5605',2,1),
    ('Sizwe','Nchabe','0840615099','sizwe@gmail.com', 'M', '1984-01-012', '8300',1,3),
    ('Liz','Sun','0830777009','liz@gmail.com', 'F', '1991-11-11', '1447',1,2),
	('William', 'Ziegler', '0126356554', 'williamaziegler@gmail.com', 'M', '1961-10-24', '2735', 1,5),
	('Jeffrey', 'Reynolds', '0836591325', 'jefferymreynolds@gmail.com', 'M', '1974-01-17', '5200', 2,6),
	('Alberto', 'Mooney', '0829729524', 'albertovmooney@yahoo.com', 'M', '1982-05-22', '4000', 1,3),
	('Josephine', 'Montgomery', '0839939200', 'josiemont@gmail.com', 'F', '1992-08-20', '1447', 1,2),
	('Henrietta', 'Reddington', '0842622947', 'henrietred@hotmail.com', 'F', '1981-06-19', '0699', NULL, 7), -- NULL to showcase purpose of LEFT JOIN
	('Linda', 'Lara', '0838160425', 'lindaglara@gmail.com', 'F', '1964-07-09', '2000', 1, 6),
	('Yesenia', 'Messier', '0846620036', 'yesseniamss@mweb.co.za', 'F', '1976-08-03', '0480', 2, 1),
	('Michael', 'Morrison', '0848741216', 'michaelmorris@outlook.com', 'M', '1988-12-12', '1200', 1, 8),
	('George', 'Norris', '0857378812', 'geo12norris@gmail.com', 'M', '1982-12-04', '5605', 2, 3),
	('Katrina', 'Appel', '0825496538', 'katyappel@aol.com', 'F', '1977-11-18', '2735', 1, 4);
---------------------------------

CREATE TABLE contact_seeking
(
	contact_id BIGINT REFERENCES my_contacts(contact_id) ON DELETE CASCADE,
	seeking_id BIGINT REFERENCES seekings(seeking_id) ON DELETE CASCADE
);

INSERT INTO contact_seeking
(contact_id, seeking_id)
VALUES
(1, 1),
(1, 3),
(1, 7),
(2, 1),
(2, 8),
(3, 2),
(3, 3),
(3, 7),
(4, 1),
(4, 5),
(4, 9),
(5, 2),
(5, 3),
(5, 7),
(6, 2),
(6, 3),
(6, 8),
(7, 1),
(7, 6),
(7, 7),
(8, 1),
(8, 3),
(8, 7),
(9, 1),
(9, 8),
(10, 2),
(10, 3),
(10, 7),
(11, 1),
(11, 5),
(11, 9),
(12, 2),
(12, 3),
(12, 7),
(13, 2),
(13, 3),
(13, 8),
(14, 1),
(14, 6),
(14, 7),
(15, 1),
(15, 5),
(15, 9),
(16, 2),
(16, 3),
(16, 7),
(17, 2),
(17, 3),
(17, 8);

CREATE TABLE interests
(
	interest_id BIGSERIAL CONSTRAINT interest_id_key PRIMARY KEY,
	interest VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO
interests (interest)
VALUES
('hiking'),
('reading'),
('biking'),
('cooking'),
('running'),
('cycling'),
('photography'),
('pottery'),
('swimming');

CREATE TABLE contact_interest
(
	contact_id BIGINT REFERENCES my_contacts(contact_id),
	interest_id BIGINT REFERENCES interests(interest_id)
);

INSERT INTO contact_interest
(contact_id, interest_id)
VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 5),
(2, 1),
(2, 4),
(2, 5),
(3, 1),
(3, 3),
(3, 2),
(4, 3),
(4, 4),
(4, 6),
(5, 2),
(5, 1),
(5, 6),
(6, 3),
(6, 4),
(6, 5),
(6, 6),
(7, 1),
(7, 7),
(7, 3),
(8, 9),
(8, 4),
(8, 1),
(9, 5),
(9, 7),
(9, 6),
(10, 1),
(10, 3),
(10, 9),
(10, 5),
(10, 4),
(10, 3),
(11, 2),
(11, 6),
(11, 9),
(12, 1),
(12, 3),
(12, 5),
(13, 8),
(13, 1),
(13, 5),
(14, 7),
(14, 1),
(14, 8),
(15, 1),
(15, 3),
(15, 6),
(16, 7),
(16, 9),
(16, 5),
(17, 6),
(17, 2),
(17, 4);

-- LEFT JOIN query that will display the profession, zip_code (postal_code, city and province), status, interests and seeking --

SELECT prof.profession, zc.zip_code, zc.city, zc.province, st.status, inte.interest, se.seeking
FROM my_contacts mc
LEFT JOIN professions prof
ON mc.prof_id = prof.prof_id
LEFT JOIN zip_codes zc
ON zc.zip_code = mc.zip_code
LEFT JOIN statuses st
ON st.status_id = mc.status_id
LEFT JOIN contact_seeking cs
ON cs.contact_id = mc.contact_id
LEFT JOIN seekings se
ON se.seeking_id = cs.seeking_id
LEFT JOIN contact_interest ci
ON ci.contact_id = mc.contact_id
LEFT JOIN interests inte
ON ci.interest_id = inte.interest_id;