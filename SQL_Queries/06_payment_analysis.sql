#  1. Month on Month Analysis of orders using different payments

SELECT  
FORMAT_TIMESTAMP("%Y-%m", order_purchase_timestamp) AS month, 
p.payment_type, 
COUNT(o.order_id) AS no_orders 
FROM `target.orders` o INNER JOIN `target.payments` p ON o.order_id = p.order_id  
GROUP BY month,p.payment_type 
ORDER BY month,p.payment_type; 

# 2. Installment Orders

SELECT  payment_installments, 
COUNT(DISTINCT order_id) AS no_of_orders 
FROM `target.payments`  
WHERE payment_installments > 0 
GROUP BY payment_installments 
ORDER BY payment_installments;