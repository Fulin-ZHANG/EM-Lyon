SHOW databases; -- to view all databases
USE Chinook; -- to select a database
SHOW TABLES; -- to see all the tables in the selected database
DESCRIBE Customer; -- to view the structure of a table

-- QUERY 1
-- Exploration of the Customer table in the Chinook database
SELECT * FROM Customer; 

-- QUERY 2
-- Extract CustomerId, Company and City data from the customer table in the Chinook database
-- When selecting fields, pay attention to field names, any simple typos will return errors
SELECT CustomerId, Company, City
FROM Customer;

-- QUERY 3
-- Extract the Lastname, Firstname, email and city from the same table
 SELECT LastName, FirstName, Email, City
 FROM Customer;

-- QUERY 4 - matching a sequence of charactors (zero or more characters are supported)
-- Extract the Lastname, Firstname, email, city and country from the same table, and
-- Select only the country starting with "AUSTR"
-- What do you observe? 
-- Now practice with City and Country fields using different names, for example:
-- Now use NOT LIKE instead of LIKE
SELECT LastName, FirstName, Email, City, Country
FROM Customer
WHERE Country LIKE "AUSTR%";

-- QUERY 5 String comparison (Case insensitive)
-- Extract the Lastname, Firstname, email, city and country from the same table, and
-- only from USA and Canada
SELECT LastName, FirstName, Email, City, Country
FROM Customer
WHERE Country LIKE "%USA%" OR Country LIKE "%Canada%";



-- QUERY 6
-- Use the previous query and order the extracted data by lastname ascending
SELECT LastName, FirstName, Email, City, Country
FROM Customer
WHERE Country LIKE "%USA%" OR Country LIKE "%Canada%"
ORDER BY LastName ASC;


-- QUERY 7
-- On the previous query, 
-- extract only the top 5 data in alphabetical order
SELECT LastName, FirstName, Email, City, Country
FROM Customer
WHERE Country LIKE "%USA%" OR Country LIKE "%Canada%"
ORDER BY LastName ASC
LIMIT 5;


-- QUERY 8
-- Still on the same query, extract the top 5 data starting at row 5
SELECT LastName, FirstName, Email, City, Country
FROM Customer
WHERE Country LIKE "%USA%" OR Country LIKE "%Canada%"
ORDER BY LastName ASC
LIMIT 10 OFFSET 5;



-- QUERY 9
-- Count the number of clients you have in USA 
-- Count the number of clients you have in Canada
SELECT LastName, FirstName, Email, City, Country
FROM Customer
WHERE Country LIKE "%USA%" OR Country LIKE "%Canada%"
ORDER BY LastName ASC
LIMIT 10 OFFSET 5;



-- QUERY 10
-- Count the number of clients you have in Berlin 
-- Count the number of clients you have in Paris
SELECT COUNT(CustomerId)
FROM Customer
WHERE City LIKE "%Berlin%";
SELECT COUNT(CustomerId)
FROM Customer
WHERE City LIKE "%Paris%";


-- QUERY 11
-- Could we do the 4 previous queries in only two queries (one for city, one for country)? 
SELECT COUNT(CustomerId)
FROM Customer
WHERE Country LIKE "%US%" OR Country LIKE "%Canada%";

SELECT COUNT(CustomerId)
FROM Customer
WHERE City LIKE "%Berlin%" OR City LIKE "%Paris%";

-- QUERY 12
-- Count the number of clients per country and order them from the largest to the smallest.
SELECT COUNT(CustomerId)
FROM Customer
GROUP BY Country
ORDER BY COUNT(CustomerId) DESC;


------------------------------------------------------------ 

-- Let's change table ! 
-- Explore the Track table
SELECT * FROM Track; 
DESCRIBE Track;

-- QUERY 15
-- Extract data from the top 10 long songs which cost 0.99 
SELECT Name
FROM Track
WHERE UnitPrice = 0.99
ORDER BY Milliseconds DESC;

-- QUERY 16
-- Extract the different prices applied to the songs
-- Extract the number of different composers from the table
SELECT DISTINCT UnitPrice
FROM Track;
SELECT DISTINCT Composer
FROM Track;

-- QUERY 17
-- Extract data of songs which genreId is 20 and album id is 253.
-- Order them by the id of each track
SELECT *
FROM Track
WHERE Genreld = 20 AND AlbumId = 253;
DESCRIBE Track;

-- QUERY 18
-- Calculate the length of songs in seconds
SELECT Milliseconds/1000 AS Second
FROM Track;


-- QUERY 19
-- Calculate the average length of songs by album and count the number of songs by album
-- Order by the number of songs descending
SELECT AVG(Milliseconds/1000) AS avg_lenth, COUNT(Name)
FROM Track
GROUP BY AlbumId
ORDER BY COUNT(Name) DESC;


-- QUERY 20 / Review
-- Extract the top 10 composers ordered from the longest average length of tracks 
-- and count the number of album the composer appears in 
SELECT AVG(Milliseconds/1000) AS avg_lenth, COUNT(Composer)
FROM Track
GROUP BY Composer
ORDER BY AVG(Milliseconds/1000) DESC
LIMIT 10;
