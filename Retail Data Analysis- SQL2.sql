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

--Q5. Which product category does the sub-category “DIY” belong to?

select prod_cat from prod_cat_info where prod_subcat = 'DIY'

------------------------------------------------------------------------------------------------------

--DATA ANALYSIS

--Q1. Which channel is most frequently used for transactions?

select top 1 Store_type, count(transaction_id) Channel_Count from Transactions
group by Store_type
order by 2 desc

--Q2. What is the count of Male and Female customers in the database?

select Gender, COUNT(Gender) Gender_Count from Customer
where Gender is not null
group by Gender

--Q3. From which city do we have the maximum number of customers and how many?

select top 1 city_code, COUNT(customer_id) Customer_Count from Customer
group by city_code
order by 2 desc

--

select * from Customer
select * from prod_cat_info
select * from Transactions