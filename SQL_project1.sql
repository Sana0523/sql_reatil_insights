-- Database creation
CREATE DATABASE project_p1;
USE  project_p1;
-- table creation
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
    gender VARCHAR(12),
	age	INT,
	category VARCHAR(12),	
    quantiy	INT,
    price_per_unit FLOAT,
	cogs FLOAT,
    total_sale INT
);

-- view table
SELECT * FROM 
retail_sales;

-- data cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id is NULL
    OR
    sale_date is NULL
    OR
    sale_time is NULL
    OR
    gender is NULL
    OR
    quantiy is NULL
    OR
    cogs is NULL
    OR
    total_sale is NULL;

DELETE FROM retail_sales
WHERE transactions_id is NULL
    OR
    sale_date is NULL
    OR
    sale_time is NULL
    OR
    gender is NULL
    OR
    quantiy is NULL
    OR
    cogs is NULL
    OR
    total_sale is NULL;
    
-- How many customer id do we have?
SELECT COUNT(customer_id) 
FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) 
FROM retail_sales;

-- How many category do we have?
SELECT DISTINCT category 
FROM retail_sales;

-- 1) Write a SQL query to retrieve all columns for sales made on 2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';

-- 2)Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT *
FROM 
	(SELECT * FROM retail_sales
	WHERE category='Clothing' AND quantiy>=4) AS new
WHERE DATE_FORMAT(sale_date, '%Y-%m')='2022-11';

-- 3)Write a SQL query to calculate the total sales (total_sale) for each category
SELECT SUM(total_sale) AS net_sale,category
FROM retail_sales
GROUP BY category;

-- 4)Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category,ROUND(avg(age), 2) AS Average_Age
FROM retail_sales
WHERE category='Beauty';

-- 5)Write a SQL query to find all transactions where the total_sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale>1000;

-- 6)Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category,gender,COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category,gender;

-- 7)Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
WITH ranked_sale AS (
SELECT *,
	RANK() OVER(PARTITION BY year ORDER BY AVG_SALE DESC) AS rnk
FROM(
	SELECT AVG(total_sale) AS AVG_SALE,
	EXTRACT(MONTH FROM sale_date) AS Month,
	EXTRACT(YEAR FROM sale_date) AS year
	FROM retail_sales
	GROUP BY year,Month
	ORDER BY year,Month
) AS table_sale
)
SELECT * 
FROM ranked_sale
WHERE rnk=1;

-- 8)Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id,SUM(total_sale) AS total
FROM retail_sales
GROUP BY customer_id
ORDER BY total DESC
LIMIT 5;

-- 9)Write a SQL query to find the number of unique customers who purchased items from each category
SELECT category,
 COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category; 

-- 10)Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT COUNT(*) AS total,
( CASE
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
    WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'afternoon'
    ELSE 'evening'
    END 
) AS shift
FROM retail_sales
GROUP BY shift;

-- Top 5 Highest sale days
SELECT * 
FROM retail_sales
ORDER BY total_sale
LIMIT 5;

-- Monthly sales trend
SELECT 
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY YEAR,MONTH
ORDER BY YEAR,MONTH;

-- Gender wise spending
SELECT gender,SUM(total_sale) AS TOTAL_SPENDING
FROM retail_sales
GROUP BY gender;

-- Peak shopping hours
SELECT 
	EXTRACT(HOUR FROM sale_time) AS HOUR,
    SUM(total_sale) AS TOTAL_SALES
FROM retail_sales
GROUP BY HOUR
ORDER BY TOTAL_SALES DESC;

-- Best selling Categories Per year
WITH cat_table AS(
SELECT SUM(total_sale) AS TOTAL_SALES,
	category,
    EXTRACT(YEAR FROM sale_date) AS YEAR
FROM retail_sales
GROUP BY category,YEAR
), RANKED_TABLE AS(
SELECT * ,
 RANK() OVER(PARTITION BY YEAR ORDER BY TOTAL_SALES) AS rnk
FROM cat_table
)
SELECT * FROM
RANKED_TABLE
WHERE rnk=1;
    
-- Customers Having More than 5 Purchases
SELECT customer_id, COUNT(transactions_id) AS total_purchases
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(transactions_id) > 5
ORDER BY total_purchases DESC;

-- End of project
