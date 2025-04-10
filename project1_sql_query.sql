drop table if exists retail_sales;

create table retail_sales(
	
    transactions_id	int primary key,
	sale_date	   Date,
	sale_time	  Time,
	customer_id   int,
	gender        varchar(15),
	age           int,
	category      varchar(15),
	quantiy	      int,
	price_per_unit	float,
	cogs	        float,
	total_sale      float

);
-- data cleaning
select * from retail_sales limit 10;
select *
from retail_sales
where transactions_id is null;

select *
from retail_sales
where sale_date is null;

select *
from retail_sales
where transactions_id is null
  or 
  sale_date is null
  OR
  sale_time is null
  or 
  gender is null
  or 
  quantiy is null
  or 
  cogs is null
  or total_sale is null;
  
  
  delete from retail_sales
where 
  transactions_id is null
  or 
  sale_date is null
  OR
  sale_time is null
  or 
  gender is null
  or 
  quantiy is null
  or 
  cogs is null
  or total_sale is null;
  
  
select count(*) from retail_sales;

--data exploration
--how many sales we have?
select count(*) as total_sale from retail_sales;

--how many uniques customers we have?
select count(distinct customer_id) as total_sale from retail_sales;

--how many uniques catergory we have?
select distinct category from retail_sales;

--Data Analysis & Business key Problems & Answers
--Q.1 - Write a SQL query to retrieve all columns for sales made on '2022-11-05:
--Q.2 - Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
--Q.3 - Write a SQL query to calculate the total sales (total_sale) for each category.:
--Q.4 - Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
--Q.5 - Write a SQL query to find all transactions where the total_sale is greater than 1000.:
--Q.6 - Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
--Q.7 - Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
--Q.8 - Write a SQL query to find the top 5 customers based on the highest total sales **:
--Q.9 - Write a SQL query to find the number of unique customers who purchased items from each category.:
--Q.10 - Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):


--Q.1 - Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select *
from retail_sales
where sale_date = '2022-11-05';

--Q.2 - Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select 
    *
  from retail_sales
  where category= 'Clothing'
  and
  to_char(sale_date,'yyyy-mm') = '2022-11'
  AND
  quantiy >= 4;
--Q.3 - Write a SQL query to calculate the total sales (total_sale) for each category.:

select * from retail_sales;

select 
	category,
	sum(total_sale) as net_sales,
	Count(*) as total_orders
from retail_sales
group by 1;

--Q.4 - Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select 
 	round(Avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';

--Q.5 - Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select 
	*
	from retail_sales
	where total_sale > 1000;
	
--Q.6 - Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:

select
	category,
	gender,
	count(*) as total_trans
from retail_sales
group by 
	category,
	gender
order by 1;

--Q.7 - Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

select * from retail_sales;
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	Rank()over (partition by extract(year from sale_date)order by avg(total_sale) desc ) as rank
from retail_sales
group by 1, 2;
--order by 1, 2, 3 desc;
--another method to solve the question
select * from
( 
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	Rank()over (partition by extract(year from sale_date)order by avg(total_sale) desc ) as rank
from retail_sales
group by 1, 2
)as t1
where rank = 1;

select 
	year,
	month,
	avg_sale
from
( 
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	Rank()over (partition by extract(year from sale_date)order by avg(total_sale) desc ) as rank
from retail_sales
group by 1, 2
)as t1
where rank = 1;

--another method to solve the question

select * from retail_sales;
select
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale
from retail_sales
group by 1, 2
order by 1, 2, 3 desc;

--Q.8 - Write a SQL query to find the top 5 customers based on the highest total sales **:

select
select 
	customer_id,
	Sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--Q.9 - Write a SQL query to find the number of unique customers who purchased items from each category.:

select 
 	 category,
	count(Distinct customer_id) as cnt_unique_cs
from retail_sales
group by  category;
order by 2 desc
limit 5;

--Q.10 - Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
select * from retail_sales

select *,
	CASE
		WHEN EXTRACT(HOUR FROM  sale_time) < 12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND  17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales;

WITH  hourly_sale
AS
(
select *,
	CASE
		WHEN EXTRACT(HOUR FROM  sale_time) < 12 THEN 'morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND  17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift;
--End of project