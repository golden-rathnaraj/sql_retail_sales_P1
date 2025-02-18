-- 1.Database Setup

CREATE DATABASE project1;
USE project1;

DROP table if exists retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(10),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit INT,
	cogs FLOAT,
	total_sale INT);
    
 -- 2.DATA EXPLORATION & CLEANING :
 
SELECT * FROM retail_sales 
where
    transactions_id Is null or
	sale_date is null or
	sale_time is null or
	customer_id  is null or
	gender is null or
	age is null or
	category is null or
	quantity is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null;
    
DELETE FROM retail_sales 
where
    transactions_id Is null or
	sale_date is null or
	sale_time is null or
	customer_id  is null or
	gender is null or
	age is null or
	category is null or
	quantity is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null;
    
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;
    

-- 3.DATA ANALYSIS & FINDINGS : 

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05 :
   SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
   
-- Q.2 Write a SQL query to retrieve all transactions where the category is 
-- 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
    SELECT * from retail_sales WHERE category = 'clothing'
    AND DATE_FORMAT(sale_date, 'YYYY-MM') = '2022-11'  AND quantity>=4;

-- Q.3  Write a SQL query to calculate the total sales (total_sale) for each category.:
     SELECT category,sum(total_sale) AS net_sale,count(total_sale) from retail_sales group by category;
     
-- Q.4  Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
     SELECT ROUND(avg(age)) from retail_sales where category = 'beauty';
     
-- Q.5  Write a SQL query to find all transactions where the total_sale is greater than 1000.:
       SELECT * from retail_sales WHERE total_sale>=1000;
       
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
        SELECT count(transactions_id),gender,category from retail_sales group by gender,category order by category;
        
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
     *
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as ranks
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE ranks = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales : 

SELECT customer_id,max(total_sale) from retail_sales  group by customer_id order by 2 DESC limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.:

 SELECT count(distinct(customer_id)) as no_of_customers,category from retail_sales group by category order by 1 desc;
 
 -- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
 with new_table as
  (select *,
  CASE 
      WHEN extract(HOUR FROM sale_time)<12 then 'Morning'
      WHEN extract(HOUR FROM sale_time) between 12 and 17 then 'Afternoon'
      ELSE 'Evening'
      END AS 'Shift'
      FROM retail_sales) 
      select shift,count(*) from new_table as orders group by shift;