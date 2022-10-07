--STEP 3: Analyze annual product category quality 
---Calculate revenue per year
---Calculate number of canceled order per year
---Find the top product category have generated the biggest revenue per year
---Find the product category with the most canceled orders per year


--(1) Revenue per year
CREATE TEMP TABLE revenue_per_year AS
SELECT
	DATE_PART('year', eo.order_purchase_time) AS year,
	SUM(eoi.price + eoi.freight_value) AS total_revenue
FROM ecom_orders eo
LEFT JOIN ecom_order_items eoi 
	ON eoi.order_id = eo.order_id
WHERE eo.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;


--(2) Number of canceled order per year
CREATE TEMP TABLE canceled_order_per_year AS
SELECT
	DATE_PART('year', order_purchase_time) AS year,
	COUNT(order_id) AS total_canceled_order
FROM ecom_orders
WHERE order_status = 'canceled'
GROUP BY 1
ORDER BY 1;


--(3) Top product category have generated the biggest revenue per year
CREATE TEMP TABLE top_product_category_by_revenue AS
SELECT	year,
		product_category AS top_product_category_generated_revenue,
		revenue_generated
FROM (	SELECT	DATE_PART('year', eo.order_purchase_time) AS year,
	  			ep.product_category_name AS product_category,
	  			SUM(eoi.price + eoi.freight_value) AS revenue_generated,
	  			RANK() OVER(PARTITION BY DATE_PART('year', eo.order_purchase_time)
						    ORDER BY SUM(eoi.price + eoi.freight_value) DESC) AS rank
	  	FROM ecom_orders eo
	  	LEFT JOIN ecom_order_items eoi ON eo.order_id = eoi.order_id
	  	LEFT JOIN ecom_products ep ON eoi.product_id = ep.product_id
	  	WHERE eo.order_status = 'delivered'
	  	GROUP BY 1,2
	 ) pc
WHERE rank = 1;


--(4) The most canceled product category per year
CREATE TEMP TABLE top_product_category_by_cancellation AS
SELECT	year,
		product_category AS most_canceled_product_category,
		cancel_frequency
FROM (	SELECT	DATE_PART('year', eo.order_purchase_time) AS year,
	  			ep.product_category_name AS product_category,
	  			COUNT(eo.order_id) AS cancel_frequency,
	  			RANK() OVER(PARTITION BY DATE_PART('year', eo.order_purchase_time)
						    ORDER BY COUNT(eo.order_id) DESC) AS rank
	  	FROM ecom_orders eo
	  	LEFT JOIN ecom_order_items eoi ON eo.order_id = eoi.order_id
	  	LEFT JOIN ecom_products ep ON eoi.product_id = ep.product_id
	  	WHERE eo.order_status = 'canceled' 
	  		AND ep.product_category_name IS NOT NULL
	  	GROUP BY 1,2
	 ) pc
WHERE rank = 1;


--(5) Joining 4 temporary tables
CREATE TEMP TABLE product_category_quality AS
SELECT	rpy.year,
		rpy.total_revenue,
		ropy.total_canceled_order,
		tpcr.top_product_category_generated_revenue,
		tpcr.revenue_generated,
		tpcc.most_canceled_product_category,
		tpcc.cancel_frequency
FROM revenue_per_year rpy
JOIN canceled_order_per_year ropy ON rpy.year = ropy.year
JOIN top_product_category_by_revenue tpcr ON rpy.year = tpcr.year
JOIN top_product_category_by_cancellation tpcc ON rpy.year = tpcc.year;

--View the table
SELECT * FROM product_category_quality;

--Export table as a CSV file
COPY product_category_quality
TO 'D:\Projects\RA\Mini Project\business performance\annual_product_category_quality.csv'
WITH (FORMAT CSV, HEADER);