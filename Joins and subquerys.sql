--1. List all customers who live in Texas (use JOINs)

SELECT c.customer_id, c.first_name, c.last_name, a.postal_code
FROM customer c
FULL JOIN address a ON c.address_id = a.address_id
WHERE 
  (a.postal_code ~ E'^\\d+$') -- Check if postal_code is numeric
  AND (a.postal_code::integer > 70000) AND (a.postal_code::integer < 79000);
--56 people live in texas

--2. Get all payments above $6.99 with the Customer's Full Name
select First_name, Last_name, amount
from customer 
full join payment 
on customer.customer_id = payment.customer_id 
where amount > 6.99
order by amount desc
--32 people had orders over $6.99


--3. Show all customers names who have made payments over $175(usesubqueries)
SELECT customer.First_name, customer.Last_name, payment.amount
FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IN (
    SELECT payment.customer_id
    FROM payment
    GROUP BY payment.customer_id
    HAVING SUM(payment.amount) > 175
)
ORDER BY payment.amount DESC;
--two peoplw made payments over %174


--4. List all customers that live in Nepal (use the city table)
SELECT customer.first_name, customer.last_name, country.country 
FROM country
LEFT JOIN city 
ON country.country_id = city.city_id
LEFT JOIN address
ON city.city_id = address.city_id
LEFT join customer 
on address.address_id = customer.address_id
WHERE country.country  = 'Nepal';
 --Nicholas Barfield lives in Nepal and thats all



--5. Which staff member had the most transactions?


SELECT staff.first_name, staff.last_name, staff.staff_id, SUM(payment.amount) AS total_amount
FROM staff
LEFT  JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.first_name, staff.last_name, staff.staff_id
ORDER BY total_amount DESC;
--Mike Hillyer had the most sales totaling -3,018,430.69... rentals are not a good buisness to be in



--6. How many movies of each rating are there?
select COUNT(distinct rating)
from film;
select rating, COUNT(*) as movie_count
from film 
group by rating
order by movie_count desc
-- PG-13 has the most at 224, and NC-17 has the second most at 209


--7.Show all customers who have made a single payment above $6.99 (Use Subqueries)
select customer_id, amount
from payment
where amount >6.99
order by amount DESC


--8. How many free rentals did our stores give away?
select rental.rental_id, payment.amount
from payment 
full join rental
on rental.rental_id = payment.rental_id
group by payment.amount, rental.rental_id
having amount < 0
order by rental_id 
