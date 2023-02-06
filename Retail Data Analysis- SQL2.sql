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



select * from Customer
select * from prod_cat_info
select * from Transactions