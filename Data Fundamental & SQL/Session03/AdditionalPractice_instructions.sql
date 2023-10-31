-- Exercise on DIVVY DB

-- During this exercise, you will use the 'Divvy' database. It is part of a dataset derived from a bycicle sharing service
-- in the city of Chicago, IL (USA) similar to Lyon's "Velo'v". 
-- There are two tables: Trips, containing all the trips from the year 2018
-- and Stations, which contains some info on each of the stations.

-- The data has been made available by Motivate International Inc. under this license:
-- https://ride.divvybikes.com/data-license-agreement
-- and the full dataset as originally provided can be found here:
-- https://divvy-tripdata.s3.amazonaws.com/index.html
-- To get a feeling for the data, we plotted the stations from the Stations table here:
-- https://www.google.com/maps/d/edit?mid=1o8GHKNl2UdNlCEVGWqzjTWxOoyB-EEg&usp=sharing

USE Divvy;


-- Question 1
-- Explore the database and discuss your findings. 
-- Consider all the usual aspects about data types, missing values, etc.



-- PART 1
-- Content exploration about stations

-- Question 2
-- Imagine your database administrator is a slacker, and hasn't updated the Stations table since 2013.
-- (We uploaded the 2013 stations on purpose here of course.) 
-- How many trips in the Trips table have a from_stationID with no match in the Stations table? 



-- Combine results with same no match in the to_station table



-- What percentage of the total nr. of rows is that? 
-- (Try to make it in one query)




-- PART 2
-- Customer exploration

-- Question 3
-- What is the man/woman ratio among all users? Your CTO wants the number to be precise to exactly 3 digits behind the comma.
-- (Tip: the solution does not need complicated SQL, but you need to apply a bit of thinking/common sense on how to solve this.)




-- Question 4
-- Imagine, we want to create a histogram of trip durations for men and for women.
-- Figure out how to resolve the US formatted number issue (thousands separator is a comma), TIP: use the REPLACE() function
-- Return a table with the original tripdurations next to the "cleaned" ones



-- Question 5
-- Use [FLOOR(.../10)*10 AS bin_floor] in a query that counts the nr of trips ber bin (60 seconds-70 seconds, 70s-80s etc.)
-- This is a histogram in tabular form, which can then be exported to Excel in order to plot it.
-- Do this once for women, once for men.



-- Question 6
-- We want now to explore the age distribution of our users. 
-- Write a query that returns both, export to excel,
-- There appears to be a difference between the way 
-- the plot behaves before and after an age of about 65. 
-- Discuss what you think the reason is for the
-- shape of the plot overall, and this difference as well.





-- PART 3
-- Basic geographical station distribution

-- Question 7
-- --- North/South comparison -----
-- The CEO would like to ask your quick-and-dirty assessment: should we focus our expansion efforts on the north of the city or the south.
-- Give the count of trips departing from the north half of the stations and the south half. 
-- we are suggesting a 3 step plan to help you.

-- step 1: calculate half the row nrs
-- Query 3



-- step 2: find out the count for only the south or north
-- (No query to hand in, just a step to help you)



-- step 3: glue the north and south results into one
-- Query 4




-- ----
-- Export data extracted 
-- and push them into a plot tool and explore deeper the data
-- (if you know one and how to use it)
