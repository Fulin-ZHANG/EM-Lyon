-- ==================================== --
-- MSc in DSAIS 
-- 2023-2024
-- SQL group exercise 
-- ==================================== --
-- You will work here on the movies database. 
-- You will focus on the table metadata but what we will see is applicable to 
-- the other tables as well.

-- Write down your names here: 
-- Group 12
-- Team mate 1: Fulin ZHANG
-- Team mate 2: Peiwen LIU
-- Team mate 3: Xinyue ZHANG
-- Team mate 4: Yuekai FENG


-- ==================================== --
-- PART ONE: Evaluate data imperfection
-- ==================================== --

-- Exercice 1: Dealing with NULL and N/A
-- We want to be able to study the evolution of the duration of the films through the years. 
-- But first we need to make sure there are no missinmoviesg values.
-- Focus on columns : movie_title, duration, title_year
-- 1) Write a query to know if there are missing values in those columns (be careful about how they are represented!)
USE movies;

SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN movie_title IS NULL OR movie_title = '' THEN 1 ELSE 0 END) AS missing_movie_titles,
    SUM(CASE WHEN duration IS NULL OR duration = 0 OR duration = '' THEN 1 ELSE 0 END) AS missing_durations,
    SUM(CASE WHEN title_year IS NULL OR title_year = '' THEN 1 ELSE 0 END) AS missing_title_years
FROM
    metadata;
    
-- Qualify them
-- 2) How many records are concerned? Make sure to have your result as a proportion of the total nb of records.
SELECT
    COUNT(*) AS total_records,
    -- Volume
    SUM(CASE 
            WHEN movie_title IS NULL OR movie_title = '' OR
                 duration IS NULL OR duration = 0 OR duration = '' OR 
                 title_year IS NULL OR title_year = '' 
            THEN 1 
            ELSE 0 
        END) AS records_with_missing_values,
	-- Proportion
    CONCAT(
        ROUND(
            SUM(CASE 
                    WHEN movie_title IS NULL OR movie_title = '' OR movie_title = 'N/A' OR 
                         duration IS NULL OR duration = 0 OR duration = 'N/A' OR 
                         title_year IS NULL OR title_year = '' 
                    THEN 1 
                    ELSE 0 
                END) * 100.0 / COUNT(*),
            3
        ),
        " %"
    ) AS proportion_of_missing_values
FROM
    metadata;
    
-- 3) Select all the data, excluding the rows with missing values.

SELECT
    *
FROM
    metadata
WHERE
    NOT (movie_title IS NULL OR movie_title = '') AND
    NOT (duration IS NULL OR duration = 0 OR duration = '') AND
    NOT (title_year IS NULL OR title_year = '');


-- ----------------------------------------------------------
-- Exercice 2: Dealing with Duplicate Records - Removing them
-- (On the table metadata from the movies database).
-- We still want to be able to study the evolution of the duration of the films through the years. But first we need to make sure there are no duplicates.
-- Focus on the same columns: movie_title, duration, title_year,
-- Plus we add director_name to know wether they are real duplicates or movies with the same name
 
-- 1) Write a query to know whether there is duplicates in those columns.
SELECT
    movie_title,
    duration,
    title_year,
    director_name,
    COUNT(*) AS duplicate_count
FROM
    metadata
GROUP BY
    movie_title,
    duration,
    title_year,
    director_name
HAVING
    COUNT(*) > 1;
    
-- 2) Select the duplicates and try to understand why we have duplicates.
SELECT *
FROM metadata
WHERE (movie_title, duration, title_year, director_name) IN (
    SELECT movie_title, duration, title_year, director_name
    FROM metadata
    GROUP BY movie_title, duration, title_year, director_name
    HAVING COUNT(*) > 1
);
-- ** It seems that the duplicate data is either completely identical or has minor differences in other numbers, 
-- such as 'num_voted_users'. This might be due to entry errors during data scraping or omissions during updates. **

-- 3) How many records are concerned? Make sure to have your result as a proportion of the total nb of records.

-- 3) Solution 1 : It retrieves the total number of records and the number of records that are part of duplicate groups,
-- 'including' one instance from each duplicate group
SELECT 
	(SELECT COUNT(*)
    FROM metadata) AS total_records,
    -- Volume
    (SELECT SUM(duplicate_count) 
     FROM (SELECT COUNT(*) AS duplicate_count
           FROM metadata
           GROUP BY movie_title, duration, title_year, director_name
           HAVING COUNT(*) > 1) AS duplicates) AS total_duplicates, 
    -- Proportion
    CONCAT(ROUND(
    (SELECT SUM(duplicate_count) 
     FROM (SELECT COUNT(*) AS duplicate_count
           FROM metadata
           GROUP BY movie_title, duration, title_year, director_name
           HAVING COUNT(*) > 1) AS duplicates) 
    / COUNT(*) * 100,2),' %') 
	AS percentage_of_duplicates
FROM metadata;

-- 3) Solution 2 : It identifies the total number of records that are duplicates,
-- 'excluding' the first occurrence in each duplicate group
SELECT 
    (SUM(duplicate_count) - COUNT(*)) AS total_extra_duplicate_records,
    ((SUM(duplicate_count) - COUNT(*)) / (SELECT COUNT(*) FROM metadata)) * 100 AS percent_of_total_records
FROM (
    SELECT 
        movie_title, 
        duration, 
        title_year, 
        director_name, 
        COUNT(*) AS duplicate_count
    FROM 
        metadata
    GROUP BY 
        movie_title, 
        duration, 
        title_year, 
        director_name
    HAVING 
        COUNT(*) > 1
) AS duplicates;

-- 4) Select all the data, excluding the rows with missing values and the duplicates.

SELECT *
FROM (
    SELECT 
        metadata.*,
        ROW_NUMBER() OVER (
            PARTITION BY movie_title, duration, title_year, director_name
            ORDER BY (color)
        ) AS rn
    FROM metadata
    WHERE 
        NOT (movie_title IS NULL OR movie_title = '') AND
        NOT (duration IS NULL OR duration = 0 OR duration = '') AND
        NOT (title_year IS NULL OR title_year = '')
) AS subquery
WHERE rn = 1;

-- -----------
-- Exercise 3 
-- 1) Explore carefully the table, do you notice anything?
-- Try to identify a maximum of issues on metadata design :
-- You can write down here your comments as well as your queries that 
-- helped you to identify those issues

-- Issues identified in the metadata table:
-- a. Num_voted_users -> Should contain only numeric values, but strings are present.
--    This indicates a type inconsistency issue.

-- b. facenumbe_in_poster -> Expected to have only numeric values, but strings found.
--    This suggests a similar type inconsistency as in num_voted_users.

-- c. Keywords missing -> The absence of Keywords could affect the completeness and 
--    effectiveness of data queries.

-- d. Num_user_for_reviews -> Contains HTTP links, which are non-standard entries for 
--    a field that should ideally contain only numeric data.

-- e. Actor names -> Include numbers, which is not expected. Normally, this field should 
--    contain textual data (names), indicating possible data entry errors.

-- Additional Observations:

-- f. Non-Standard Data Entries in Numeric Fields -> Indicative of inconsistency in data 
--    entry practices, especially in fields meant for numeric data.

-- g. Duplication of Records -> Presence of duplicate records, possibly due to data entry 
--    errors or issues in the data import process.

-- Regarding the causes of the issues mentioned earlier, we have identified another 
-- potential hypothesis: errors during the data scraping or data processing stages. 
-- We observed that the rows with consistent issues share a common trait: 
-- they begin with a left double quote in the 'Movie_title' field. 
-- This suggests that certain specific structures might have been incorrectly segmented as 
-- delimiters during the database import, leading to data misalignment. 
-- Consequently, this has resulted in inappropriate data structures appearing in certain columns.
-- Rows which concerning:
SELECT * FROM metadata
WHERE movie_title LIKE '"%';

-- In order to eliminate all errors as much as possible, 
-- we will use regular expressions in our upcoming queries to exclude all potential errors.



-- 2) Try to select the problematic rows and to understand the problem.
SELECT * 
FROM metadata 
WHERE NOT REGEXP_LIKE(duration, '^[0-9]+$');

SELECT * 
FROM metadata 
WHERE NOT REGEXP_LIKE(title_year, '^[0-9]{4}$');

SELECT movie_title, duration, movie_imdb_link
FROM metadata
WHERE duration > 400;
-- Remark:
-- The duration threshold is set at 400 minutes in this query to filter out 
-- exceptionally long movies or TV series. For example, 'Trapped' has a duration 
-- of 511 minutes, indicating it is a TV series rather than a standard-length film.
-- This condition helps in distinguishing between typical movies and longer format 
-- shows like miniseries or multi-part TV shows.

-- 3) How many records are concerned? Make sure to have your result as a proportion of the total nb of records.
-- duration
SELECT
    COUNT(*) AS problematic_duration_count,
    CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM metadata)),3)," %") AS percentage_of_total
FROM metadata
WHERE NOT REGEXP_LIKE(duration, '^[0-9]+$') OR duration > 400 OR duration IS NULL;

-- title_year
SELECT
    COUNT(*) AS problematic_title_year_count,
    CONCAT(ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM metadata)),3)," %") AS percentage_of_total
FROM metadata
WHERE NOT REGEXP_LIKE(title_year, '^[0-9]{4}$') OR title_year IS NULL;

-- 4) Select all the data, excluding the rows with missing values, duplicates AND corrupted data.
SELECT *
FROM (
    SELECT 
        metadata.*,
        ROW_NUMBER() OVER (
            PARTITION BY movie_title, duration, title_year, director_name
            ORDER BY (color)
        ) AS rn
    FROM metadata
    WHERE 
        NOT (movie_title IS NULL OR movie_title = '') AND
        NOT (duration IS NULL OR duration = 0 OR duration = '' OR duration > 400) AND
        NOT (title_year IS NULL OR title_year = '') AND
		REGEXP_LIKE(duration, '^[0-9]+$')AND
        REGEXP_LIKE(title_year, '^[0-9]{4}$')
) AS subquery
WHERE rn = 1;

-- ==================================== --
-- PART TWO: Make ambitious table junction
-- ==================================== --
-- The database “movies” contains two kind of ratings. 
-- One “rating” is in the table “ratings” and is link to a “movieId”. 
-- The other, “imdb_score”, is in the “metadata” table. 
-- What we want here is to make an ambitious junction between the two table and get, per movie, the two kind of ratings available in this database.
-- Why ambitious? 
-- Because as you can see there is no common key or even common attribute between the two tables. 
-- In fact, there is no perfectly identic attributes but there is one eventually common value : the movie title.
-- Here, the issue here is how formate/clean your table’s data so you could make a proper join.
-- ====== --
-- Step 1:
-- What is the difference between the two attributes metadata.movie_title and movies.title ?
-- Only comment here

-- movies.title is combined by metadata.movie_title and metadata.title_year


-- ====== --
-- Step 2:
-- How to cut out some unwanted pieces of a string ? 
-- Use the function SUBSTR() but you will also need another function : CHAR_LENGTH().
-- From the movies table, 
-- Try to get a query returning the movie.title, considering only the correct title of each movie.
WITH cleaned_titles AS (
    SELECT
        movieId,
        CASE
            WHEN INSTR(REVERSE(title), '(') > 0 THEN SUBSTR(title, 1, CHAR_LENGTH(title) - INSTR(REVERSE(title), '('))
            ELSE title
        END AS cleaned_title
    FROM
        movies
)
SELECT
    movieId,
    cleaned_title
FROM
    cleaned_titles;

-- Remark:
-- In this SQL code, we are focusing on removing content inside the last set of parentheses in a title string.
-- Rather than merely discarding the last parentheses, we carefully identify the position of the last '(' 
-- by reversing the string. This approach is crucial because some titles may have multiple sets of parentheses 
-- or additional information in parentheses that is not necessarily at the end of the string. For instance, 
-- 'City of Lost Children, The (Cité des enfants perdus, La) (1995)' contains two sets of parentheses, but 
-- we only aim to remove the last one, which usually contains the year. Simply removing the last parentheses 
-- without this check could result in incorrect trimming, especially in cases where parentheses are part of 
-- the actual title or hold significant information.

-- Two examples:
-- 'City of Lost Children, The (Cité des enfants perdus, La) (1995)'
-- 'Stranger Things'



-- And then also include the aggregation of the average rating for each movie
-- joining the ratings table
WITH cleaned_movies AS (
    SELECT
        movieId,
        CASE
            WHEN INSTR(REVERSE(title), '(') > 0 THEN SUBSTR(title, 1, CHAR_LENGTH(title) - INSTR(REVERSE(title), '('))
            ELSE title
        END AS cleaned_title
    FROM
        movies
),
average_ratings AS (
    SELECT
        movieId,
        ROUND(AVG(rating), 2) AS average_rating
    FROM
        ratings
    GROUP BY
        movieId
)
SELECT
    cm.movieId,
    cm.cleaned_title,
    ar.average_rating
FROM
    cleaned_movies cm
INNER JOIN
    average_ratings ar
ON cm.movieId = ar.movieId;



-- ====== --
-- Step 3:
-- Now that we have a good request for cleaned and aggregated version of movies/ratings, 
-- you need to also have a clean request from metadata.
-- Make a query returning aggregated metadata.imdb_score for each metadata.movie_title.
-- excluding the corrupted rows 
SELECT
	TRIM(movie_title), 
    AVG(imdb_score) AS average_imdb_score
FROM
	metadata
WHERE
	duration > 0 AND duration < 400 AND (duration IS NOT NULL OR duration != '')
    AND title_year BETWEEN 1800 AND YEAR(CURRENT_DATE)
    AND imdb_score IS NOT NULL AND imdb_score != ''
GROUP BY
	movie_title;



-- ====== --
-- Step 4:
-- It is time to make a JOIN! Try to make a request merging the result of Step 2 and Step 3. 
-- You need to use your previous as two subqueries and join on the movie title.
-- What is happening ? What is the result ? This request can take time to return.
SELECT
    step2.movieId,
    step2.cleaned_title,
    step2.average_rating,
    step3.average_imdb_score
FROM
    (SELECT
        cm.movieId,
        cm.cleaned_title,
        ar.average_rating
     FROM
        (SELECT
            movieId,
            CASE
                WHEN INSTR(REVERSE(title), '(') > 0 THEN SUBSTR(title, 1, CHAR_LENGTH(title) - INSTR(REVERSE(title), '('))
                ELSE title
            END AS cleaned_title
         FROM
            movies) cm
     INNER JOIN
        (SELECT
            movieId,
            ROUND(AVG(rating), 2) AS average_rating
         FROM
            ratings
         GROUP BY
            movieId) ar
     ON cm.movieId = ar.movieId) step2
INNER JOIN
    (SELECT
        TRIM(movie_title) AS movie_title, 
        AVG(imdb_score) AS average_imdb_score
     FROM
        metadata
     WHERE
        duration > 0 AND duration < 400 AND (duration IS NOT NULL OR duration != '')
        AND title_year BETWEEN 1800 AND YEAR(CURRENT_DATE)
        AND imdb_score IS NOT NULL AND imdb_score != ''
     GROUP BY
        movie_title) step3
ON step2.cleaned_title = step3.movie_title;


-- ====== --
-- Step 5:
-- There is a possibility that your previous query doesn't work for apparently no reasons, 
-- despite of the join condition being respected on some rows 
-- (check by yourself on a specific film of your choice by adding a simple WHERE condition).
-- Try to find out what could go wrong
-- And try to query a workable join
-- Tip: Think about spaces or blanks 

-- Our research works on step 4, so skip.


-- For final version of the output, 
-- Also include the count of ratings used to compute the average.
SELECT
    step2.movieId,
    step2.cleaned_title,
    step2.average_rating,
    step2.count_of_ratings,
    step3.average_imdb_score
FROM
    (SELECT
        cm.movieId,
        cm.cleaned_title,
        ar.average_rating,
        ar.count_of_ratings
     FROM
        (SELECT
            movieId,
            CASE
                WHEN INSTR(REVERSE(title), '(') > 0 THEN SUBSTR(title, 1, CHAR_LENGTH(title) - INSTR(REVERSE(title), '('))
                ELSE title
            END AS cleaned_title
         FROM
            movies) cm
     INNER JOIN
        (SELECT
            movieId,
            ROUND(AVG(rating), 2) AS average_rating,
            COUNT(rating) AS count_of_ratings
         FROM
            ratings
         GROUP BY
            movieId) ar
     ON cm.movieId = ar.movieId) step2
INNER JOIN
    (SELECT
        TRIM(movie_title) AS movie_title, 
        AVG(imdb_score) AS average_imdb_score
     FROM
        metadata
     WHERE
        duration > 0 AND duration < 400 AND (duration IS NOT NULL OR duration != '')
        AND title_year BETWEEN 1800 AND YEAR(CURRENT_DATE)
        AND imdb_score IS NOT NULL AND imdb_score != ''
     GROUP BY
        movie_title) step3
ON step2.cleaned_title = step3.movie_title;



-- ------------------
-- Well done ! 
-- Congratulations !
-- ------------------