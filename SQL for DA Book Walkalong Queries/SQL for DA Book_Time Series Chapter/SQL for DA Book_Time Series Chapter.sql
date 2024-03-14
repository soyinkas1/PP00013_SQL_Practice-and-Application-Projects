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

-- Extracting date parts
SELECT extract('day' from current_timestamp);
SELECT extract('month' from current_timestamp);
SELECT extract('year' from current_timestamp);
SELECT extract('hour' from current_timestamp);
SELECT extract('minute' from current_timestamp);
SELECT extract('second' from current_timestamp);
SELECT to_char(current_timestamp,'Day');
SELECT to_char(current_timestamp,'month');
SELECT to_char(current_timestamp,'Month');
SELECT to_char(current_timestamp,'MONTH');
SELECT date '2020-09-01' + time '03:00:00' as timestamp;
SELECT make_date(2020,08,6);
SELECT to_date(concat(2020,'-',09,'-',01), 'yyyy-mm-dd');
SELECT cast(concat(2020,'-',09,'-',01)as date);
SELECT age(date('2020-06-30'), date('2020-01-01'));
SELECT date_part('month',age(date('2020-06-30'), date('2020-01-01')));
SELECT date('2020-06-01') + interval '7 days' as date;
SELECT date('2020-01-01') + interval '8 months' as new_date;

--Time maths
SELECT time '05:00' + interval '3 hours' as new_time;
SELECT time '03:00' - time '01:00' as time_diff; -- we can substract times resulting in interval
SELECT time '05:00' * 2 as more_time; -- time unlike dates can be multiplied
SELECT interval '1 second' * 2000 as interval_multipled; -- Intervals can be multipled, resulting in time value
SELECT interval '1 day' * 45 as interval_multiplied;


 
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

-- Perform more complex comparisons e.g sales at women's clothings store and at men's clothing stores
SELECT
	sales_month,
	kind_of_business,
	sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 
						  'Women''s clothing stores')
;

-- Monthly data has patterns but is noisy, so we will use yearly aggregates
SELECT
	date_part('year', sales_month) as sales_year,
	kind_of_business,
	sum(sales) as sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 
						  'Women''s clothing stores')
GROUP BY 1,2
ORDER BY 1
;

-- Pivoting the data with aggregate functions combined with CASE statements
SELECT
	date_part('year', sales_month) as sales_year,
	sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales,
	sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
GROUP BY 1
ORDER BY 1
;

-- Find difference, ratios, and percent diffence between time series in the data set
SELECT
	sales_year,
	womens_sales - mens_sales as womens_minus_mens,
	mens_sales - womens_sales as mens_minus_womens
FROM
	(
	SELECT date_part('year', sales_month) as sales_year,
		sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales,
		sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales
	FROM retail_sales
	WHERE kind_of_business in ('Men''s clothing stores', 
							   'Women''s clothing stores')
							   and sales_month <= '2019-12-01'
	GROUP BY 1
	) as a
ORDER BY 1
;

-- Calculating the difference without the subquery
SELECT
	date_part('year', sales_month) as sales_year,
	sum(case when kind_of_business = 'Women''s clothing stores' then sales end)
		-
	sum(case when kind_of_business = 'Men''s clothing stores' then sales end) 
	as womens_minus_mens
FROM retail_sales
WHERE kind_of_business in ('Women''s clothing stores', 
						  'Men''s clothing stores')
						  and sales_month <= '2019-12-01'
GROUP BY 1
ORDER BY 1
;

-- Calculate the ratios of the categories using the men's sales as the baseline or denominator
SELECT 
	sales_year,
	ROUND(womens_sales / mens_sales, 2) as womens_times_of_mens
FROM
	(
		SELECT date_part('year', sales_month) as sales_year,
		sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales,
		sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales
		FROM retail_sales
		WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
			and sales_month <= '2019-12-01'
		GROUP BY 1
		ORDER BY 1
		
	) a
	;

-- Percentage difference between sales at women's and men's clothing stores
SELECT 
	sales_year,
	ROUND((womens_sales / mens_sales-1) * 100, 2) as womens_pct_of_mens
FROM
	(
		SELECT date_part('year', sales_month) as sales_year,
		sum(case when kind_of_business = 'Women''s clothing stores' then sales end) as womens_sales,
		sum(case when kind_of_business = 'Men''s clothing stores' then sales end) as mens_sales
		FROM retail_sales
		WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
			and sales_month <= '2019-12-01'
		GROUP BY 1
		ORDER BY 1
		
	) a
	;
	
-- Percent of Total Calculations
  -- Self-Joins
SELECT 
  	sales_month,
	kind_of_business,
	sales * 100 / total_sales as pct_total_sales
FROM 
	(
		SELECT a.sales_month, a.kind_of_business, a.sales, 
		sum(b.sales) as total_sales
		FROM retail_sales a
		JOIN retail_sales b on a.sales_month = b.sales_month
		and b.kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
		WHERE a.kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
		GROUP BY 1,2,3
		
	
	) aa
	ORDER BY 1
	;
	
	-- window function
SELECT
	sales_month, 
	kind_of_business,
	sales,
	sum(sales) OVER (PARTITION BY sales_month) as total_sales,
	sales * 100 / SUM(sales) OVER (PARTITION BY sales_month) as pct_total
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
;

-- Percent of total within a longer time period
	-- Self-Join method
SELECT 
	sales_month,
	kind_of_business,
	sales * 100 / yearly_sales as pct_yearly
FROM
(
	SELECT a.sales_month, a.kind_of_business, a.sales,
			sum(b.sales) as yearly_sales
	FROM retail_sales a
	JOIN retail_sales b ON
		date_part('year', a.sales_month) = date_part('year', b.sales_month)
		and a.kind_of_business = b.kind_of_business
		and b.kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
	WHERE a.kind_of_business in ('Men''s clothing stores')
	GROUP BY 1, 2, 3
) aa;
	
	-- window function method
SELECT 
	sales_month,
	kind_of_business,
	sales,
	SUM(sales) OVER (PARTITION BY date_part('year', sales_month), 
					 kind_of_business) as yearly_sales,
	sales * 100 / SUM(sales) OVER (PARTITION BY date_part('year', sales_month),
								  kind_of_business) as pct_yearly
FROM retail_sales
WHERE kind_of_business in ('Men''s clothing stores', 'Women''s clothing stores')
ORDER BY 2, 1
;

