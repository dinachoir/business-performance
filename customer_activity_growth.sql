--STEP 2: Analyze annual customer activity growth
---Calculate average Monthly Active User (MAU) per year
---Calculate total new customer per year
--=Calculate total number of customer who made repeat order per year
---Calculate average order frequency per year


--(1) Average Monthly Active User (MAU) per year
WITH monthly_active_user AS (
		SELECT 
			DATE_PART('year', eo.order_purchase_time) AS year,
			DATE_PART('month', eo.order_purchase_time) AS month,
			COUNT(DISTINCT ec.customer_id) AS active_users
		FROM ecom_customers ec
		LEFT JOIN ecom_orders eo
			ON ec.customer_id = eo.customer_id
		GROUP BY 1,2
		ORDER BY 1,2
		)
		
SELECT  year,
		ROUND(AVG(active_users), 0) AS avg_monthly_active_users
FROM monthly_active_user
GROUP BY 1
ORDER BY 1;
	
	
--(2) Total new customer per year
WITH new_customers AS (
		SELECT
			ec.customer_id,
			MIN(eo.order_purchase_time) AS first_order_time
		FROM ecom_customers ec
		LEFT JOIN ecom_orders eo
			ON ec.customer_id = eo.customer_id
		GROUP BY 1
		)

SELECT  DATE_PART('year', first_order_time) AS year,
		COUNT(*) AS number_of_new_customers
FROM new_customers
GROUP BY 1
ORDER BY 1;


--(3) Total number of customer who made repeat order per year
WITH repeat_orders AS (
		SELECT  
			DATE_PART('year', eo.order_purchase_time) AS year,
			ec.customer_id AS repeated_customers,
			COUNT(eo.order_id) AS total_order
		FROM ecom_customers ec
		LEFT JOIN ecom_orders eo
			ON ec.customer_id = eo.customer_id
		GROUP BY 1,2
		HAVING COUNT(eo.order_id) > 1
		)
		
SELECT  year,
		COUNT(DISTINCT repeated_customers) AS number_of_repeated_customers
FROM repeat_orders
GROUP BY 1;


--(4) Average order frequency per year
WITH orders AS (
		SELECT
			ec.customer_id,
			DATE_PART('year', eo.order_purchase_time) AS year,
			COUNT(*) AS order_frequency
		FROM ecom_customers ec
		LEFT JOIN ecom_orders eo
			ON ec.customer_id = eo.customer_id
		GROUP BY 1,2
		)
		
SELECT  year,
		ROUND(AVG(order_frequency), 1) AS avg_order_frequency
FROM orders
GROUP BY 1
ORDER BY 1;


--(5) Joining all metrics in 1 table

--Create temporary table for average monthly active users
CREATE TEMP TABLE average_montly_active_users AS
SELECT  year,
		ROUND(AVG(active_users), 0) AS avg_monthly_active_users
FROM (	SELECT 
		DATE_PART('year', eo.order_purchase_time) AS year,
		DATE_PART('month', eo.order_purchase_time) AS month,
		COUNT(DISTINCT ec.customer_id) AS active_users
		FROM ecom_customers ec
		LEFT JOIN ecom_orders eo
			ON ec.customer_id = eo.customer_id
		GROUP BY 1,2
		ORDER BY 1,2) monthly_active_user
GROUP BY 1
ORDER BY 1;

--Create temporary table for total new customers
CREATE TEMP TABLE total_new_customers AS
SELECT  DATE_PART('year', first_order_time) AS year,
		COUNT(*) AS number_of_new_customers
FROM (SELECT
		ec.customer_id,
		MIN(eo.order_purchase_time) AS first_order_time
		FROM ecom_customers ec
		LEFT JOIN ecom_orders eo
			ON ec.customer_id = eo.customer_id
		GROUP BY 1) new_customers
GROUP BY 1
ORDER BY 1;

--Create temporary table for total repeated customers
CREATE TEMP TABLE total_repeated_customers AS
SELECT *
FROM (VALUES (2016, 0), (2017,0), (2018, 0)) AS rc (year, number_of_repeated_customers);

--Create temporary table for average order frequency
CREATE TEMP TABLE average_order AS
SELECT  year,
		ROUND(AVG(order_frequency), 1) AS avg_order_frequency
FROM (	SELECT
		ec.customer_id,
		DATE_PART('year', eo.order_purchase_time) AS year,
		COUNT(*) AS order_frequency
		FROM ecom_customers ec
		LEFT JOIN ecom_orders eo
			ON ec.customer_id = eo.customer_id
		GROUP BY 1,2) orders
GROUP BY 1
ORDER BY 1;

--Join 4 temporary tables 
CREATE TEMP TABLE customer_activity_growth AS
SELECT  amau.year,
		amau.avg_monthly_active_users,
		tnc.number_of_new_customers,
		trc.number_of_repeated_customers,
		ao.avg_order_frequency
FROM average_montly_active_users amau
JOIN total_new_customers tnc ON amau.year = tnc.year
JOIN total_repeated_customers trc ON amau.year = trc.year
JOIN average_order ao ON amau.year = ao.year;

--View the table
SELECT * FROM customer_activity_growth

--Export table as a CSV file
COPY customer_activity_growth
TO 'D:\Projects\RA\Mini Project\business performance\annual_customer_activity_growth.csv'
WITH (FORMAT CSV, HEADER);
