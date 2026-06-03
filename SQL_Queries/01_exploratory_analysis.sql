# 1. Order Date Range

SELECT  MIN(order_purchase_timestamp) as first_order_date, 
MAX(order_purchase_timestamp) as last_order_date 
FROM `target.orders` ;

# 2. Cities and States Count

SELECT FORMAT_DATE('%Y', o.order_purchase_timestamp) AS Year, 
COUNT(DISTINCT c.customer_city) AS city_count, 
COUNT(DISTINCT c.customer_state) AS state_count 
FROM `target.orders` o INNER JOIN `target.customers` c ON o.customer_id = c.customer_id 
GROUP BY Year 
ORDER BY Year ASC; 
