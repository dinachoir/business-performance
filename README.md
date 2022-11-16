# Ecommerce Annual Performance Analysis

## Working Environment
* **Tool** : PostgreSQL
* **Programming** Language : SQL
* **Visualization** : Tableau


## Objectives
In a company measuring business performance is very important to track, monitor, and assess the success or failure of various business processes. Therefore, in this project, I analyzed business performance for an eCommerce company, taking into account several business metrics, including customer growth, product quality, and payment types.The results of the insights that I found are presented in the form of visualization data.

## Data Preparation
Before doing an analysis, here are the steps to prepare the ecommerce database:
  * Create a new database using pgAdmin, named ecommerce_database
  * Create 8 new tables in query tool with specific data type and  primary key using CREATE TABLE statement
  * Add constraint foreign key using ALTER TABLE statement
  * Import data from CSV files to each database table using COPY & FROM statement
  * Generate ERD diagram using ERD tool
  <p align="center">
  <img width="560" img width="243" alt="summary" src="https://user-images.githubusercontent.com/98371569/200179101-a0a9e17d-ed00-4f4c-a5d9-f6a5720f8d62.png">
    <br style="font-size:5px"> Figure 1. ERD </br>
  </p>
  
  * Check the relations between tables \
    From ERD diagram we can identify cardinality between entities: 
      * A Customer can make multiple orders
      * Each order possibly has multiple order items and reviews
      * Each order can also have a multiple order payments since the e-commerce provides an installment service and voucher payment method 
      * A product can be purchased in many different orders
      * A seller can sell multiple products as different order items
  * Save ERD diagram as an image

## Data Analysis
### Annual Customer Activity Growth
   * Relatively customer acquisition is increasing every year.
   * The average monthly active users is increasing every year.
   * Order only made by new customers, therefore there is no repeated customer made another order. This means customer retention is really poor.
   * In average, customers only did one order each year.
   
### Annual Product Category Quality
   * Relatively total revenue and total canceled order are increasing each year.
   * Product category that generated the highest revenue is different each year. This could be influenced by the current trend.
   * Health & beauty is a product category that generated the highest revenue, which contributed around 10% of the total revenue in 2018. 
   * In 2018, revenue by the top product category is 49% higher compared to the previous year.
   * The highest revenue of Health & beauty also followed with the highest cancel frequency. It contributed 8% of the total number of canceled order.

### Annual Payment Type Usage
   * Credit card is the most popular payment type that frequently used by the customers in each year.
   * The increase in the use of debit card as a payment method in 2018 is the most significant.
   * In 2018, voucher usage as a payment method slightly decreases compared to the previous year. Meanwhile the others are increasing.


## Key Insights
1. The low retention can be an  early diagnosis that customers are not interested, or unsatisfied or disappointed in shopping at the e-commerce. Therefore we require to improve our service and product, and then develop loyalty program to retain customers and build an emotional ties to our platform.
2. Developing crowd recomendations would be great for driving more purchases in trending products.
3. The most popular payment method is a credit card, so that further analysis can be carried out regarding the habits of these customers such as which product categories they usually buy.
