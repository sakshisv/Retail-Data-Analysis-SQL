-------- RETAIL DATA CASE STUDY --------

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
select convert(date, tran_date) tran_date from Transactions

--Q4. What is the time range of the transaction data available for analysis? 
--    Show the output in number of days, months and years simultaneously in different columns.

select min(tran_Date) Start_Date, max(tran_date) End_Date, 
DATEDIFF(DAY, min(tran_Date), max(tran_date)) No_of_Days,
DATEDIFF(MONTH, min(tran_Date), max(tran_date)) Months,
DATEDIFF(YEAR, min(tran_Date), max(tran_date)) Years from 
(select convert(date, tran_date) tran_date from Transactions) x

--Q5. Which product category does the sub-category �DIY� belong to?

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

--Q4. How many sub-categories are there under the Books category?

select count(prod_subcat) Subcat_Count from prod_cat_info
where prod_cat = 'Books'

--Q5. What is the maximum quantity of products ever ordered?

select top 1 Qty from Transactions
where Qty > 0
order by Qty desc

--Q6. What is the net total revenue generated in categories Electronics and Books?

select b.prod_cat, round(sum(a.total_amt), 2) Total_Revenue from Transactions a
left join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where b.prod_cat in ('Electronics', 'Books')
group by b.prod_cat

--Q7. How many customers have >10 transactions with us, excluding returns?

select count(*) Customer_Count from (
select customer_id, Transaction_Count from (
select a.customer_id, count(b.transaction_id) Transaction_Count from Customer a
left join Transactions b
on a.customer_id = b.cust_id
where b.Qty > 0
group by a.customer_id) x
where Transaction_Count > 10) y

--Q8. What is the combined revenue earned from the �Electronics� & �Clothing� categories, from �Flagship stores�?

select a.Store_type, round(sum(a.total_amt), 2) Combined_Revenue from Transactions a
left join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where a.Store_type = 'Flagship store' and b.prod_cat in ('Electronics', 'Clothing')
group by a.Store_type

--Q9. What is the total revenue generated from �Male� customers in �Electronics� category? 
--    Output should display total revenue by prod sub-cat.

select c.prod_subcat, round(sum(a.total_amt), 2) Total_Revenue from Transactions a
left join Customer b on a.cust_id = b.customer_Id
left join prod_cat_info c
on a.prod_cat_code = c.prod_cat_code and a.prod_subcat_code = c.prod_sub_cat_code
where b.Gender = 'M' and c.prod_cat = 'Electronics'
group by c.prod_subcat

--Q10. What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?

With a1 as (
select top 5 b.prod_subcat, round((sum(a.total_amt)/(select sum(total_amt) from Transactions where total_amt > 0))*100, 2) Sales_Percentage 
from Transactions a
inner join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where a.total_amt > 0
group by b.prod_subcat
order by 2 desc)
,
b1 as (
select b.prod_subcat, round((sum(a.total_amt)/(select sum(total_amt) from Transactions where total_amt < 0))*100, 2) Returns_Percentage 
from Transactions a
inner join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where a.total_amt < 0
group by b.prod_subcat)

select a1.prod_subcat, a1.Sales_Percentage, b1.Returns_Percentage from a1
left join b1 on a1.prod_subcat = b1.prod_subcat

--Q11. For all customers aged between 25 to 35 years find what is the net total revenue generated by these consumers in last 30 days of 
--     transactions from max transaction date available in the data?

select sum(a.total_amt) Total_Revenue from (
select *, MAX(tran_date) OVER() as Max_tran_date from Transactions) a
inner join Customer b
on a.cust_id = b.customer_Id
where a.tran_date >= DATEADD(DAY, -30, a.Max_tran_date)
and DATEDIFF(YEAR, b.DOB, a.Max_tran_date) BETWEEN 25 AND 35

--Q12. Which product category has seen the max value of returns in the last 3 months of transactions?

select top 1 b.prod_cat, sum(a.total_amt) MaxReturns from (
select *, MAX(tran_date) OVER() as Max_tran_date from Transactions) a
inner join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where a.tran_date >= DATEADD(MONTH, -3, a.Max_tran_date) and a.Qty < 0
group by b.prod_cat
order by 2 

--Q13. Which store-type sells the maximum products; by value of sales amount and by quantity sold?

select top 1 a.Store_type, round(sum(a.total_amt),0) Sales_Amount, count(a.Qty) Qty_Sold from Transactions a
inner join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
group by a.Store_type
order by 2 desc

--Q14. What are the categories for which average revenue is above the overall average.

select b.prod_cat from (
select *, avg(total_amt) OVER() Overall_Average from Transactions) a
inner join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
group by b.prod_cat, a.Overall_Average
having avg(a.total_amt) > a.Overall_Average

--Q15. Find the average and total revenue by each subcategory for the categories which are among 
--     top 5 categories in terms of quantity sold.

select b.prod_subcat, round(avg(a.total_amt),2) Average, round(sum(a.total_amt),2) Total_Revenue from Transactions a
inner join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where b.prod_cat IN (
select top 5 b.prod_cat from transactions a
inner join prod_cat_info b
on a.prod_cat_code = b.prod_cat_code and a.prod_subcat_code = b.prod_sub_cat_code
where a.Qty > 0
group by b.prod_cat
order by sum(a.total_amt) desc) 
group by b.prod_subcat

-------------------------------------------------------------------------------------------------------------------------------------
