-- create the table
DROP table if exists retail_sales;
CREATE table retail_sales
(
sales_month date
,naics_code varchar
,kind_of_business varchar
,reason_for_null varchar
,sales decimal
)
;

-- populate the table with data from the csv file. Download the file locally before completing this step
COPY retail_sales 
FROM 'D:\OneDrive\Documents\PERSONAL\PERSONAL DEVELOPMENT\DATA SCIENCE\SQL\PP00013_SQL CPD Projects\SQL for DA Book_Time Series Chapter\data\us_retail_sales.csv' -- change to the location you saved the csv file
DELIMITER ','
CSV HEADER
;
SELECT * FROM retail_sales;

-- Trend of total retail and food services sales in the US

SELECT
	sales_month,
	sales
FROM retail_sales
WHERE kind_of_business = 'Retail and food services sales, total'
;

-- Transform and aggregate at the yearly level to remove noise and gain better understanding
SELECT
	date_part('year', sales_month) as sales_year,
	sum(sales) as sales
FROM retail_sales
WHERE kind_of_business = 'Retail and food services sales, total'
GROUP BY 1
ORDER BY sales_year
;

-- Compare the yearly sales trend for a few categories that are associated with leisure activities
SELECT
	date_part('year',sales_month) as sales_year,
	kind_of_business,
	sum(sales) as sales
FROM retail_sales
WHERE kind_of_business in ('Book stores', 'Sporting goods stores', 'Hobby, toy, and game stores')
GROUP BY 1, 2
ORDER BY 1
;