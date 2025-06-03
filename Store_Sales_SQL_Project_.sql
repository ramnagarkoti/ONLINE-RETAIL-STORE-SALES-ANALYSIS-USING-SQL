--Create table
CREATE TABLE sales_store (
transaction_id VARCHAR(15),
customer_id VARCHAR(15),
customer_name VARCHAR(30),
customer_age INT,
gender VARCHAR(15),
product_id VARCHAR(15),
product_name VARCHAR(15),
product_category VARCHAR(15),
quantiy INT,
prce FLOAT,
payment_mode VARCHAR(15),
purchase_date DATE,
time_of_purchase TIME,
status VARCHAR(15)
);

--Check no of rows in dataset
select * from sales_store;
select count(*) from sales_store;


--Create copy of dataset
CREATE TABLE sales AS
SELECT * FROM sales_store;

select * from sales;
SELECT count(*) FROM sales;

------------------------------
-------Data Cleaning----------
------------------------------

--Data Cleaning - Step 1: Identifying and Removing Duplicates
---------------------------------------------------------------

select transaction_id , count(*) as Transaction_count
from sales 
group by transaction_id 
having count(transaction_id) > 1;

"TXN855235"
"TXN240646"
"TXN342128"
"TXN981773"

---Check Duplicates with all columns.

WITH cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
from sales
)
SELECT * FROM cte
WHERE row_num > 1
--------------------------------------------
WITH cte AS (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
from sales
)
SELECT * FROM cte
WHERE transaction_id IN ('TXN855235','TXN240646','TXN342128','TXN981773')

--Delete Duplicates rows

DELETE FROM sales
WHERE ctid IN (
  SELECT ctid
  FROM (
    SELECT ctid,
           ROW_NUMBER() OVER(PARTITION BY transaction_id ORDER BY transaction_id) AS row_num
    FROM sales
  ) sub
  WHERE row_num > 1
);
-----------------------------------------------------------------------------------
-- Data Cleaning - Step 2: Correcting Headers
-----------------------------------------------------------------------------------

ALTER TABLE sales RENAME COLUMN quantiy TO quantity;
ALTER TABLE sales RENAME COLUMN prce TO price;

------------------------------------------------------------
--- Data Cleaning - Step 3: Checking Data Types
-------------------------------------------------------------
SELECT 
    column_name, 
    data_type
FROM 
    information_schema.columns
WHERE 
    table_name = 'sales';

------------------------------------------------------------------	
---Data Cleaning - Step 4: Handling NULL Values
------------------------------------------------------------------

--- Find Null Values

SELECT *
FROM sales 
WHERE transaction_id IS NULL
OR
customer_id IS NULL
OR
customer_name IS NULL
OR
customer_age IS NULL
OR
gender IS NULL
OR
product_id IS NULL
OR
product_name IS NULL
OR
product_category IS NULL
OR
quantity IS NULL
or 
price is null
or
payment_mode is null
or
purchase_date is null
or 
time_of_purchase is null	
or 
status is null

--Deleting row which have null value in transaction_id and customer_id

DELETE FROM sales 
WHERE transaction_id IS NULL

---updating row which have transction_id and all records but dont have customer_id
---1st_step fetch all record by customer_name 'Ehsaan Ram' and 'Damini Raju' . this will provide customer_id
---2nd_step after getting customer_id update customer_id row of 'Ehsaan Ram' and 'Damini Raju' who have missing values.

SELECT * FROM sales 
Where Customer_name='Ehsaan Ram'

UPDATE sales
SET customer_id='CUST9494'
WHERE transaction_id='TXN977900'

SELECT * FROM sales 
Where Customer_name='Damini Raju'

UPDATE sales
SET customer_id='CUST1401'
WHERE transaction_id='TXN985663'

--- Remaining row record null value in customer_name,customer_age,gender
---1st step is to fetch all record through customer_id from this record 
SELECT * FROM sales 
Where Customer_id='CUST1003'

-----2nd step is to update customer_name,customer_age,gender which we got from 1st step
UPDATE sales
SET customer_name='Mahika Saini',customer_age=35,gender='Male'
WHERE transaction_id='TXN432798'

----------------------------------------------------
--- Data Cleaning - Step 5: Standardizing Data
------------------------------------------------------

SELECT DISTINCT gender 
FROM sales

---- update 'M' by 'Male' and 'F' by 'Female'
UPDATE sales
SET gender ='Male'
WHERE gender ='M'

UPDATE sales
SET gender ='Female'
WHERE gender ='F'

SELECT DISTINCT payment_mode 
FROM sales

--- update 'CC' by 'Credit Card' 
UPDATE sales
SET payment_mode ='Credit Card'
WHERE payment_mode ='CC'


-----------------------------------------------------------
--xxxxxxxxxxxxxxxx-----Data Analysis----xxxxxxxxxxxxxxx
-----------------------------------------------------------
---1. Top 5 most selling products by quantity?

SELECT product_name,SUM(quantity)AS total_quantity_sold
FROM sales
where status = 'delivered'
GROUP BY product_name
ORDER BY total_quantity_sold desc
LIMIT 5

--------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
---------------------------------------------------------------------------------

---2.Most frequently cancelled products?

SELECT product_name,COUNT(*)AS cancel_count
FROM sales
where status = 'cancelled'
GROUP BY product_name
ORDER BY cancel_count desc
LIMIT 5

--------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
---------------------------------------------------------------------------------

--3. Peak Purchase Times of day ?

SELECT 
  CASE 
    WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 0 AND 5 THEN 'Night'
    WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM time_of_purchase) BETWEEN 18 AND 23 THEN 'Evening'
  END AS time_of_day,
  COUNT(*) AS total_orders
FROM sales
GROUP BY time_of_day
ORDER BY total_orders DESC;

--------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
---------------------------------------------------------------------------------

---4. Top 5 highest spending customers?

SELECT 
  customer_name,
  SUM(price * quantity) AS total_spend
FROM sales 
GROUP BY customer_name
ORDER BY SUM(price * quantity) DESC
LIMIT 5;

----------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----------------------------------------------------------------------------------

----5. Which product categories generate the highest revenue?

SELECT 
  product_category,
  SUM(price * quantity) AS revenue
FROM sales
GROUP BY product_category
ORDER BY SUM(price * quantity) DESC;

----------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----------------------------------------------------------------------------------

----6. What is the return/cancellation rate per product category?

SELECT 
    product_category,
    ROUND(COUNT(*) FILTER (WHERE status IN ('cancelled', 'returned')) * 100.0 / COUNT(*), 2) || ' %'  
	AS return_cancel_rate
FROM sales
GROUP BY product_category
ORDER BY return_cancel_rate DESC;

----------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----------------------------------------------------------------------------------

----7. What is the most preferred payment mode?

SELECT payment_mode , COUNT(*) as payment_mode_count
from sales
group by payment_mode
order by payment_mode_count desc

----------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----------------------------------------------------------------------------------

----8. Purchasing Behavior by Age Group ?

SELECT MIN(customer_age) ,MAX(customer_age)
from sales
-----------------------------------------------------
SELECT 
    CASE 
        WHEN customer_age BETWEEN 18 AND 27 THEN '18-27'
        WHEN customer_age BETWEEN 28 AND 37 THEN '28-37'
        WHEN customer_age BETWEEN 38 AND 50 THEN '38-50'
        ELSE '51+'
    END AS age_group,
    SUM(price * quantity) AS total_spend
FROM sales
GROUP BY age_group
ORDER BY total_spend DESC;

----------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----------------------------------------------------------------------------------

--9. What’s the monthly sales trend?

SELECT 
    TO_CHAR(purchase_date, 'YYYY-MM') AS month_year,
    SUM(price * quantity) AS total_sales,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY TO_CHAR(purchase_date, 'YYYY-MM')
ORDER BY month_year

----------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----------------------------------------------------------------------------------

--- 10. Gender-Based Product categories Preferences ?

SELECT
    product_category,
    COUNT(CASE WHEN gender = 'Male' THEN 1 END) AS Male,
    COUNT(CASE WHEN gender = 'Female' THEN 1 END) AS Female
FROM sales
GROUP BY product_category
ORDER BY product_category;

----------------------------------------------------------------------------------
---XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
----------------------------------------------------------------------------------


