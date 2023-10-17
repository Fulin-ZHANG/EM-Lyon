-- MSc in DSAIS 
-- 2023-2024
-- emlyon 
-- ----------
-- 7MPDFS - Data Fundamentals & SQL
-- B. Loeillet 

-- ----------
-- Introduction to SQL language
-- Basic queries 

SHOW databases; -- to view all databases
-- Connection to a specific database
-- (also double-clcking on displayed schema on left)
USE Chinook; -- to select a database
SHOW TABLES; -- to see all the tables in the selected database
DESCRIBE Track; -- to view the structure of a table


-- 1st round of practice

-- Connection to a specific database
-- (also double-clcking on displayed schema on left)
USE Chinook;
describe Track; 

-- Exploration of the Track table in the Chinook database
SELECT * FROM Track;

-- Category: 
-- Playing with conditions

-- Extract data from the Track table
-- composed by AC/DC and Queen bands
SELECT * FROM Chinook.Track
WHERE Composer like "AC/DC" or Composer like "Queen";

SELECT * FROM Chinook.Track
WHERE Composer in ("AC/DC","Queen");

-- Extract the data about songs with name starting by let'
-- Extract the data about songs with name containing good in it
-- Extract the data about songs with name ending by you
SELECT * FROM Track
WHERE Name LIKE "Let'%";

SELECT * FROM Track
WHERE Name LIKE "%good%";

SELECT * FROM Track
WHERE Name LIKE "%you";

-- Extract the data about songs which length is from 230 et 240 seconds and order them from the longest to the shortest
SELECT * FROM Chinook.Track
Where Milliseconds >= 230000 and Milliseconds <=240000
Order by Milliseconds desc; 


-- Category: 
-- Identifying and dealing with NULL values

-- List all rows where Composer is missing
select * from Track 
Where Composer is NULL; 

-- List unique composers in this table 
-- and order them alphabetically
select distinct Composer 
from Track 
order by Composer ASC; 


-- -------------------
-- 2nd round of practice

-- Count the number of tracks you have for AC/DC  
-- Count the number of tracks you have in Queen
SELECT Count(*) FROM Chinook.Track
WHERE Composer like "AC/DC";
SELECT Count(*) FROM Chinook.Track
WHERE Composer like "Queen";


-- Extract the top 10 composers ordered 
-- from the longest average length of tracks 
-- and count the number of album the composer appear in 
SELECT Composer, AVG(Milliseconds)/1000 AS AvgLength, COUNT(AlbumId) AS NBAlbum
FROM Track
GROUP BY Composer
ORDER BY AvgLength DESC
LIMIT 10;

-- Compute the average length of songs by album 
-- and count the number of songs by album
-- Then order by the number of songs descending
SELECT AlbumId, COUNT(Name) AS NbTrack, 
AVG(Milliseconds/1000) AS AvgLength 
FROM Track
GROUP BY ALbumId
ORDER BY NbTrack DESC;


-- Count the number of tracks for each Composer 
-- and in each genreId
-- order descendingly 
select Composer, GenreId, Count(*) as NbTrack
from Track 
group by Composer, GenreId
order by NbTrack desc
;


-- Which composer has the highest total number of track 
-- duplications in the database? 
SELECT Composer, COUNT(DISTINCT Name), COUNT(Name), 
COUNT(Name)-COUNT(DISTINCT Name) AS Diff, 
COUNT(DISTINCT AlbumId) AS NbAlbum 
FROM Track 
GROUP BY Composer 
ORDER BY Diff DESC 
LIMIT 10;


-- ------
-- Explore PlaylistTrack table

-- How many track does each playlist have? Order from largest to smallest playlist.


-- Count the number of tracks for each playlist that have more than 100 tracks.



-- -------------------
-- 3rd round of practice

-- Category: 
-- Joining data from 2 tables 

-- Have a look at Playlist table and 
-- Join tables PlaylistTrack & Playlist



-- How many track does each playlist have 
-- (group data using PlaylistId) ? 
-- Show the name of the playlist in your result.



-- Same query, but group it by Name. Explain the result.




-- Here without Joins
-- Count the number of albums for each genre. 
-- Order the results by most to least popular genre.




-- Show the same result and add the name of the genre
-- using a join




-- Which playlist or playlists have no tracks? 





-- Multiple ways to do so by checking the count of tracks in each playlist





-- Count the number of playlists for each genre.
-- (Tip: List here the GenreId, the name of genre associated 
-- and the count of nber of playlists.)
-- Order the results by most to least popular genre.


