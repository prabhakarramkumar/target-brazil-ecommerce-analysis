# 1. Yearly Order Growth

SELECT  FORMAT_DATETIME("%Y", order_purchase_timestamp) AS year, 
COUNT(*) AS orders_placed 
FROM `target.orders` 
GROUP BY year 
ORDER BY year ASC;

# 2. Monthly Seasonality

SELECT  FORMAT_DATETIME("%m", order_purchase_timestamp) AS month, 
COUNT(*) AS orders_placed 
FROM `target.orders` 
GROUP BY month 
ORDER BY month ASC; 

# 3. Time of Day Analysis

WITH raw as ( 
SELECT  CAST(FORMAT_DATETIME("%H", order_purchase_timestamp) AS INT) AS hour, 
        COUNT(*) AS orders_placed 
FROM `target.orders` 
GROUP BY hour 
), 
 
sq_time_of_day AS ( 
SELECT  
       CASE WHEN hour BETWEEN 00 AND 06 THEN 'Dawn' 
               WHEN hour BETWEEN 7 AND 12 THEN 'Mornings' 
                WHEN hour BETWEEN 13 AND 18 THEN 'Afternoon' 
              WHEN hour BETWEEN 19 AND 23 THEN 'Night' 
        END as time_of_day, 
        orders_placed 
FROM raw 
ORDER BY 2 DESC 
) 
 
SELECT time_of_day, 
              SUM(orders_placed) AS total_orders_placed 
FROM sq_time_of_day 
GROUP BY time_of_day 
ORDER BY total_orders_placed DESC 
LIMIT 1;  