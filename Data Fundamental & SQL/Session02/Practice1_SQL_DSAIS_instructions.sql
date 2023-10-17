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
-- Exploration of the Track table in the Chinook database
SELECT *
FROM Track;

SELECT Name, TrackId
FROM Track
WHERE Name LIKE "%way%";


-- Category: 
-- Playing with conditions

-- Extract data from the Track table
-- composed by AC/DC and Queen bands
SELECT *
FROM Track as t
WHERE t.Composer LIKE "%AC/DC%" OR t.Composer LIKE "%Queen%";


-- Extract the data about songs with name starting by let'
SELECT *
FROM Track as t
WHERE t.Name LIKE "let'%";
-- Extract the data about songs with name containing good in it
SELECT *
FROM Track as t
WHERE t.Name LIKE "%good%";
-- Extract the data about songs with name ending by you
SELECT *
FROM Track as t
WHERE t.Name LIKE "%you";

-- Extract the data about songs which 
-- length is from 230 et 240 seconds 
-- and order them from the longest to the shortest

SELECT *
FROM Track as t
WHERE t.Milliseconds BETWEEN 230000 AND 240000
ORDER BY t.Milliseconds DESC;



-- Category: 
-- Identifying and dealing with NULL values

-- List all rows where Composer is missing
SELECT *
FROM Track as t
WHERE t.Composer IS NULL;



-- List unique composers in this table 
-- and order them alphabetically

SELECT DISTINCT t.Composer
FROM Track as t
ORDER BY t.Composer ASC;




-- -------------------
-- 2nd round of practice

-- Count the number of tracks you have for AC/DC  
-- Count the number of tracks you have in Queen
SELECT COUNT(*)
FROM Track as t
WHERE t.Composer LIKE "AC/DC";

SELECT COUNT(*)
FROM Track as t
WHERE t.Composer LIKE "%Queen%";




-- Extract the top 10 composers ordered 
-- from the longest average length of tracks 
-- and count the number of album the composer appear in 

SELECT COUNT(t.AlbumId) AS num_Al, AVG(t.Milliseconds) AS avg_len, t.Composer
FROM Track as t
GROUP BY t.Composer
ORDER BY avg_len DESC
LIMIT 10;




-- Compute the average length of songs by album 
-- and count the number of songs by album
-- Then order by the number of songs descending

SELECT COUNT(Name) AS num_song, AVG(t.Milliseconds) AS avg_len
FROM Track AS t
GROUP BY t.AlbumId
ORDER BY num_song DESC;

-- Count the number of tracks for each Composer 
-- and in each genreId
-- order descendingly 

SELECT COUNT(*)
FROM Track AS t
GROUP BY t.Composer, t.GenreId
ORDER BY COUNT(*) DESC;



-- Which composer has the highest total number of track 
-- duplications in the database? 

SELECT t.Composer, COUNT(*) AS num_track
FROM Track AS t
WHERE t.Composer IS NOT NULL
GROUP BY t.Composer
ORDER BY num_track DESC
LIMIT 1;



-- ------
-- Explore PlaylistTrack table
SELECT *
FROM PlaylistTrack;



-- How many track does each playlist have? 
-- Order from largest to smallest playlist.
SELECT COUNT(p.TrackId) AS num_track, p.PlaylistId
FROM PlaylistTrack as p
GROUP BY p.PlaylistId
ORDER BY num_track DESC;



-- Count the number of tracks for each playlist that 
-- have more than 100 tracks.
SELECT COUNT(p.TrackId) AS num_track, p.PlaylistId
FROM PlaylistTrack as p
GROUP BY p.PlaylistId
HAVING COUNT(p.TrackId) > 100;



-- -------------------
-- 3rd round of practice

-- Category: 
-- Joining data from 2 tables 

-- Have a look at Playlist table and 
-- Join tables PlaylistTrack & Playlist
SELECT plt.*, pt.*
FROM Playlist AS plt
JOIN PlaylistTrack AS pt ON plt.PlaylistId = pt.PlaylistId;



-- How many track does each playlist have 
-- (group data using PlaylistId) ? 
-- Show the name of the playlist in your result.

SELECT COUNT(pt.TrackId) AS num_track, pl.Name
FROM Playlist AS pl
LEFT JOIN PlaylistTrack AS pt ON pl.PlaylistId = pt.PlaylistId
GROUP BY pl.PlaylistId, pl.Name;

-- Same query, but group it by Name. Explain the result.
SELECT COUNT(pt.TrackId) AS num_track, pl.Name
FROM Playlist AS pl
LEFT JOIN PlaylistTrack AS pt ON pl.PlaylistId = pt.PlaylistId
GROUP BY pl.Name;


-- Here without Joins
-- Count the number of albums for each genre. 
-- Order the results by most to least popular genre.
SELECT t.GenreId, COUNT(t.AlbumId) AS num_alb
FROM Track AS t
GROUP BY t.GenreId
ORDER BY NumAlbums DESC;

SELECT * FROM Chinook.Track;

-- Show the same result and add the name of the genre
-- using a join

SELECT g.GenreId, g.Name, COUNT(t.AlbumId) AS num_alb
FROM Genre AS g
LEFT JOIN Track AS t ON g.GenreId = t.GenreId
GROUP BY g.GenreId, g.Name
ORDER BY num_alb DESC;



-- Which playlist or playlists have no tracks? 

SELECT pl.PlaylistId, pl.Name
FROM PlaylistTrack AS plt
RIGHT JOIN Playlist AS pl ON pl.PlaylistId = plt.PlaylistId
GROUP BY pl.PlaylistId
HAVING COUNT(plt.TrackId) = 0;


-- Multiple ways to do so by checking the count of tracks
-- in each playlist
SELECT COUNT(plt.TrackId), pl.PlaylistId
FROM PlaylistTrack AS plt
RIGHT JOIN Playlist AS pl ON pl.PlaylistId = plt.PlaylistId
GROUP BY pl.PlaylistId;



-- Count the number of playlists for each genre.
-- (Tip: List here the GenreId, the name of genre associated 
-- and the count of nber of playlists.)
-- Order the results by most to least popular genre.
SELECT COUNT(plt.PlaylistId) AS num_pl, t.GenreId, g.Name
FROM Track as t
LEFT JOIN PlaylistTrack AS plt ON t.TrackId = plt.TrackId
LEFT JOIN Genre AS g ON t.GenreId = g.GenreId
GROUP BY t.GenreId
ORDER BY num_pl DESC