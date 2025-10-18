
1. Who is the senior most employee based on the title?

select * from employee
order by levels desc
limit 1

2. which countries have the most invoices?

select billing_country, count(billing_country) as count_occ from invoice
group by billing_country
order by count_occ desc
limit 1

3. what are top 3 values of total invoice?

select total from invoice  
order by total desc
limit 3	

4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

select billing_city, sum(total) as total_revenue from invoice
group by billing_city
order by total_revenue desc
limit 1

5: Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money.

SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;


6. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A

select distinct customer.email, customer.first_name, customer.last_name, genre.name from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on invoice_line.track_id=track.track_id
join genre on track.genre_id=genre.genre_id

where genre.name='Rock'
order by email


7.  Lets invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands

select art.artist_id, art.name, count(gnr.name) as rock_songs_count from artist art 
join album alb on art.artist_id=alb.artist_id
join track trc on alb.album_id=trc.album_id
join genre gnr on trc.genre_id=gnr.genre_id

where gnr.name='Rock'
group by art.artist_id
order by rock_songs_count desc
limit 10


8. Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed First.

select name, milliseconds from track
where  milliseconds > (
select avg(milliseconds) from track
)
order by milliseconds desc


9. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.

select c.customer_id, c.first_name, c.last_name, art.name as artist_name, sum(il.unit_price*il.quantity) as total_spent
from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join album alb on t.album_id=alb.album_id
join artist art on alb.artist_id=art.artist_id

group by c.customer_id, c.first_name, c.last_name, art.name
order by customer_id, total_spent desc


10. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.

WITH highest_purchases as (

select c.country, g.name as genre_name, count(invoice_line_id) as top_purchase, 
row_number() over (partition by country order by count(invoice_line_id) desc) as rnk
from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
group by c.country, g.name
order by 1, 3 desc
) 
select * from highest_purchases where rnk=1


11. Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.
dependant-not customer but on invoice generated for ac company, 

WITH top_customers as(

select i.billing_country, c.customer_id, sum(i.total) as total_spent, 
row_number()  over (partition by i.billing_country order by sum(i.total) desc ) as rnk

from invoice i
join customer c on i.customer_id=c.customer_id


group by i.billing_country, c.customer_id
order by 1,3 desc
)
select * from top_customers
where rnk=1