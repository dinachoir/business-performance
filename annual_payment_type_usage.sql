--STEP 4: Analyze annual payment type usage

CREATE TEMP TABLE annual_payment_type_usage AS
SELECT
	payment_type,
	SUM(CASE WHEN year = 2016 THEN payment_type_usage ELSE 0 END) AS "total_usage_in_2016",
	SUM(CASE WHEN year = 2017 THEN payment_type_usage ELSE 0 END) AS "total_usage_in_2017",
	SUM(CASE WHEN year = 2018 THEN payment_type_usage ELSE 0 END) AS "total_usage_in_2018",
	SUM(payment_type_usage) AS total_usage
FROM (SELECT
	  		DATE_PART('year', order_purchase_time) AS year,
	 		payment_type,
	 		COUNT(payment_type) AS payment_type_usage
	  FROM ecom_orders AS eo
	  JOIN ecom_order_payments AS eop 
	  	ON eop.order_id = eo.order_id
	  GROUP BY 1, 2
	 ) AS tpu
GROUP BY 1
ORDER BY 2 DESC;

--Export table as a CSV file
COPY annual_payment_type_usage
TO 'D:\Projects\RA\Mini Project\business performance\annual_payment_type_usage.csv'
WITH (FORMAT CSV, HEADER);

--Finding out what "not_defined payment type" is
SELECT *
FROM ecom_orders eo
LEFT JOIN ecom_order_payments eop
	ON eo.order_id = eop.order_id
WHERE eop.payment_type = 'not_defined'
	
SELECT *
FROM ecom_orders eo
LEFT JOIN ecom_order_payments eop
	ON eo.order_id = eop.order_id
WHERE eo.order_status = 'canceled' AND eop.payment_type = 'voucher'

---"not_defined payment type" is any payment methods aside "voucher",
---which the order has been canceled before order approval.

---meanwhile payment type of canceled order after order approval defined as it is.