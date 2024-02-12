-- PROBLEM STATEMENT
  -- 1. How tolerable are the pesticide residues from food commodities in the US?
  -- 2. Which commodities pose a higher risk and why?
  
-- EXPLORATORY DATA ANALYSIS

-- Confirm the number of samples in the database
SELECT 
	COUNT(*) as number_of_samples 
FROM pdp_samples; /*10,127 */

-- Confirm the number of results in the database
SELECT COUNT(*) as number_of_results FROM pdp_results; /* 312,112 */

-- fetch the top 5 rows of all columns in the samples table
SELECT * FROM pdp_samples
	LIMIT 5;
    
-- fetch the top 5 rows of all columns in the results table
SELECT * FROM pdp_results
	LIMIT 5;

-- Fetch the number of distinct samples that results was collected 
SELECT COUNT(DISTINCT SAMPLE_PK) as Samples_with_result FROM pdp_results /* 1535 */;

-- Fetch the distint countries from which samples was collected and number of samples
SELECT DISTINCT`Country Name` as Country_Name, COUNTRY as Country_Code  FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`;
  
-- Fetch the commodity sample collect from each country
SELECT DISTINCT `Country Name` as Country_Name, COUNTRY as Country_Code, `Commodity Name` as Commodity 
FROM pdp_samples LEFT JOIN country_code ON pdp_samples.COUNTRY = country_code.`Country Code` 
    JOIN commodity_code 
    ON pdp_samples.COMMOD = commodity_code.`Commodity Code`
    ORDER BY Country_Name ; 
    
-- Count of Samples from each country from highest to lowest
SELECT `Country Name` as Country_Name, count(COUNTRY) as Number_of_Samples FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`
		GROUP BY `Country Name`
			ORDER BY Number_of_Samples DESC;

-- Fetch the total number of distinct countries samples was gotten from
SELECT  count(DISTINCT `Country Name`) as Number_of_Countries  FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`
    JOIN pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK;

-- Fetch the distint countries from which test results was gotten
SELECT DISTINCT `Country Name` as Country_Name  FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`
    JOIN pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK;
  
-- Fetch the commodity results collect from each country
SELECT DISTINCT `Country Name` as Country_Name, COUNTRY as Country_Code, `Commodity Name` as Commodity 
FROM pdp_samples LEFT JOIN country_code ON pdp_samples.COUNTRY = country_code.`Country Code` 
	JOIN pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK
		JOIN commodity_code ON pdp_results.COMMOD = commodity_code.`Commodity Code`
			ORDER BY Country_Code ; 
    
-- Count of results from each country from highest to lowest
SELECT `Country Name` as Country_Name, count(COUNTRY) as Number_of_Results FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`
    JOIN pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK
		GROUP BY `Country Name`
			ORDER BY Number_of_Results DESC;

-- Commodities with test results 
SELECT DISTINCT `COMMODITY NAME` , COUNT(*) AS Samples  FROM 
pdp_results LEFT JOIN commodity_code ON commodity_code.`Commodity Code`= pdp_results.COMMOD
	GROUP BY `COMMODITY NAME`
		ORDER BY Samples DESC;
        
-- Commodities samples not in test results 
SELECT DISTINCT `COMMODITY NAME` , COUNT(*) AS Samples  FROM 
pdp_samples LEFT JOIN commodity_code ON commodity_code.`Commodity Code`= pdp_samples.COMMOD
	WHERE `COMMODITY NAME` NOT IN ('Broccoli', 'Blueberries, Cultivated', 'Butter')
    GROUP BY `COMMODITY NAME`
	ORDER BY Samples DESC;
    
-- View all the tables
-- 1. annotate code table
SELECT * FROM `annotate code`;
-- 2. commodity_code table
SELECT * FROM commodity_code;
-- 3. commodity_type_code table
SELECT * FROM commodity_type_code;
-- 4. concentration-iod_unit_code table
SELECT * FROM `concentration-lod_unit_code`;
-- 5. confirmation_method_code table
SELECT * FROM confirmation_method_code;
-- 6. country_code table
SELECT * FROM country_code;
-- 7. determinative_method_code table
SELECT * FROM determinative_method_code;
-- 8. distribution_type_code table
SELECT * FROM distribution_type_code;
-- 9 extract_code table
SELECT * FROM extract_code;
-- 10. lab_code table
SELECT * FROM lab_code;
-- 11. marketing_claim_code table
SELECT * FROM marketing_claim_code;
-- 12. mean_code table
SELECT * FROM mean_code;
-- 13. origin_code table
SELECT * FROM origin_code;
-- 14. quantitation_code table
SELECT * FROM quantitation_code;
-- 15. state_code
SELECT * FROM state_code;
-- 16. test_class_code
SELECT * FROM test_class_code;

-- Fetch the Concentration/LOD units to confirm if uniform
SELECT DISTINCT `CONUNIT` 
FROM pdp_results;

-- Fetch the top 10 samples with the highest Limit of Detection (LOD)
SELECT DISTINCT R.SAMPLE_PK, C.`Commodity Name`, R.LOD as LOD FROM
	pdp_results R LEFT JOIN commodity_code C ON R.COMMOD = C.`Commodity Code`
    ORDER BY LOD DESC
    LIMIT 100;
    
-- Which pesticide has the highest highest Limit of Detection (LOD) per commodity
SELECT DISTINCT C.`Commodity Name`, P.`Pesticide Name`,  T.LOD FROM
	pdp_results T LEFT JOIN commodity_code C ON T.COMMOD = C.`Commodity Code`
		JOIN pest_code P ON T.PESTCODE = P.`Pest Code`
        ORDER BY C.`Commodity Name` ASC, T.LOD DESC;

-- Fetch the average Limit of Detection (LOD) per pesticide per commodity
SELECT C.`Commodity Name`, P.`Pesticide Name`,  ROUND(AVG(T.LOD),4) as Average_LOD FROM
	pdp_results T LEFT JOIN commodity_code C ON T.COMMOD = C.`Commodity Code`
		JOIN pest_code P ON T.PESTCODE = P.`Pest Code`
        GROUP BY C.`Commodity Name`, P.`Pesticide Name`
        ORDER BY C.`Commodity Name`, Average_LOD DESC;

-- Fetch the maximum Limit of Detection (LOD) per pesticide per commodity
SELECT C.`Commodity Name`, P.`Pesticide Name`,  ROUND(MAX(T.LOD),4) as Maximum_LOD FROM
	pdp_results T LEFT JOIN commodity_code C ON T.COMMOD = C.`Commodity Code`
		JOIN pest_code P ON T.PESTCODE = P.`Pest Code`
        GROUP BY C.`Commodity Name`, P.`Pesticide Name`
        ORDER BY C.`Commodity Name`, Maximum_LOD DESC;

-- Fetch how many test that did not detect any residue
SELECT MEAN , SAMPLE_PK FROM
pdp_results
WHERE MEAN = 'NP' OR MEAN = 'ND'
-- WHERE MEAN IN ('ND' , 'NP') another way to get same results
;

-- Fetch test that detected pesticide residue
SELECT MEAN , SAMPLE_PK FROM
pdp_results
WHERE MEAN NOT IN ('ND', 'NP')
;

-- Fetch test that detected pesticide residue for each commodity
SELECT C.`Commodity Name`, count(SAMPLE_PK) as Number_of_Detection FROM
pdp_results T JOIN commodity_code C ON T.COMMOD = C.`Commodity Code`
WHERE MEAN NOT IN ('ND', 'NP')
GROUP BY C.`Commodity Name`
;

-- Calculate percentage of the results that detected pesticide residue per commodity
WITH detect as (
	SELECT C.`Commodity Name`, count(SAMPLE_PK) as Number_of_Detection 
	FROM
		pdp_results T JOIN commodity_code C ON T.COMMOD = C.`Commodity Code`
	WHERE MEAN NOT IN ('ND', 'NP')
	GROUP BY C.`Commodity Name`
)
SELECT 
	d.`Commodity Name`,
    f.Total_Tests,
	d.Number_of_Detection,
    ROUND((d.Number_of_Detection / f.Total_Tests) *100,2) as Percentage_Detected
FROM
	detect d JOIN (SELECT C.`Commodity Name`, 
							count(SAMPLE_PK) as Total_Tests 
                    FROM
						pdp_results T JOIN commodity_code C ON T.COMMOD = C.`Commodity Code`
					GROUP BY C.`Commodity Name`) as f 
                    ON f.`Commodity Name` = d.`Commodity Name`
                    ORDER BY Percentage_Detected DESC;

-- Fetch the distint Labs from which test results was gotten
SELECT DISTINCT `Lab Agency Name` as Lab_Name, `Lab City/State` as Location  FROM 
	pdp_results T JOIN lab_code L on T.LAB = L.`Lab Code`;
  
-- Fetch the commodity results from each Lab with their location
SELECT DISTINCT `Country Name` as Country_Name, COUNTRY as Country_Code, `Commodity Name` as Commodity 
FROM pdp_samples LEFT JOIN country_code ON pdp_samples.COUNTRY = country_code.`Country Code` 
	JOIN pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK
		JOIN commodity_code ON pdp_results.COMMOD = commodity_code.`Commodity Code`
			ORDER BY Country_Code ; 
    
-- Count of results from each lab from highest to lowest
SELECT `Country Name` as Country_Name, count(COUNTRY) as Number_of_Results FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`
    JOIN pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK
		GROUP BY `Country Name`
			ORDER BY Number_of_Results DESC;
            
-- Fetch the commodity type of each commodities with test results

-- Fetch the most common confirmation methods used by each lab

-- fetch the most common determinative methods used by each lab

-- Fetch the origin of each test sample

-- Fetch the first date and last date of test results 

-- SOME DATA CLEANING OPERATIONS

-- Remove unneeded columns in pdp_test

-- Remove samples without COUNTRY

-- Remove missing values in LOD







