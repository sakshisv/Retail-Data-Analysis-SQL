create database RETAIL_DATA

use RETAIL_DATA

select * from Customer
select * from prod_cat_info
select * from Transactions


--DATA PREPARATION AND UNDERSTANDING

--Q1. What is the total number of rows in each of the 3 tables in the database?

select count(*) No_of_Rows from Customer
Union
select count(*) from prod_cat_info
Union
select count(*) from Transactions

--Q2. What is the total number of transactions that have a return?

select count(*) Transaction_Returns from Transactions where Qty < 0

--Q3. As you would have noticed, the dates provided across the datasets are not in a correct format. 
--    As first steps, pls convert the date variables into valid date formats before proceeding ahead.

select convert(date, DOB) DOB from Customer
select convert(date, tran_date, 105) tran_date from Transactions

--Q4. What is the time range of the transaction data available for analysis? 
--    Show the output in number of days, months and years simultaneously in different columns.

select min(tran_Date) Start_Date, max(tran_date) End_Date, 
DATEDIFF(DAY, min(tran_Date), max(tran_date)) No_of_Days,
DATEDIFF(MONTH, min(tran_Date), max(tran_date)) Months,
DATEDIFF(YEAR, min(tran_Date), max(tran_date)) Years from 
(select convert(date, tran_date, 105) tran_date from Transactions) x

--

select * from Customer
select * from prod_cat_info
select * from Transactions