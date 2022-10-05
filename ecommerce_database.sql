--STEP 1: Prepare database of ecommerce data
--Create 8 tables and specify data type of each columns in the table
--Determine primary key and foreign key
--Import data from CSV files

--1--
CREATE TABLE ecom_customers (
	customer_id varchar(50) PRIMARY KEY,
	customer_unique_id varchar(50) NOT NULL,
	customer_zip_code varchar(5) NOT NULL,
	customer_city varchar(50) NOT NULL,
	customer_state varchar(2) NOT NULL
);
COPY ecom_customers
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\customers_dataset.csv'
WITH (FORMAT CSV, HEADER);

--2--
CREATE TABLE ecom_order_items (
	order_id varchar(50) NOT NULL,
	order_item_id varchar(2) NOT NULL,
	product_id varchar(50) NOT NULL,
	seller_id varchar(50) NOT NULL,
	shipping_limit_date timestamp with time zone NOT NULL,
	price numeric(8,2) NOT NULL,
	freight_value numeric(8,2) NOT NULL
);
COPY ecom_order_items
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\order_items_dataset.csv'
WITH (FORMAT CSV, HEADER);

--3--
CREATE TABLE ecom_order_payments (
	order_id varchar(50) NOT NULL,
	payment_sequential int NOT NULL,
	payment_type varchar(20) NOT NULL,
	payment_installment int NOT NULL,
	payment_value numeric(8,2) NOT NULL
);
COPY ecom_order_payments
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\order_payments_dataset.csv'
WITH (FORMAT CSV, HEADER);

--4--
CREATE TABLE ecom_orders (
	order_id varchar(50) PRIMARY KEY,
	customer_id varchar(50),
	order_status varchar(15) NOT NULL,
	order_purchase_time timestamp with time zone NOT NULL,
	order_approved_time timestamp with time zone,
	order_delivered_carrier_date timestamp with time zone,
	order_delivered_customer_date timestamp with time zone,
	order_estimated_delivery_date timestamp with time zone NOT NULL
	--CONSTRAINT order_key PRIMARY KEY (order_id, customer_id)
);
COPY ecom_orders
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\orders_dataset.csv'
WITH (FORMAT CSV, HEADER);

--5--
CREATE TABLE ecom_products (
	product_no int UNIQUE NOT NULL,
	product_id varchar(50) PRIMARY KEY,
	product_category_name varchar(50),
	product_name_length int,
	product_description_length int,
	product_photo_qty int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int
);
COPY ecom_products
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\product_dataset.csv'
WITH (FORMAT CSV, HEADER);

--6--
CREATE TABLE ecom_sellers (
	seller_id varchar(50) PRIMARY KEY,
	seller_zip_code varchar(5) NOT NULL,
	seller_city varchar(50) NOT NULL,
	seller_state varchar(2) NOT NULL
);
COPY ecom_sellers
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\sellers_dataset.csv'
WITH (FORMAT CSV, HEADER);

--7--
CREATE TABLE ecom_geolocation (
	geolocation_zip_code varchar(5) NOT NULL,
	geolocation_lat numeric(18,15) NOT NULL,
	geolocation_lng numeric(18,15) NOT NULL,
	geolocation_city varchar(50) NOT NULL,
	geolocation_state varchar(2) NOT NULL
);
COPY ecom_geolocation
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\geolocation_dataset.csv'
WITH (FORMAT CSV, HEADER);

--8--
CREATE TABLE ecom_reviews (
	review_id varchar(50) NOT NULL,
	order_id varchar(50) NOT NULL,
	review_score int NOT NULL,
	review_comment_title varchar(30),
	review_comment_message varchar(250),
	review_creation_date timestamp with time zone,
	review_answer_timestamp timestamp with time zone
);
COPY ecom_reviews
FROM 'D:\Projects\RA\Mini Project\business performance\Dataset\order_reviews_dataset.csv'
WITH (FORMAT CSV, HEADER);


ALTER TABLE IF EXISTS ecom_order_items
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES ecom_orders (order_id);


ALTER TABLE IF EXISTS ecom_order_items
    ADD CONSTRAINT product_id FOREIGN KEY (product_id)
    REFERENCES ecom_products (product_id);


ALTER TABLE IF EXISTS ecom_order_items
    ADD CONSTRAINT seller_id FOREIGN KEY (seller_id)
    REFERENCES ecom_sellers (seller_id);


ALTER TABLE IF EXISTS ecom_order_payments
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES ecom_orders (order_id);


ALTER TABLE IF EXISTS ecom_orders
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id)
    REFERENCES ecom_customers (customer_id);


ALTER TABLE IF EXISTS ecom_reviews
    ADD CONSTRAINT order_id FOREIGN KEY (order_id)
    REFERENCES ecom_orders (order_id);
