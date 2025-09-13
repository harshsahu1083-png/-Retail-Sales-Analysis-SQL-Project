-- CREATE TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date DATE,	
sale_time TIME,	
customer_id	INT,
gender VARCHAR(40),
age	INT,
category VARCHAR(20),	
quantiy	INT,
price_per_unit FLOAT,	
cogs FLOAT,	
total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy	IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL

DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy	IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- Data Exploration

-- How many sales we have
select count(*) as total_sale from retail_sales;

-- How many unique customers we have
select count(distinct customer_id) from retail_sales; 

-- How many unique categories we have
select distinct category from retail_sales; 

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022

select * from retail_sales
where category = 'Clothing'
and quantiy >= 4
and to_char(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale) as Total_sales
from retail_sales
group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age), 2) as Average_age 
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale >= 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender, count(transactions_id) as Total_transaction
from retail_sales
group by category,gender
order by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
    
-- ORDER BY 1, 3 DESC


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select 
      customer_id,
	  sum(total_sale) as total_sale
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category, count(distinct customer_id) as unique_cx
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12,
--Afternoon Between 12 & 17, Evening >17)

WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
            ELSE 'evening'
        END AS shifts
    FROM retail_sales
)
SELECT 
    shifts,
    COUNT(*) AS total_order
FROM hourly_sales
GROUP BY shifts;
