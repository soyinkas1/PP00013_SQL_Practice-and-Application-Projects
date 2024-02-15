-- Copy the tables from contoso database

CREATE TABLE `sql_advanced_query_samples_database_dataset`.contoso_channel
AS
SELECT * FROM contoso.channel;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.contoso_entity
AS
SELECT * FROM contoso.entity;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.contoso_factsales
AS
SELECT * FROM contoso.factsales;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.contoso_product
AS
SELECT * FROM contoso.product;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.contoso_productcategory
AS
SELECT * FROM contoso.productcategory;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.contoso_promotion
AS
SELECT * FROM contoso.promotion;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.contoso_productsubcategory
AS
SELECT * FROM contoso.productsubcategory;

-- Copy the tables from sakila database
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_actor
AS
SELECT * FROM sakila.actor;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_address
AS
SELECT * FROM sakila.address;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_category
AS
SELECT * FROM sakila.category;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_city
AS
SELECT * FROM sakila.city;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_country
AS
SELECT * FROM sakila.country;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_customer
AS
SELECT * FROM sakila.customer;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_film
AS
SELECT * FROM sakila.film;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_film_actor
AS
SELECT * FROM sakila.film_actor;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_film_category
AS
SELECT * FROM sakila.film_category;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_film_text
AS
SELECT * FROM sakila.film_text;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_inventory
AS
SELECT * FROM sakila.inventory;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_language
AS
SELECT * FROM sakila.language;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_payment
AS
SELECT * FROM sakila.payment;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_rental
AS
SELECT * FROM sakila.rental;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_staff
AS
SELECT * FROM sakila.staff;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sakila_store
AS
SELECT * FROM sakila.store;

DROP table if exists retail_sales;
CREATE table retail_sales
(
sales_month date,
naics_code varchar(1000),
kind_of_business varchar(1000),
reason_for_null varchar(1000),
sales decimal
)
;

-- populate the table with data from the csv file. Download the file locally before completing this step
-- COPY retail_sales 
-- FROM 'D:\OneDrive\Documents\PERSONAL\PERSONAL DEVELOPMENT\DATA SCIENCE\SQL\PP00013_SQL CPD Projects\SQL for DA Book_Time Series Chapter\data\us_retail_sales.csv' -- change to the location you saved the csv file
-- DELIMITER ','
-- CSV HEADER
-- ;
-- load data LOCAL infile 'D:\OneDrive\Documents\PERSONAL\PERSONAL DEVELOPMENT\DATA SCIENCE\SQL\PP00013_SQL CPD Projects\SQL for DA Book_Time Series Chapter\data\us_retail_sales.csv' INTO TABLE retail_sales;

SELECT * FROM retail_sales;

CREATE TABLE `sql_advanced_query_samples_database_dataset`.sql_simplified_department
AS
SELECT * FROM sql_simplified.department;

CREATE TABLE `sql_advanced_query_samples_database_dataset`.sql_simplified_employee
AS
SELECT * FROM sql_simplified.employee;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sql_simplified_project
AS
SELECT * FROM sql_simplified.project;
CREATE TABLE `sql_advanced_query_samples_database_dataset`.sql_simplified_sales
AS
SELECT * FROM sql_simplified.sales;

SELECT * FROM sql_simplified_employee;

-- 