select w.orders, count(w.customer_id) From 
(select customer_id, count(payment_id) as orders from payment
GROUP BY 1) as w
GROUP BY 1;
SELECT * FROM payment;
SELECT 
	payment_id,
    customer_id,
CASE WHEN amount < 0.99 then 'low'
	WHEN amount <=5.99 then 'medium'
    WHEN amount <=9.99 then 'high'
    end as amount_range
FROM payment;
SELECT round(amount, 0) bin,
count(customer_id) customers
FROM payment
GROUP BY 1;

SELECT log(amount) as bin,
count(customer_id) as customers
FROM payment
GROUP BY 1;

SELECT tile,
min(amount) as lower_bound,
max(amount) as upper_bound,
count(payment_id) as orders
FROM
(
	SELECT customer_id, payment_id, amount,
    ntile(10) OVER (ORDER BY amount) as tile
    FROM payment
) a
GROUP BY 1;
-- Finding missing data
SELECT DISTINCT a.customer_id
FROM payment a
LEFT JOIN customer b ON a.customer_id = b.customer_id
WHERE b.customer_id is NULL ;

SELECT customer_id,
		sum(amount) as total_amount
FROM payment
GROUP BY 1;

SELECT payment_date,
	sum(CASE WHEN rental_id = 573 Then amount else 0 end) as rental_573,
    sum(CASE WHEN rental_id = 1476 THEN amount else 0 END) as rental_1476
FROM payment
GROUP BY 1;
		

