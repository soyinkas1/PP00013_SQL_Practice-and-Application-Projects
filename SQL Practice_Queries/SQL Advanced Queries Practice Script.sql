-- This script is for practicing advanced SQL queries

-- Window Functions
-- ROW_NUMBER() for Ranking
-- Example: Ranking employees by salaey within each department
SELECT
	name, 
    salary,
    dept,
ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) as salary_rank
FROM sql_advanced_query_samples_database_dataset.sql_simplified_employee;

-- RANK() for Ranking
-- Example: Ranking employees by salary within each department
SELECT
	name, 
    salary,
    dept,
RANK() OVER (PARTITION BY dept ORDER BY salary DESC) as salary_rank
FROM sql_advanced_query_samples_database_dataset.sql_simplified_employee;
-- NB: rank will give same values same rank number 

-- Recursive CTE for Hierarchical data
-- Example: Selecting all employees in a hierarchial manner
	-- Create a column for employee name
	ALTER TABLE classic_employees
    ADD COLUMN employeeName VARCHAR(100);
    -- Concat the full name
    UPDATE classic_employees
    SET employeeName = concat(firstName, "", lastName);
SELECT * FROM classic_employees;

WITH RECURSIVE EmployeeHierarchy as (
	SELECT employeeNumber, employeeName, reportsTo
    FROM classic_employees
    WHERE reportsTo = NULL
    
UNION ALL

	SELECT e.employeeNumber, e.employeeName, e.reportsTo
    FROM classic_employees e
    JOIN EmployeeHierarchy eh ON e.reportsTo = eh.employeeNumber
    )
SELECT * FROM EmployeeHierarchy;
SELECT * FROM classic_employees;

-- Example: Calculating the average salary difference from department average
WITH DepartmentAvg as (
	SELECT dept, AVG(salary) as avg_salary
    FROM sql_simplified_employee
    GROUP BY dept
	)
SELECT e.name, e.dept, e.salary, ROUND(d.avg_salary,2), ROUND((e.salary - d.avg_salary),2) as salary_diff
FROM sql_simplified_employee e 
JOIN DepartmentAvg d on e.dept = d.dept;

-- Stored Procedures
-- Example: Creating a stored procedure to retrieve employee details 
DELIMITER //
CREATE PROCEDURE GetEmployeeDetail (IN Number INT)
BEGIN
	SELECT * FROM classic_employees WHERE employeeNumber = Number;
END //
DELIMITER ;
-- Executing a stored procedure
CALL GetEmployeeDetail(1002);

-- Advanced aggregation -GROUP CONCAT
SELECT dept, GROUP_CONCAT(name ORDER BY name ASC) AS employee_list
FROM sql_simplified_employee
GROUP BY 1;

-- ROLLUP for Hierarchical Aggregation
-- Example: Aggregating sales by region and month with ROLLUP
-- SELECT region, MONTH(order_date) as MONTH, SUM(total_sales) as monthly_sales
-- FROM sales
-- GROUP BY ROLLUP(region, MONTH(order_date));



    