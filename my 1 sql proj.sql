--sql retail sales analysis-p1
--create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
			 ( 
			 	transactions_id INT PRIMARY KEY,
				 sale_date DATE,
				 sale_time TIME,
				 customer_id INT,
				 gender VARCHAR(15),
				 age INT,
				 category  VARCHAR(15),	
				 quantity INT,
				 price_per_unit FLOAT,	
				 cogs	FLOAT,
				 total_sale FLOAT
			);

SELECT * FROM retail_sales
LIMIT 10

SELECT
	COUNT(*) 
FROM retail_sales

SELECT * FROM retail_sales
WHERE transactions_id is NULL

SELECT * FROM retail_sales
WHERE sale_date is NULL

SELECT * FROM retail_sales
WHERE sale_time  is NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;

--
DELETE FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR
	customer_id is NULL
	OR
	gender is NULL
	OR
	age is NULL
	OR
	category is NULL
	OR
	quantity is NULL
	OR
	price_per_unit is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL;
	
----DATA EXPLORATION

---how many sales we have?
SELECT COUNT(*) AS total_sale FROM retail_sales

-- how many  unique customer we have?
SELECT COUNT(DISTINCT customer_id) as total_sales from retail_sales

--how many  unique category we have?
SELECT COUNT(DISTINCT category) astotal_sales FROM retail_sales

--find all the category name
SELECT DISTINCT category from retail_sales

--data analysis ans business key problems and answers
--Q1 write a sql query to retrive all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q2 write a query  to  retrieve all transactions where the category is clothing and the quantity sold is more the 4 in
--the month of nov-2022
SELECT * FROM retail_sales 
WHERE 
	category = 'Clothing'
	AND
	quantity >= 4
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'

--Q3 write a sql query to calculate the total sales for each category?
SELECT category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--Q4 write a sql query to find the average of customer who purchased items from the 'beauty' category?
SELECT 
	AVG(age) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

ROUND(AVG(age),2) as avg_age

--Q5 write a query to find all transactions where the total sales is greater than 1000
SELECT * FROM retail_sales 
WHERE total_sale  > 1000

--Q6 write a sql query to find the total number of transaction(transaction_id) made by each gender in category.
SELECT
	category,
	gender,
	COUNT(*)as total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 1

--Q7 write a sql query to calculate the  average sale for each month. find out best selling month in each year
SELECT 
		year,
		month,
	 avg_sale
FROM
(SELECT
	EXTRACT(YEAR FROM sale_date)as year,
	EXTRACT(MONTH FROM sale_date)as month,
	AVG(total_sale)as avg_sale,
	RANK()OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC)as rank
	FROM retail_sales
	GROUP BY 1,2
	)as t1
	WHERE rank = 1
	
--Q8 write a query to find the top 5 customer based on the higest total sales
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 


--Q9 write a sql query to find the number of unique customer who purchased items from each category.
SELECT 
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category 

--Q10 write  a sql query to create each shift and number of orders (example morning <=12, afternoon between 12 & 17,evening >17)
WITH hourly_sale
AS 
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

-- end of project
