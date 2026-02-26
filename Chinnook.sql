 SELECT name FROM sqlite_master WHERE type ='table';
-- =====================================
--(Data Filtering) 
-- =====================================
--(1)Customer
SELECT * FROM Customer WHERE city= 'São Paulo';
SELECT * FROM Customer WHERE state is NOT NULL;
SELECT firstname, lastname ,country FROM Customer;
SELECT firstname ,state FROM Customer WHERE company is NOT NULL;
SELECT firstname, lastname ,country FROM Customer WHERE supportrepid =4 ;
--(2)Employee 
SELECT firstname, lastname FROM Employee WHERE reportsto =2;
SELECT firstname, lastname FROM Employee WHERE title ='IT Manager';
SELECT* FROM Employee WHERE city ='Calgary' ;
SELECT firstname,title FROM Employee WHERE reportsto is NULL ;
SELECT title , state FROM Employee WHERE city ='Lethbridge' ;
--(3)Invoice 
SELECT * FROM Invoice WHERE billingstate is not NULL ;
SELECT * FROM Invoice where total >15 ;
SELECT customerid,invoiceid FROM Invoice where billingcountry='USA' ;
SELECT DISTINCT billingcountry,billingstate,billingcity FROM Invoice where (billingpostalcode) = '60316' ;
SELECT * FROM Invoice WHERE billingaddress like 'Th%'; 
SELECT * FROM Invoice WHERE invoicedate like '2009%'; 
SELECT * FROM Invoice ORDER BY total ;
SELECT * FROM Invoice ORDER BY billingcity ;
--4-track 
SELECT* FROM Track WHERE composer is not NULL;
SELECT name,composer FROM Track WHERE genreid >4 ;
SELECT bytes,name FROM Track WHERE milliseconds <=210834 ;
SELECT * FROM Track WHERE name like '%u' AND albumid >120 ;
SELECT * FROM Track WHERE name like '%L' AND albumid <12 ;
--invInvoiceLine 
SELECT * FROM InvoiceLine WHERE trackid=630 OR invoicelineid=1832 ;
SELECT * FROM InvoiceLine WHERE trackid>640;
SELECT *FROM InvoiceLine LIMIT 10 ;
-- =====================================
-- Aggregations 
-- =====================================
select AVG(total) as avg_total from Invoice;
SELECT * FROM Invoice WHERE billingcity is not NULL AND ( total between 10 AND 20) ;

 SELECT AVG(unitprice) AS avg_unit
FROM Track;
SELECT name, composer,
       ROUND((4 * unitprice), 2) AS unit_price
FROM Track
WHERE unitprice > 0.99;
SELECT SUM(Quantity)FROM InvoiceLine;
SELECT MAX(unitprice)FROM InvoiceLine ;
SELECT MIN(unitprice)FROM InvoiceLine ;
-- =====================================
--Joins 
-- =====================================
--1
SELECT Album.title, Artist.name FROM Album JOIN Artist ON Album.ArtistId = Artist.ArtistId ;
--2
SELECT  Album.title FROM Album LEFT JOIN Artist ON Album.ArtistId = Artist.ArtistId ;
--3 
SELECT * FROM Customer LEFT JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId ;
--4 
SELECT firstname,lastname,company FROM Customer JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
where company is NOT NULL;
--5
SELECT * FROM Invoice INNER JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId ;
--6
SELECT billingcity,billingcountry,total FROM Invoice left JOIN InvoiceLine 
ON Invoice.InvoiceId = InvoiceLine.InvoiceId;
--7
SELECT * FROM PlaylistTrack INNER JOIN InvoiceLine ON PlaylistTrack.TrackId = InvoiceLine.TrackId ;
--8
SELECT quantity,unitprice FROM InvoiceLine left JOIN PlaylistTrack ON PlaylistTrack.TrackId = InvoiceLine.TrackId ;
--9
SELECT* FROM Track left JOIN MediaType ON Track.MediaTypeId= MediaType.MediaTypeId ;
--10
SELECT Track.Name ,composer FROM Track left JOIN MediaType ON MediaType.MediaTypeId =Track.MediaTypeId ;
--11
SELECT Track.Name ,composer,bytes FROM Track left JOIN MediaType ON MediaType.MediaTypeId =Track.MediaTypeId 
WHERE bytes BETWEEN 7983270 AND 10402398 ;
--12
SELECT SUM (total) ,country FROM Customer join Invoice ON Customer.CustomerId = Invoice.CustomerId GROUP BY country;
-- =====================================
--insights 
-- =====================================
-- TOTAL revenue Per country 
SELECT SUM(total) AS total_revenue,country FROM Customer join Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY country ORDER by country ;

-- Top revenue per country (invoice table) 
SELECT billingcountry, SUM(total) AS revenue FROM Invoice GROUP BY billingcountry ORDER BY revenue DESC ;

--Top quantity per composer 
SELECT SUM (quantity) as "Total_quantity" ,composer FROM Track join InvoiceLine
ON Track.TrackId = InvoiceLine.TrackId 
GROUP BY composer ORDER BY SUM (quantity) DESC;

--Top 10 customers by spending 
SELECT Customer.CustomerId, FirstName || ' ' ||LastName AS FULL_NAME,
ROUND(SUM(total),2) AS total FROM Customer JOIN Invoice ON Customer.CustomerId =Invoice.CustomerId 
GROUP BY Customer.CustomerId ORDER BY total DESC LIMIT 10;

--Top 5 best selling tracks
SELECT Name AS product_name, SUM(Quantity) AS total_sold FROM InvoiceLine JOIN Track
ON InvoiceLine.TrackId = Track.TrackId GROUP BY Track.Name ORDER BY total_sold DESC LIMIT 5;

--Monthly revenue
SELECT strftime('%Y-%m', InvoiceDate) AS month,SUM(total) AS monthly_revenue
FROM Invoice GROUP BY month ORDER BY month ;
-- =====================================
-- ADVANCED ANALYSIS
-- =====================================
With avg_total As( SELECT* from Invoice 
 WHERE total > (SELECT AVG (total) "Avg total" from Invoice)) SELECT * FROM avg_total ;
 
SELECT billingcity ,billingcountry,billingstate , 
ROW_NUMBER() OVER(PARTITION BY billingpostalcode ORDER BY total DESC ) AS ROW_RANK FROM Invoice
WHERE billingstate is not NULL;

SELECT firstname ,lastname,title , ROW_NUMBER() OVER(PARTITION BY city ORDER by title DESC )  AS cites FROM Employee;

CREATE VIEW [postalcodeT5k] AS 
SELECT firstname , lastname FROM Employee WHERE reportsto >1 ;
SELECT * FROM [postalcodeT5k];


