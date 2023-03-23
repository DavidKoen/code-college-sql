CREATE TABLE Employees (
	emp_id bigserial,
	first_name varchar(30) NOT NULL,
	surname varchar(30) NOT NULL,
	gender char(1) NOT NULL,
	address varchar(50) NOT NULL,
	email varchar(50) NOT NULL,
	depart_id bigint REFERENCES Department(depart_id),
	role_id bigint REFERENCES Roles(role_id),
	salary_id bigint REFERENCES Salaries(salary_id),
	overtime_id bigint REFERENCES Overtime_Hours(overtime_id),
	CONSTRAINT emp_key PRIMARY KEY (emp_id),
	CONSTRAINT email_unique UNIQUE (email)
);

CREATE TABLE Roles (
	role_id bigserial,
	role varchar(40) NOT NULL,
	CONSTRAINT role_key PRIMARY KEY (role_id),
	CONSTRAINT role_unique UNIQUE (role)
);

CREATE TABLE Department (
	depart_id bigserial,
	depart_name varchar(40) NOT NULL,
	depart_city varchar(40) NOT NULL,
	CONSTRAINT depart_key PRIMARY KEY (depart_id),
	CONSTRAINT dept_city_unique UNIQUE(depart_name, depart_city)
);

CREATE TABLE Salaries (
	salary_id bigserial,
	salary_pa money,
	CONSTRAINT salary_key PRIMARY KEY (salary_id),
	CONSTRAINT salary_pa_unique UNIQUE (salary_pa)
);

CREATE TABLE Overtime_Hours (
	overtime_id bigserial,
	overtime_hours int,
	CONSTRAINT overtime_key PRIMARY KEY (overtime_id),
	CONSTRAINT overtime_hours_unique UNIQUE (overtime_hours)
);

INSERT INTO Department (depart_name, depart_city)
VALUES
('Administration', 'Cape Town'),
('Marketing', 'Durban'),
('Human Resources', 'Benoni'),
('IT', 'Johannesburg'),
('IT', 'Cape Town'),
('Sales', 'Cape Town'),
('Accounting', 'Durban'),
('Management', 'Mokopane');

INSERT INTO Roles (role)
VALUES
('Chief Executive Officer'),
('Receptionist'),
('Marketing Agent'),
('Marketing Manager'),
('Human Resource Manager'),
('Senior Programmer'),
('Junior Programmer'),
('Sales Representative'),
('Accountant');

INSERT INTO Overtime_Hours (overtime_hours)
VALUES
(0),
(1),
(2),
(3),
(4);

INSERT INTO Salaries (salary_pa)
VALUES
(1100000),
(88000),
(180000),
(335000),
(389000),
(713000),
(330000),
(164000),
(283000);

INSERT INTO Employees (first_name, surname, gender, address, email, depart_id, role_id, salary_id, overtime_id)
VALUES
('Siyaya', 'Siwani', 'M', '1317 Market St', 'siysiwani@gmail.com', 8, 1, 1, 2),
('Andries', 'De Lange', 'M', '2261 Gemsbok St', 'andi2de@gmail.com', 1, 2, 2, 3),
('Phumzile', 'Gaika', 'M', '980 Church St', 'phugaika@gmail.com', 3, 5, 5, 1),
('Sofia', 'Peterson', 'F', '1321 Mosman Rd', 'sofpeterson@gmail.com', 7, 9, 9, 2),
('Murphy', 'Marcelyn', 'M', '2 Akasia Street', 'mmarcelyn@yahoo.com', 4, 6, 6, 4),
('Taylor', 'Ansley', 'F', '7 Oxford Street', 'taylorans@gmail.com', 2, 3, 3, 2),
('Bheka', 'Dlamini', 'M', '50 Roger Road', 'bhkdlamini@yahoo.com', NULL, NULL, 9, 1),
('Thandeka', 'Khumalo', 'F', '1773 Daffodil Drive', 'thandeka@hotmail.com', 5, 7, 7, 4),
('Slindile', 'Sithole', 'F', '12 Marconi Street', 'slindsithole@aol.com', 6, 8, 8, 1),
('Elizabeth', 'Smith', 'F', '1908 Nelson Mandela Drive', 'lizsmith@outlook.com', 1, 2, 2, 2),
('Jason', 'Miltenberger', 'M', '19 Prospect Street', 'jasonmilt@gmail.com', 2, 3, 3, 1),
('Amy', 'Sparks', 'F', '2 Akasia Street', 'amsprks@gmail.com', 1, 2, 2, 3),
('Wanda', 'Ibarra', 'F', '1 Albert Street', 'wandamagic@gmail.com', 3, 5, 5, 3),
('Nancy', 'Ruggles', 'F', '9 Glyn Street', 'nancyruggles@gmail.com', 3, 5, NULL, 3);

-- LEFT JOIN query that will display the department name, job title, salary figure and overtime hours worked. --

SELECT depart_name AS department_name, role AS job_title, salary_pa AS salary_figure, overtime_hours
FROM Employees emp
LEFT JOIN Department dep
ON emp.depart_id = dep.depart_id
LEFT JOIN Roles rol
ON emp.role_id = rol.role_id
LEFT JOIN Salaries sal
ON emp.salary_id = sal.salary_id
LEFT JOIN Overtime_Hours ove
ON emp.overtime_id = ove.overtime_id;