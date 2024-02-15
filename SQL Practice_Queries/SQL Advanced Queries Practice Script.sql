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
-- Example: Ranking employees by salaey within each department
SELECT
	name, 
    salary,
    dept,
RANK() OVER (PARTITION BY dept ORDER BY salary DESC) as salary_rank
FROM sql_advanced_query_samples_database_dataset.sql_simplified_employee;
-- NB: rank will give same values same rank number 

