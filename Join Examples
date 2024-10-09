# SQL query to find the top 10 countries for Rockbuster in terms of customer numbers. 
SELECT D.country,count(A.customer_id) AS Number_of_Customers
	FROM customer A 
	inner join address B ON A.address_id=B.address_id
	inner join city C ON B.city_id=C.city_id
	inner join country D on C.country_id = D.country_id
	GROUP BY country
	ORDER BY Number_of_Customers DESC
	LIMIT 10;


# SQL query to identify the top 10 cities that fall within the top 10 countries I identified above.
SELECT  D.country, C.city, count(A.customer_id) AS Number_of_customers
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
	LIMIT 10;


# SQL query to find the top 5 customers from the top 10 cities above who’ve paid the highest total amounts to Rockbuster. 
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
	LIMIT 5;

