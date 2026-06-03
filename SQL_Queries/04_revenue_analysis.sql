# 1. YoY Order Value Growth

 raw_data AS( 
                         SELECT EXTRACT(DATE FROM order_purchase_timestamp) AS order_date, 
                        ROUND(SUM(payment_value),2) AS total_cost 
 
                  FROM `target.orders` o INNER JOIN `target.payments` p ON o.order_id =  p.order_id  
                  GROUP BY order_date 
                  ORDER BY total_cost DESC 
                ), 
date_bin AS ( 
                SELECT order_date, 
                      total_cost 
                FROM raw_data 
                WHERE order_date BETWEEN '2017-01-01' AND '2017-08-31' OR order_date BETWEEN 
'2018-01-01' AND '2018-08-31' 
                ORDER BY order_date ASC 
            ), 
extract_year as ( 
                SELECT EXTRACT(YEAR FROM order_date) AS year, 
                             ROUND(SUM(total_cost),2) as curr_yr_cost 
                FROM date_bin 
                GROUP BY year  
                ORDER BY year ASC 
               ), 
cal_nxt as ( 
              SELECT  year, 
                      curr_yr_cost, 
                      LEAD(curr_yr_cost,1) OVER(ORDER BY year) as nxt_yr_cost  
              FROM extract_year 
              ORDER BY year ASC 
           ) 
 
SELECT   
            ROUND(100*(nxt_yr_cost - curr_yr_cost)/curr_yr_cost,2) as perc_increase 
FROM cal_nxt 
WHERE nxt_yr_cost IS NOT NULL; 

# 2. Average Order Value by State

SELECT c.customer_state AS state, 
ROUND(SUM(oi.price),2) AS total_order_price, 
ROUND(SUM(oi.price)/COUNT(DISTINCT o.order_id),2) AS avg_order_price 
FROM `target.order_items` oi INNER JOIN `target.orders` o ON oi.order_id = o.order_id  INNER JOIN 
`target.customers` c ON c.customer_id = o.customer_id  
GROUP BY state 
ORDER BY total_order_price DESC; 

# 3. Average Order Freight Value by State

SELECT    c.customer_state AS state, 
ROUND(SUM(oi.freight_value),2) AS total_fv, 
ROUND(SUM(oi.freight_value)/COUNT(DISTINCT oi.order_id),2) AS avg_fv 
FROM `target.order_items` oi INNER JOIN `target.orders` o ON oi.order_id = o.order_id INNER JOIN 
`target.customers` c ON o.customer_id = c.customer_id 
GROUP BY state 
ORDER BY total_fv DESC; 






