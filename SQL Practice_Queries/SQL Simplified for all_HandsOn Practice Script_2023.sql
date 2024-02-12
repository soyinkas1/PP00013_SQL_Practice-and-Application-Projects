-- CREATE 'department' TABLE
CREATE TABLE department(
	did varchar(20),
    name varchar(20) NOT NULL,
    CONSTRAINT PK_DEPT PRIMARY KEY(did)
    );
    
-- INSERT DATA
INSERT INTO department VALUES
('D1', 'Management'),
('D2', 'IT'),
('D3', 'Sales'),
('D4', 'HR');

-- CREATE 'employee' TABLE
CREATE TABLE employee (
eid int,
name varchar(20) UNIQUE,
join_date date NOT NULL,
dep char(2),
salary int,
manager int,
CONSTRAINT PK_ID PRIMARY KEY(eid),
CONSTRAINT FK_ID FOREIGN KEY(dep)
REFERENCES department(did)
);

-- INSERT VALUES INTO employee TABLE
INSERT INTO employee VALUES
(101, 'David', '2009-07-14', 'D1', 50000, NULL ),
(102, 'Sam', '2010-06-24', 'D1', 40000, 101),
(103, 'Alicia', '2011-05-11', 'D2', 30000, 102),
(104, 'Alex', '2012-04-15', 'D2', 20000, 102),
(105, 'Robbi', '2013-08-14', 'D2', 20000, 102),
(106, 'Jack', '2014-09-19', 'D3', 8000, 101),
(107, 'Tom', '2015-11-12', NULL, 5000, 116),
(108, 'Lily', '2016-07-28', 'D3', 1000, 106);
SELECT * FROM employee;

-- CREATE 'project' TABLE
CREATE TABLE project(
person varchar(20),
proj_name varchar(20),
job_description varchar(100)
);

-- INSERT VALUES INTO 'project' TABLE
INSERT INTO project VALUES
('David', 'Ecommerce', 'generate and manage sales via online channels'),
('Sam', 'Inventory', 'manage location and pricing of inventory'),
('Alicia', 'Inventory', 'manage products that are in storage or transit'),
('Ryan', 'Ecommerce', 'advertsing and marketing efforts of a company'),
('Ellen', 'Inventory', 'manage overall operations and help employees');
SELECT * FROM project;

-- CREATE 'sale' TABLE
CREATE TABLE sale(
category varchar(20),
brand varchar(20),
name varchar(50) NOT NULL,
quantity int CHECK(quantity >= 0),
price float NOT NULL,
stock boolean,
CONSTRAINT PK_CITY PRIMARY KEY(name)
);

-- INSERT VALUES INTO sale TABLE
INSERT INTO sale VALUES
('Phone', 'Apple', 'iPhone 13', 4, 1300.0, False),
('Phone', 'Apple', 'iPhone 12', 6, 1100.0, True),
('Phone', 'Samsung', 'Galaxy Note 20', 5, 1200.0, False),
('Phone', 'Samsung', 'Galaxy S21', 4, 1100.0, False),
('Laptop', 'Apple', 'MacBook Pro 13', 3, 2000.0, True),
('Laptop', 'Apple', 'MacBook Air', 2, 1200.0, True),
('Laptop', 'Dell', 'XPS 13', 1, 2000.0, False),
('Tablet', 'Apple', 'iPad 7th gen', 3, 560.0, False),
('Tablet', 'Samsung', 'Galaxy Tab A7', 2, 220.0, True);
SELECT * FROM sale;

-- DUPLICATE employee TABLE WITH DATA
CREATE TABLE Backup AS
SELECT * FROM employee;

-- DUPLICATE employee TABLE WITHOUT DATA
CREATE TABLE Replica AS 
SELECT * FROM employee 
	WHERE 1=2;
SELECT * FROM Backup;
SELECT * FROM Replica;

-- UPDATE DATA
	-- update manager of Tom
UPDATE employee
	SET manager = 106
		WHERE name = 'Tom';
	-- update department and salary of Lily
UPDATE employee
	SET dep = 'D3', salary = 5000
		WHERE name = 'Lily';
        
-- DELETE DATA
	-- Delete Lily's record
DELETE FROM Backup
	WHERE name = 'Lily';
    -- Delete Alex and Robbi's Record
DELETE FROM Backup
	WHERE name IN ('Alex', 'Robbi');
	-- Delete all records OR Truncate the whole backup data
DELETE FROM Backup;
TRUNCATE TABLE Backup;
SELECT * FROM Backup;

-- DROP TABLE
DROP TABLE Backup;

-- ALTER TABLE
	-- Rename sale TABLE to sales
ALTER TABLE sale
	RENAME TO Sales;
    -- Rename dep COLUMN to dept
ALTER TABLE employee
	RENAME COLUMN dep TO dept;
    -- Alter dept column data type
-- ALTER TABLE employee
-- 	MODIFY COLUMN dept varchar(2);
	-- ADD NEW COLUMN GENDER
ALTER TABLE employee
	ADD COLUMN gender varchar(20);
    -- ADD CONSTRAINT GEN TO gender COLUMN
ALTER TABLE employee
	ADD CONSTRAINT GEN
		CHECK (gender IN ('M', 'F'));
	-- REMOVE GEN CONSTRAINT
ALTER TABLE employee
DROP CONSTRAINT GEN;
	-- REMOVE gender COLUMN
ALTER TABLE employee
	DROP COLUMN gender;
    
-- DCL COMMANDS
-- GRANT SINGLE PRIVILEDGE
GRANT SELECT ON employee TO 'Test';
-- GRANT MULTIPLE PRIVILEGE
GRANT INSERT, UPDATE ON employee TO 'Test';
-- GRANT ALL PRIVILEGES
GRANT ALL ON employee TO 'Test';
-- REVOKE SINGLE PRIVILEGE
REVOKE SELECT ON employee FROM 'Test';
-- REVOKE MULTIPLE PRIVILEGE
REVOKE INSERT, UPDATE ON employee FROM 'Test'@'localhost';
-- REVOKE ALL PRIVILEGES
REVOKE ALL, GRANT OPTION FROM 'Test';
-- To use this REVOKE syntax, you must have the global CREATE USER privilege, or the UPDATE privilege for the mysql system schema.

-- TCL COMMMANDS
-- BEGIN AND COMMIT TRANSACTION
BEGIN;
DELETE FROM employee
	WHERE name = 'Lily';
COMMIT;
-- ROLLBACK TO LAST COMMIT
ROLLBACK;
-- SAVEPOINT TRANSACTION
SAVEPOINT point;
-- ROLLBACK TO SAVEPOINT
ROLLBACK TO SAVEPOINT point;

-- OPERATORS
-- Fetch three employees who earn more than 10000
-- Comparison (= , >, <, <=, >=, !=), ORDER BY and LIMIT
SELECT name, salary 
	FROM employee
		WHERE salary > 10000
			ORDER BY name	
				LIMIT 3;

-- Fetch products in stock with price range 1000 to 1500
-- BETWEEN, ORDER BY (ASC, DESC), AND, IN 
SELECT name, brand, price, stock
	FROM sales
		WHERE price BETWEEN 1000 AND 1500
			AND stock IN ('1')
				ORDER BY name DESC;
-- Fetch employees not in department D2 and name either starts with 'J' or not end with 'y'
-- LIKE, STARTING, LIKE-ENDING, NOT IN , NOT LIKE, OR
SELECT name, dept
	FROM employee
		WHERE dept NOT IN ('D2')
			AND (name LIKE ('J%') OR name NOT LIKE('%y'));
            
-- DATE FUNCTIONS

-- Fetch employee data who join on April
-- EXTRACT YEAR, MONTH, DAY, HOUR, MINUTE, SECOND FROM date
SELECT * 
	FROM employee
		WHERE EXTRACT(MONTH FROM join_date) = '04';

-- Fetch today's date
-- TO_CHAR (DATE_FORMAT) -convert number & date to character string
-- SELECT TO_CHAR(CURRENT_DATE, 'Month dd, yyyy')
-- as todays_date; -ORACLE SQL VERSION
SELECT DATE_FORMAT(CURRENT_DATE(), '%M %d, %Y') as Todays_Date;

-- DISTICNCT
-- Fetch all brands in sales table
SELECT DISTINCT brand
	FROM sales;

-- CASE STATEMENT
-- Categorize employees based on their salary
SELECT name, salary,
	CASE WHEN salary >= 30000 THEN 'High'
		WHEN salary BETWEEN 10000 AND 30000 THEN 'Mid'
        WHEN salary <10000 THEN 'Low'
	END as salary_range
    FROM employee
		ORDER BY 2 DESC;
        
-- SET
-- Fetch employees from Management & involve on projects
(SELECT name 
	FROM employee
		WHERE dept ='D1')
			UNION
(SELECT person 
	FROM project);

-- Fetch only employees who work on projects 
-- There is no INTERSECT in MYSQL so stimulate with IN or EXIST
SELECT employee.name
	FROM employee
		WHERE employee.name IN 
        (SELECT person FROM project);
-- Fetch person who is not an employee but work on project
-- there is no EXCEPT in MySQL so use NOT IN 
SELECT person
	FROM project
		WHERE person NOT IN(
        SELECT name FROM employee);
        
-- JOIN

-- INNER JOIN
-- Fetch all IT employees name wrt their department
SELECT E.name, D.name as department
	FROM (employee as E
    INNER JOIN department D ON E.dept = D.did)
		WHERE D.name ='IT';

SELECT E.name, D.name as department
FROM employee as E
INNER JOIN department  as D
ON E.dept = D.did
WHERE D.name = 'IT';

-- LEFT JOIN
-- Fetch all project name with employee name
SELECT E.name, P.proj_name
	FROM project as P 
		LEFT JOIN employee as E
        ON E.name = P.person;
        
-- RIGHT OUTER JOIN
-- Fetch all employee name wrt projects they are working on
SELECT E.name, P.proj_name
	FROM project as P
		RIGHT JOIN employee as E
        ON E.name = P.person;

-- FULL OUTER JOIN (LEFT JOIN UNION RIGHT JOIN)
-- Fetch all employees with their correlated projects
-- No FULL JOIN in MySQL so used LEFT JOIN UNION RIGHT JOIN
SELECT E.name, P.proj_name
	FROM (project as P
		LEFT JOIN employee as E
		ON E.name = P.proj_name)
    UNION
SELECT E.name, P.proj_name
	FROM (project as P
		RIGHT JOIN employee as E
		ON E.name = P.proj_name);

-- CROSS JOIN
-- Give 500 bonus to all employees
-- CREATE 'advance' TABLE
CREATE TABLE advance(
bonus INT );
INSERT INTO advance VALUES(500);
SELECT * FROM advance;
SELECT E.name, E.salary, A.bonus, (E.salary + A.bonus) as Net_Salary
	FROM employee as E 
		CROSS JOIN advance as A;

-- SELF JOIN
-- Fetch all employee name with their manager
SELECT E.name, M.name as Manager
	FROM employee as M
		JOIN employee as E
        ON M.eid = E.manager;
        
-- NATURAL JOIN
-- SQL will decide what is the JOIN condition by itself
--    -If there is no matching column name between two tables it will perform CROSS JOIN.
--    -If there is one common column between two tables It will perform INNER JOIN.
--    -If there is more than one common column between two tables It will perform INNER JOIN with ALL common columns.
  







    




