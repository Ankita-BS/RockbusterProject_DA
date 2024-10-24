#CTE Query to find the average amount paid by the top 5 customers.

WITH total_amount_paid (customer_id, first_name, last_name,country,city,total_amount_paid ) AS
(
	SELECT Cu.customer_id,Cu.first_name, Cu.last_name, D.country,C.city,
	SUM(P.amount) AS total_amount_paid
	FROM customer Cu
	INNER JOIN payment P on Cu.customer_id = P.customer_id
	INNER JOIN address B ON Cu.address_id=B.address_id
	INNER JOIN city C ON B.city_id=C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	WHERE C.city IN 
	(
	SELECT   C.city
	FROM customer A 
	INNER JOIN address B ON A.address_id=B.address_id
	INNER JOIN city C ON B.city_id=C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	WHERE D.country IN 
	(SELECT  D.country 
	FROM customer A 
	INNER JOIN address B ON A.address_id=B.address_id
	INNER JOIN city C ON B.city_id=C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	GROUP BY  D.country
	ORDER BY count(A.customer_id) DESC
	LIMIT 10)
	GROUP BY D.country, C.city
	ORDER BY count(A.customer_id) DESC
	LIMIT 10
	)
	GROUP BY Cu.customer_id , C.city, D.country
	ORDER BY sum(P.amount) DESC
	LIMIT 5
	) 
SELECT AVG(total_amount_paid.total_amount_paid) AS Average_amount
FROM total_amount_paid;


# SQL CTE Query to find out how many of the top 5 customers above are based in each country.

WITH top_5_customers (customer_id,first_name, last_name, country,city) AS
(
	SELECT Cu.customer_id,Cu.first_name, Cu.last_name, D.country,C.city,
	SUM(P.amount) AS total_amount_paid
	FROM customer Cu
	INNER JOIN payment P on Cu.customer_id = P.customer_id
	INNER JOIN address B ON Cu.address_id=B.address_id
	INNER JOIN city C ON B.city_id=C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	WHERE C.city IN 
	(
	SELECT   C.city
	FROM customer A 
	INNER JOIN address B ON A.address_id=B.address_id
	INNER JOIN city C ON B.city_id=C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	WHERE D.country IN 
	(SELECT  D.country 
	FROM customer A 
	INNER JOIN address B ON A.address_id=B.address_id
	INNER JOIN city C ON B.city_id=C.city_id
	INNER JOIN country D ON C.country_id = D.country_id
	GROUP BY  D.country
	ORDER BY count(A.customer_id) DESC
	LIMIT 10)
	GROUP BY D.country, C.city
	ORDER BY count(A.customer_id) DESC
	LIMIT 10
	)
	GROUP BY Cu.customer_id , C.city, D.country
	ORDER BY sum(P.amount) DESC
	LIMIT 5),
 outer_query (country,all_customer_count) AS	
(	SELECT  D.country ,count ( DISTINCT A.customer_id) AS all_customer_count
 	FROM customer A 
 	INNER JOIN address B ON A.address_id=B.address_id
 	INNER JOIN city C ON B.city_id=C.city_id
 	INNER JOIN country D ON C.country_id = D.country_id
 	GROUP BY  D.country
	ORDER BY count (DISTINCT A.customer_id) DESC )
SELECT outer_query.country, outer_query.all_customer_count, count(top_5_customers.customer_id) AS top_customer_count 
	FROM  outer_query LEFT JOIN  top_5_customers
    	ON outer_query.country = top_5_customers.country
 	GROUP BY outer_query.country, outer_query.all_customer_count
	ORDER BY outer_query.all_customer_count DESC ;
