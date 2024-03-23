-- COPY `annotate code`
-- FROM 'D:\OneDrive\Documents\PERSONAL\PERSONAL DEVELOPMENT\DATA SCIENCE\SQL\PP00013_SQL CPD Projects\PDP Database SQL Analysis_CPD Projects_01\data\Annotate Code_PDP ReferenceTables 2021-17.csv' 
-- DELIMITER ',';

-- Explore all the tables in the database
-- 1. annotate code table
SELECT 
    *
FROM
    `annotate code`;
    
-- 2. commodity_type_code table
SELECT 
    *
FROM
    commodity_type_code;
    
-- 3. commodity_code table
SELECT 
    *
FROM
    commodity_code;

-- 4. concentration-iod_unit_code table
SELECT 
    *
FROM
    `concentration-lod_unit_code`;
-- 5. confirmation_method_code table
SELECT 
    *
FROM
    confirmation_method_code;
-- 6. country_code table
SELECT 
    *
FROM
    country_code;
-- 7. determinative_method_code table
SELECT 
    *
FROM
    determinative_method_code;
-- 8. distribution_type_code table
SELECT 
    *
FROM
    distribution_type_code;
-- 9 extract_code table
SELECT 
    *
FROM
    extract_code;
-- 10. lab_code table
SELECT 
    *
FROM
    lab_code;
-- 11. marketing_claim_code table
SELECT 
    *
FROM
    marketing_claim_code;
-- 12. mean_code table
SELECT 
    *
FROM
    mean_code;
-- 13. origin_code table
SELECT 
    *
FROM
    origin_code;
-- 14. quantitation_code table
SELECT 
    *
FROM
    quantitation_code;
-- 15. state_code
SELECT 
    *
FROM
    state_code;
-- 16. test_class_code
SELECT 
    *
FROM
    test_class_code;

-- Fetch the number of samples tested
SELECT 
    COUNT(*) AS number_of_samples
FROM
    pdp_samples;/*10,127 */
    
-- Fetch the number of distinct samples that results was collected 
SELECT 
    COUNT(DISTINCT SAMPLE_PK) AS Samples_with_result
FROM
    pdp_results; /*10,127 */

-- Fetch the number of results
SELECT 
    COUNT(*) AS number_of_results
FROM
    pdp_results;/* 2,737,933 */

-- Fetch the number of tests/results per sample
SELECT 
	s.SAMPLE_PK as Sample,
    `Commodity Name` AS Commodity_Name,
    COUNT(r.SAMPLE_PK) as results
FROM pdp_samples s
JOIN pdp_results r ON s.SAMPLE_PK = r.SAMPLE_PK
	JOIN commodity_code c ON s.COMMOD = c.`Commodity Code`
GROUP BY 1, 2;

-- fetch the top 5 rows of all columns in the samples table 
SELECT 
    *
FROM
    pdp_samples
LIMIT 5;
    
-- fetch the top 5 rows of all columns in the results table
SELECT 
    *
FROM
    pdp_results
LIMIT 5;

-- Fetch the distint countries from which samples was collected and number of samples
SELECT DISTINCT
    `Country Name` AS Country_Name,
    COUNTRY AS Country_Code,
    COUNT(SAMPLE_PK) AS Number_of_Samples
FROM
    pdp_samples
        JOIN
    country_code ON pdp_samples.COUNTRY = country_code.`Country Code`
GROUP BY 1 , 2
ORDER BY 3 DESC;
  
-- Fetch the commodity sample collected from each country
SELECT DISTINCT
    `Country Name` AS Country_Name,
    COUNTRY AS Country_Code,
    `Commodity Name` AS Commodity
FROM
    pdp_samples
        LEFT JOIN
    country_code ON pdp_samples.COUNTRY = country_code.`Country Code`
        JOIN
    commodity_code ON pdp_samples.COMMOD = commodity_code.`Commodity Code`
ORDER BY 1;

-- Fetch the total number of distinct countries samples was gotten from
SELECT 
    COUNT(DISTINCT `Country Name`) AS Number_of_Countries
FROM
    pdp_samples
        JOIN
    country_code ON pdp_samples.COUNTRY = country_code.`Country Code`
        JOIN
    pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK;
 
-- Fetch the commodity results collect from each country
SELECT DISTINCT
    `Country Name` AS Country_Name,
    COUNTRY AS Country_Code,
    `Commodity Name` AS Commodity
FROM
    pdp_samples
        LEFT JOIN
    country_code ON pdp_samples.COUNTRY = country_code.`Country Code`
        JOIN
    pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK
        JOIN
    commodity_code ON pdp_results.COMMOD = commodity_code.`Commodity Code`
ORDER BY Country_Code;
    
-- Count of results from each country from highest to lowest
SELECT 
    `Country Name` AS Country_Name,
    COUNT(COUNTRY) AS Number_of_Results
FROM
    pdp_samples
        JOIN
    country_code ON pdp_samples.COUNTRY = country_code.`Country Code`
        JOIN
    pdp_results ON pdp_samples.SAMPLE_PK = pdp_results.SAMPLE_PK
GROUP BY `Country Name`
ORDER BY Number_of_Results DESC;

-- Each Commodity with number of test results 
SELECT DISTINCT
    `COMMODITY NAME`, 
    COUNT(*) AS Samples
FROM
    pdp_results
        LEFT JOIN
    commodity_code ON commodity_code.`Commodity Code` = pdp_results.COMMOD
GROUP BY `COMMODITY NAME`
ORDER BY Samples DESC;
        
-- Commodities samples not in test results 
SELECT DISTINCT
    `COMMODITY NAME`, COUNT(*) AS Samples
FROM
    pdp_samples p
        LEFT JOIN
    commodity_code c ON c.`Commodity Code` = p.COMMOD
        LEFT JOIN
    pdp_results r ON c.`Commodity Code` = r.COMMOD
WHERE
    c.`Commodity Code` NOT IN (r.COMMOD)
GROUP BY `COMMODITY NAME`
ORDER BY Samples DESC;
    
-- Fetch the Concentration/LOD units to confirm if uniform
SELECT DISTINCT
    `CONUNIT`
FROM
    pdp_results;

-- Fetch the top 100 samples with the highest Limit of Detection (LOD)
SELECT DISTINCT
    R.SAMPLE_PK, C.`Commodity Name`, R.LOD AS LOD
FROM
    pdp_results R
        LEFT JOIN
    commodity_code C ON R.COMMOD = C.`Commodity Code`
ORDER BY LOD DESC
LIMIT 100;
    
-- Which pesticide has the highest Limit of Detection (LOD) per commodity
SELECT DISTINCT
    C.`Commodity Name`, P.`Pesticide Name`, T.LOD
FROM
    pdp_results T
        LEFT JOIN
    commodity_code C ON T.COMMOD = C.`Commodity Code`
        JOIN
    pest_code P ON T.PESTCODE = P.`Pest Code`
ORDER BY C.`Commodity Name` ASC , T.LOD DESC;

-- Fetch the average Limit of Detection (LOD) per pesticide per commodity
SELECT 
    C.`Commodity Name`,
    P.`Pesticide Name`,
    ROUND(AVG(T.LOD), 4) AS Average_LOD
FROM
    pdp_results T
        LEFT JOIN
    commodity_code C ON T.COMMOD = C.`Commodity Code`
        JOIN
    pest_code P ON T.PESTCODE = P.`Pest Code`
GROUP BY C.`Commodity Name` , P.`Pesticide Name`
ORDER BY C.`Commodity Name` , Average_LOD DESC;

-- Fetch the maximum Limit of Detection (LOD) per pesticide per commodity
SELECT 
    C.`Commodity Name`,
    P.`Pesticide Name`,
    ROUND(MAX(T.LOD), 4) AS Maximum_LOD
FROM
    pdp_results T
        LEFT JOIN
    commodity_code C ON T.COMMOD = C.`Commodity Code`
        JOIN
    pest_code P ON T.PESTCODE = P.`Pest Code`
GROUP BY C.`Commodity Name` , P.`Pesticide Name`
ORDER BY C.`Commodity Name` , Maximum_LOD DESC;

-- Fetch how many test that did not detect any residue
SELECT 
    count(SAMPLE_PK)
FROM
    pdp_results
WHERE
    MEAN = 'NP' OR MEAN = 'ND'
;

-- Fetch test that detected pesticide residue
SELECT 
   count(SAMPLE_PK)
FROM
    pdp_results
WHERE
    MEAN NOT IN ('ND' , 'NP')
;

-- Fetch number of tests that detected pesticide residue for each commodity
SELECT 
    C.`Commodity Name`, 
    COUNT(SAMPLE_PK) AS number_of_detection,
    SUM(COUNT(SAMPLE_PK)) OVER (ORDER BY C.`Commodity Name`) AS running_total_Detection
FROM
    pdp_results T
        JOIN
    commodity_code C ON T.COMMOD = C.`Commodity Code`
WHERE
    MEAN NOT IN ('ND' , 'NP')
GROUP BY 1 
ORDER BY 1, 2 
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
SELECT DISTINCT
    `Lab Agency Name` AS Lab_Name, `Lab City/State` AS Location
FROM
    pdp_results T
        JOIN
    lab_code L ON T.LAB = L.`Lab Code`;
  
-- Fetch the commodity results from each Lab with their location
SELECT DISTINCT
    `Lab Agency Name` AS lab_Name,
    `Lab City/State` AS Location,
    `Commodity Name` AS Commodity
FROM
    pdp_results
        LEFT JOIN
    commodity_code ON pdp_results.COMMOD = commodity_code.`Commodity Code`
        JOIN
    lab_code L ON pdp_results.LAB = L.`Lab Code`
ORDER BY lab_name; 
    
-- Count of results from each lab from highest to lowest
SELECT DISTINCT 
	`Lab Agency Name` as lab_Name, 
    `Lab City/State` as Location, 
    `Commodity Name` as Commodity, 
    COUNT(COMMOD) OVER (PARTITION BY `Lab Code`) as Total_Per_Lab,
    COUNT(COMMOD) OVER (PARTITION BY COMMOD) as Total_Per_Commodity
FROM pdp_results LEFT JOIN commodity_code ON pdp_results.COMMOD = commodity_code.`Commodity Code` 
	JOIN lab_code L on pdp_results.LAB = L.`Lab Code`
		ORDER BY lab_name, Total_Per_Commodity DESC ;
            
-- Fetch the commodity type of each commodity with test results
SELECT 
    `Commodity Name`,
    COMMTYPE AS Commodity_Type,
    COUNT(`Commodity Name`) AS Number_of_Test
FROM
    pdp_results p
        LEFT JOIN
    commodity_code c ON p.COMMOD = c.`Commodity Code`
GROUP BY 1 , 2
ORDER BY 2 , 3 DESC
;

-- Fetch the most common confirmation methods used by each lab
SELECT DISTINCT
    `Lab Agency Name` AS lab_Name,
    `Lab City/State` AS Location,
    `Confirmation Method`,
    COUNT(`Confirmation Method`) AS Amount_of_tests
FROM
    pdp_results p
        LEFT JOIN
    commodity_code ON p.COMMOD = commodity_code.`Commodity Code`
        LEFT JOIN
    lab_code L ON p.LAB = L.`Lab Code`
        LEFT JOIN
    confirmation_method_code m ON p.CONFMETHOD = m.`ConfMethod Code`
WHERE
    CONFMETHOD IS NOT NULL
        AND CONFMETHOD2 IS NOT NULL
GROUP BY 1 , 2 , 3
ORDER BY 1 , 4 DESC;

-- fetch the most common determinative methods used by each lab
SELECT DISTINCT
    `Lab Agency Name` AS lab_Name,
    `Lab City/State` AS Location,
    `Determinative Method`,
    COUNT(`Determinative Method`) AS Amount_of_tests
FROM
    pdp_results p
        LEFT JOIN
    commodity_code ON p.COMMOD = commodity_code.`Commodity Code`
        LEFT JOIN
    lab_code L ON p.LAB = L.`Lab Code`
        LEFT JOIN
    determinative_method_code d ON p.DETERMIN = d.`Determin Code`
WHERE
    DETERMIN IS NOT NULL
GROUP BY 1 , 2 , 3
ORDER BY 1 , 4 DESC;

-- Fetch the origin of each test sample
SELECT DISTINCT
    C.`Commodity Name`,
    `Origin of Sample`,
    COUNT(`Origin of Sample`) AS Number_of_Samples
FROM
    pdp_samples R
        LEFT JOIN
    commodity_code C ON R.COMMOD = C.`Commodity Code`
        LEFT JOIN
    origin_code o ON o.`Origin Code` = R.ORIGIN
GROUP BY 1 , 2
;
-- Fetch samples without COUNTRY
SELECT 
    *
FROM
    pdp_samples
WHERE
    COUNTRY IN ('');







