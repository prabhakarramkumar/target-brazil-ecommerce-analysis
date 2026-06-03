# 1. Delivery Time and Estimated vs Actual Delivery Difference

SELECT order_id, 
DATE_DIFF(EXTRACT(DATE FROM order_delivered_customer_date), EXTRACT(DATE FROM 
order_purchase_timestamp ), DAY) AS time_to_deliver, 
DATE_DIFF(EXTRACT(DATE FROM order_delivered_customer_date), EXTRACT (DATE FROM 
order_estimated_delivery_date), DAY) AS diff_estimated_delivery 
FROM `target.orders`;

# 2. Top 5 Highest and Lowest Freight States

WITH freight_data AS( 
                      SELECT c.customer_state AS state, 
                            ROUND(SUM(oi.freight_value)/COUNT(DISTINCT oi.order_id),2) AS avg_freight_value 
                      FROM `target.order_items` oi INNER JOIN `target.orders` o ON oi.order_id = o.order_id  
                            INNER JOIN `target.customers` c ON c.customer_id = o.customer_id 
                      GROUP BY state 
                    ), 
 
top_high AS ( 
                SELECT state, 
                      avg_freight_value, 
                      ROW_NUMBER() OVER(ORDER BY avg_freight_value DESC) AS rnk, 
                      'highest'AS category 
                FROM freight_data 
                ORDER BY avg_freight_value DESC 
                LIMIT 5 
             ), 
 
top_low AS ( 
              SELECT state, 
                    avg_freight_value , 
                    ROW_NUMBER() OVER(ORDER BY avg_freight_value ASC) AS rnk, 
                    'lowest' AS category 
              FROM freight_data 
              ORDER BY avg_freight_value ASC 
              LIMIT 5 
            ) 
 
SELECT state, 
       avg_freight_value, 
       rnk as rank, 
       category 
FROM top_high 
UNION ALL  
SELECT state, 
       avg_freight_value , 
       rnk as rank, 
       category 
FROM top_low ; 

# 3. Top 5 Highest and Lowest Delivery Time States

WITH state_orders AS ( 
                        SELECT o.order_id, 
                              c.customer_state AS state, 
                              EXTRACT(DATE FROM order_delivered_customer_date) AS delivered_date, 
                              EXTRACT(DATE FROM order_purchase_timestamp) AS purchase_date, 
                              DATE_DIFF(EXTRACT(DATE FROM order_delivered_customer_date), EXTRACT(DATE 
FROM order_purchase_timestamp), DAY) AS delivery_time 
                        FROM `target.orders` o INNER JOIN `target.customers` c ON o.customer_id = 
c.customer_id 
                      ), 
 
high AS ( 
          SELECT state, 
                ROUND(SUM(delivery_time)/COUNT(DISTINCT order_id),2) AS avg_delivery_time, 
                'Highest' as category 
          FROM state_orders 
          GROUP BY state 
          ORDER BY avg_delivery_time DESC 
          LIMIT 5 
        ), 
low AS ( 
          SELECT state, 
                ROUND(SUM(delivery_time)/COUNT(DISTINCT order_id),2) AS avg_delivery_time, 
                'Lowest' AS category 
          FROM state_orders 
          GROUP BY state 
          ORDER BY avg_delivery_time ASC 
          LIMIT 5 
        ) 
 
SELECT state, 
       avg_delivery_time, 
       category, 
       ROW_NUMBER() OVER(ORDER BY avg_delivery_time DESC) AS rank 
FROM high 
UNION ALL 
SELECT state, 
       avg_delivery_time, 
       category, 
       ROW_NUMBER() OVER(ORDER BY avg_delivery_time ASC) AS rank 
FROM low; 

# 4. States with Fastest Delivery Compared to Estimated Date

WITH state_orders AS ( 
SELECT c.customer_state AS state, 
       o.order_id, 
       DATE_DIFF(EXTRACT(DATE FROM order_delivered_customer_date), EXTRACT(DATE FROM 
order_estimated_delivery_date), DAY) AS del_diff 
FROM `target.orders` o INNER JOIN `target.customers` c ON o.customer_id = c.customer_id 
WHERE order_delivered_customer_date IS NOT NULL 
) 
 
SELECT state, 
       ROUND(AVG(del_diff),2) AS avg_del_diff 
FROM state_orders 
GROUP BY state 
ORDER BY avg_del_diff ASC 
LIMIT 5;
