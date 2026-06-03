# 1. Orders by State and Month

SELECT c.customer_state as state, 
             FORMAT_DATE("%Y-%m", order_purchase_timestamp) as month, 
             COUNT(*) as orders_placed 
FROM `target.orders`  o INNER JOIN `target.customers` c ON o.customer_id = c.customer_id 
GROUP BY state, month 
ORDER BY month ASC, state ASC; 

# 2. Customer Distribution by State

SELECT c.customer_state AS state, 
COUNT(DISTINCT customer_unique_id) AS no_cust 
FROM  `target.customers` c  
GROUP BY state 
ORDER BY no_cust DESC;
