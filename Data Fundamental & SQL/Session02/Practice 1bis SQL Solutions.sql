SHOW databases; -- to view all databases
USE Chinook; -- to select a database
SHOW TABLES; -- to see all the tables in the selected database
DESCRIBE Chinook.Customer; -- to view the structure of a table

-- QUERY 1
-- Exploration of the Customer table in the Chinook database
SELECT * 
FROM Chinook.Customer;

SELECT * 
FROM Customer;

-- QUERY 2
-- Extract CustomerId, Company and City data from the customer table in the Chinook database
-- When selecting fields, pay attention to field names, any simple typos will return errors
SELECT CustomerId, Company, City 
FROM Chinook.Customer;

-- QUERY 3
-- Extract the Lastname, Firstname, email and city from the same table
SELECT LastName, FirstName, Email, City 
FROM Chinook.Customer;

-- QUERY 4 - matching a sequence of charactors (zero or more characters are supported)
-- Extract the Lastname, Firstname, email, city and country from the same table, and
-- Select only the country starting with "AUSTR"
-- What do you observe? 
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country LIKE "Austr%";
-- Now practice with City and Country fields using different names, for example:

SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country LIKE "%land";

-- Now use NOT LIKE instead of LIKE

SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country NOT LIKE "%zil";

-- QUERY 5 Exact string comparison (Case insensitive)
-- Extract the Lastname, Firstname, email, city and country from the same table, and
-- only from USA and Canada

-- Method 1 Exact string comparison/matching
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country IN ("USA","Canada"); 
-- more efficient when dealing with a larger number of values since it only requires a single comparison

-- Method 2 Exact string comparison/matching
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country = "USA" OR Country = "Canada"; 
-- less efficient as it requires two comparisons to be made. 

-- Method 3 Similar pattern comparison
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country LIKE "USA" or Country LIKE "Canada"; 
-- Can be useful inpattern matching especially when used together with the wildcard %

-- QUERY 6
-- Use the previous query and order the extracted data by lastname ascending
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country IN ("USA","Canada")
ORDER BY LastName ASC;
-- compare with:
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country IN ("USA","Canada")
ORDER BY LastName DESC;

-- QUERY 7
-- On the previous query, extract only the top 5 data in alphabetical order
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country in ("USA","Canada")
ORDER BY LastName ASC
LIMIT 5;

-- QUERY 8
-- Still on the same query, extract the top 5 data starting at row 5
SELECT LastName, FirstName, Email, City, Country 
FROM Chinook.Customer
WHERE Country in ("USA","Canada")
ORDER BY LastName ASC
LIMIT 5
OFFSET 4;

-- QUERY 9
-- Count the number of clients you have in USA 
-- Count the number of clients you have in Canada
SELECT COUNT(*) FROM Chinook.Customer 
WHERE Country LIKE "USA"; 

SELECT COUNT(Country) FROM Chinook.Customer
WHERE Country LIKE "USA";

SELECT COUNT(*) FROM Chinook.Customer 
WHERE Country LIKE "Canada"; 

SELECT COUNT(Country) FROM Chinook.Customer
WHERE Country LIKE "Canada";

-- QUERY 10
-- Count the number of clients you have in Berlin 
-- Count the number of clients you have in Paris
SELECT COUNT(City) FROM Chinook.Customer
WHERE City LIKE "Berlin";

SELECT COUNT(City) FROM Chinook.Customer
WHERE City LIKE "Paris";

-- QUERY 11
-- Could we do the 4 previous queries in only two queries (one for city, one for country)? 
SELECT Country, COUNT(Country) FROM Chinook.Customer
WHERE Country IN ("USA","Canada")
GROUP BY Country;

SELECT City, COUNT(City) FROM Chinook.Customer
WHERE City IN ("Paris","Berlin")
GROUP BY City;

-- QUERY 12
-- Count the number of clients per country and order them from the largest to the smallest.
SELECT Country, COUNT(Country) FROM Chinook.Customer
GROUP BY Country
ORDER BY COUNT(Country) DESC;

------------------------------------------------------------ 

-- Let's change table ! 
-- Explore the Track table
SELECT * FROM Track; 


-- QUERY 15
-- Extract data from the top 10 long songs which cost 0.99 
SELECT * FROM Track
WHERE UnitPrice=0.99
ORDER BY milliseconds DESC LIMIT 10;

SELECT * FROM Chinook.Track
WHERE UnitPrice = 0.99
ORDER BY Milliseconds DESC
LIMIT 10;



-- QUERY 16
-- Extract the different prices applied to the songs
-- Extract the number of different composers from the table
SELECT DISTINCT(UnitPrice) 
FROM Chinook.Track;

SELECT COUNT(DISTINCT Composer) 
FROM Chinook.Track;


-- QUERY 17
-- Extract data of songs which genreid is 20 and album id is 253.
-- Order them by the id of each track



-- QUERY 18
-- Calculate the length of songs in seconds
SELECT Name, Milliseconds/1000 
FROM Chinook.Track;

SELECT Name, ROUND(Milliseconds/1000) AS Seconds
FROM Chinook.Track;

-- QUERY 19
-- Calculate the average length of songs by album and count the number of songs by album
-- Order by the number of songs descending
SELECT AlbumId, COUNT(AlbumId) AS AlbumIdCount, AVG(Milliseconds/1000) AS SongLength 
FROM Chinook.Track
GROUP BY AlbumId
ORDER BY AlbumIdCount DESC;

-- QUERY 20 / Review
-- Extract the top 10 composers ordered from the longest average length of tracks and count the number of album the composer appears in 
SELECT Composer, AVG(Milliseconds)/1000 AS AvgLength, COUNT(DISTINCT AlbumId) AS NBAlbum
FROM Chinook.Track
GROUP BY Composer
ORDER BY AvgLength DESC
LIMIT 10;
