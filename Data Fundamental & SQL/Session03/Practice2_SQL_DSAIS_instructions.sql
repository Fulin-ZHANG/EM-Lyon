-- MSc in DSAIS 
-- 2022-2023 
-- emlyon 
-- ----------
-- 7MPDFS - Data Fundamentals & SQL
-- B. Loeillet & S. Abad

-- ----------
-- More complex SQL queries 

-- Reminder: Which playlist or playlists have no tracks? 
USE Chinook;
DESCRIBE Track;
SELECT * FROM Track;

SELECT pl.PlaylistId, pl.Name
FROM PlaylistTrack AS plt
RIGHT JOIN Playlist AS pl ON pl.PlaylistId = plt.PlaylistId
GROUP BY pl.PlaylistId
HAVING COUNT(plt.TrackId) = 0;

-- Another way to do so by checking the count of tracks in each playlist



-- With a sub-querying approach 
SELECT pl.PlaylistId, pl.Name
FROM Playlist AS pl
WHERE pl.PlaylistId NOT IN (
    SELECT DISTINCT PlaylistId
    FROM PlaylistTrack
);


-- A double join 
-- Count the number of playlists for each genre. 
-- Order the results by most to least popular genre.
SELECT COUNT(plt.PlaylistId) AS num_pl, t.GenreId, g.Name
FROM Track as t
LEFT JOIN PlaylistTrack AS plt ON t.TrackId = plt.TrackId
LEFT JOIN Genre AS g ON t.GenreId = g.GenreId
GROUP BY t.GenreId
ORDER BY num_pl DESC;




-- -----
-- Moving to movies database
Use movies; 

-- Explore the tables we have in this new database
SHOW TABLES;

-- A bit of joining 
SELECT * FROM movies.movies;
SELECT * FROM movies.ratings;
SELECT * FROM movies.tags;
-- Join the ratings and tags table by movies.  
-- Use an inner join. Explain the number of row returned.
SELECT COUNT(*)
FROM movies;

SELECT COUNT(*)
FROM movies AS m
INNER JOIN ratings AS r ON m.movieId = r.movieId
INNER JOIN tags AS t ON m.movieId = t.movieId;


-- Display the title, genre, tags and ratings 
-- for each movie that have been given 
-- at least one tag and one rating 
-- (and whose genre is known)




-- Date manipulation 
-- Tip: Use From_Unixtime to convert timestamp
SELECT from_unixtime(timestamp)
FROM tags;


-- How many tags were made in each year?
-- Keep only the years for which 
-- at least 5 different users have given a tag
-- You can either use the SUBSTRING function 
-- or pre-defined functions in SQL.
WITH YearlyData AS (
    -- Extracting the year from the timestamp and counting distinct users for each year
    SELECT 
        YEAR(FROM_UNIXTIME(timestamp)) AS tag_year,
        COUNT(DISTINCT userId) AS distinct_users, 
        COUNT(*) AS tag_count
    FROM tags
    GROUP BY tag_year
    HAVING distinct_users >= 5  -- Filtering out years with less than 5 distinct users
)

SELECT 
    tag_year, 
    SUM(tag_count) AS total_tags
FROM YearlyData
GROUP BY tag_year
ORDER BY tag_year;



-- Is there some films among the 5 best rated films 
-- (considering only movies that received at least 10 ratings) 
-- that did not get any tag?
WITH overTenRatings AS(
	SELECT moviesId
    FROM ratings
    GROUP BY moviesId
    HAVING num_rating >= 10
)

SELECT 




-- Execution time challenge 
-- To understand the importance of sub-querying

-- Query the average movie rating for each genre, only for ratings made in December.  
-- Order from best to worst genre.  
-- Only include genres that have at least 10 ratings for their movies. 
-- Note: this query could take up to a few seconds to return.




-- Find the 5 films that have received most ratings 
-- (ratings table). 
-- Display the title and the genres of the films 
-- in your result.




-- Select the list of user that gave its minimum rating to the film with id 160 
 -- Tip: First write a query to find the minimum rating 
 -- for film 160 then use it inside another query.



-- List all users that have rated the 2nd most often rated film.



-- With only one query, list all users that have rated the 2 most rated films.



-- What is the average rating per film? Be sure to not include any duplicata  
-- (i.e. the same rating given by the same user to the same movie, regardless of the timstamp). 
-- Order them by movieId. 




-- What is the min, max and average number of tags per film? 
-- Be sure to not include any duplicata  
-- (i.e. the same tag given by the same user to the same movie, regardless of the timstamp). 
-- Order them by movieId.




-- --------
-- Additional content to manipulate data 

-- CONCAT 
-- Turn the data from the opus table into a unique column of description.
-- The template for the description should be 
-- "[title of movie] was produced in [year] and and is ..h..min long".
-- You can either use some math or sql date and time functions. 
-- Be careful not to include films whose duration is missing



-- CASE 
-- Extract all data from the rating table 
-- And add one additional column in which
-- we will compute categorical data about rating level (scale from 0 to 5)
-- rating <= 2.5 => bad 
-- 2.5 > rating >= 3.5 => 'can be watched'
-- 3.5 > rating >= 4.5 => 'good'
-- rating > 4.5 => 'excellent'




-- CAST keyword 
-- Extract data from num_voted_users from metadata table 
-- But only integer type values 

