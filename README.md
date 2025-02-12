# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `project_p1`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `project_p1`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE project_p1;
USE  project_p1;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT *
FROM 
	(SELECT * FROM retail_sales
	WHERE category='Clothing' AND quantiy>=4) AS new
WHERE DATE_FORMAT(sale_date, '%Y-%m')='2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT SUM(total_sale) AS net_sale,category
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT category,ROUND(avg(age), 2) AS Average_Age
FROM retail_sales
WHERE category='Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category,gender,COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY category,gender;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id,SUM(total_sale) AS total
FROM retail_sales
GROUP BY customer_id
ORDER BY total DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category,
 COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category; 
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT COUNT(*) AS total,
( CASE
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
    WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17 THEN 'afternoon'
    ELSE 'evening'
    END 
) AS shift
FROM retail_sales
GROUP BY shift;
```

** Top 5 Highest sale days
```sql
SELECT * 
FROM retail_sales
ORDER BY total_sale
LIMIT 5;
```
** Monthly sales trend
```sql
SELECT 
	EXTRACT(MONTH FROM sale_date) AS MONTH,
	EXTRACT(YEAR FROM sale_date) AS YEAR,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY YEAR,MONTH
ORDER BY YEAR,MONTH;
```

** Gender wise spending
```sql
SELECT gender,SUM(total_sale) AS TOTAL_SPENDING
FROM retail_sales
GROUP BY gender;
```
** Peak shopping hours
```sql
SELECT 
	EXTRACT(HOUR FROM sale_time) AS HOUR,
    SUM(total_sale) AS TOTAL_SALES
FROM retail_sales
GROUP BY HOUR
ORDER BY TOTAL_SALES DESC;
```
** Best selling Categories Per year
```sql
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
```
    
** Customers Having More than 5 Purchases
```sql
SELECT customer_id, COUNT(transactions_id) AS total_purchases
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(transactions_id) > 5
ORDER BY total_purchases DESC;
```
-- End of project

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database** 
3. **Run the Queries**
4. **Explore and Modify**




