create database retail_sales;
create table sales (
			transactions_id	INT PRIMARY KEY,
            sale_date DATE,
            sale_time TIME,
            customer_id INT,
            gender VARCHAR(15),	
            age INT,
            category VARCHAR(15),	
            quantity INT,	
            price_per_unit FLOAT,
            cogs FLOAT,	
            total_sale FLOAT
            );
select * from sales ;

INSERT INTO sales (transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantity,price_per_unit,cogs,total_sale
)
values (432, '2022-03-10', '11:31:00', 17, 'Female', 41, 'Electronics', 2, 500, 190, 1000),
(1367, '2022-04-15', '11:38:00', 16, 'Female',41, 'Electronics', 1, 50, 15.5, 50),
(1391, '2022-03-01', '11:29:00', 130, 'Male',41, 'Beauty', 2, 25, 9.25, 50);
;
INSERT INTO sales (
    transactions_id, sale_date, sale_time, customer_id, gender, age, category
)
VALUES
(679, '2022-08-26', '08:59:00', 64, 'Female', 18, 'Beauty'),
(746, '2022-07-05', '11:33:00', 42, 'Female', 33, 'Clothing'),
(1225, '2022-02-02', '09:51:00', 137, 'Female', 57, 'Beauty');
select count(*)  from sales;

delete from sales
where 
price_per_unit is null
or
cogs is null
or
total_sale is null ;
select * from sales;

UPDATE sales
SET age = 41
WHERE age IS NULL;

select * from sales
where  
age is null ;
-- How many transaction id we have?
select count(*) as total_transactions from sales;
-- How many unique customers we have ?
select count(distinct customer_id) as customer_count from sales;
-- How many category we have ?
select count(distinct category) as category_count from sales;
select distinct category  from sales;
-- Data Analysis , Business key problems & Answers
-- q1 Write SQL query to retrieve all columns for sales made on 2022-11-05
select * from sales;
select * from sales
where sale_date = '2022-11-05';
-- Q.2 Write a SQL query to retrieve all the transactions where category is 'Clothing' 
-- and the quantity sold is more than 10 in the month of November 2022
select * from sales
where category = 'Clothing'
and
date_format (sale_date, '%Y-%m') = "2022-11"
and
quantity >=4;
-- Q 3 Write a SQL query to calculate total_sale for each category
select category,sum(total_sale) as Total_sales,count(*) as Total_orders
from sales
group by category;
-- Q 4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
select category ,round((avg(age) ),2) as Average_age
from sales
where category = "Beauty"
group by category;
-- Q 5 Write a SQL Query to find all the transactions where the total_sales is greater than 1000
select * from sales;
select transactions_id ,total_sale
from sales
where total_sale >1000;
-- Q 6 Write a SQL query to find the total no of transactions(transaction_id) 
-- made by each gender in each category
select category,gender,count(transactions_id) as Total_transactions
from sales
group by category,gender
order by category,gender;
-- Write a SQL query to calculate average sale of each month.Find out best selling month in each year.
select  YEAR,MONTH,Average_sale 
from
(select YEAR(sale_date) as Year,
MONTH(sale_date) as Month,
round(avg(total_sale),2) as Average_sale,
RANK()
over(
partition by YEAR(sale_date) 
order by round(avg(total_sale),2) DESC
) as 'Rank'
from sales
group by Year,Month) as t1
where `Rank` = 1;
-- Write a SQL query to find top 5 customers based on highest total _sale
select * from sales;
select customer_id,sum(total_sale) as Total_sales
from sales
group by customer_id 
order by Total_sales desc
limit 5;
-- Q 9 Write a SQL Query to find the number of unique customers who purchased items from eact category
select category, count(distinct customer_id) as Total_unique_customers
from sales
group by category;
-- Write a SQL query to create each shift and number of orders
-- (Example morning >=1, Afternoon between 12 and 17, Evening >17
with hourly_sales 
as (select * ,
case
when hour(sale_time) <12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as shift
from sales)
select shift,count(*) as total_orders
from hourly_sales
group by shift;
