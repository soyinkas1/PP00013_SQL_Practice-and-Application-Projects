-- EXPLORATORY DATA ANALYSIS
-- Confirm the number of samples in the database
SELECT COUNT(*) as number_of_samples FROM pdp_samples; /*10,127 */

-- Confirm the number of results in the database
SELECT COUNT(*) as number_of_results FROM pdp_results; /* 312,112 */

-- View top 5 rows of all columns in the samples table
SELECT * FROM pdp_samples
	LIMIT 5;
    
-- View the top 5 rows of all columns in the results table
SELECT * FROM pdp_results
	LIMIT 5;

-- Number of distinct samples that results was collected about
SELECT COUNT(DISTINCT SAMPLE_PK) as Samples_with_result FROM pdp_results /* 1535 */;

-- Country of origin of the distinct samples (country name not code)
SELECT DISTINCT SAMPLE_PK, `Country Name` as Country_Name, COUNTRY as Country_Code  FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`;
  
-- Distint countries from which samples was collected
SELECT DISTINCT `Country Name` as Country_Name, COUNTRY as Country_Code  FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`
    ORDER BY Country_Code DESC;
    
-- Count of Samples from each country from highest to lowest
SELECT `Country Name` as Country_Name, count(COUNTRY) as Number_of_Samples FROM 
	pdp_samples JOIN country_code on pdp_samples.COUNTRY = country_code.`Country Code`
		GROUP BY `Country Name`
			ORDER BY Number_of_Samples DESC;
            
-- Commodities tested and Lab used 
SELECT DISTINCT `COMMODITY NAME` , COUNT(*) AS Samples  FROM 
commodity_code JOIN pdp_results ON commodity_code.`Commodity Code`=pdp_results.COMMOD
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





