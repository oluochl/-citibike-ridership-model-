
#Step 2: Find Your Weather Station
SELECT *
FROM `bigquery-public-data.noaa_gsod.stations`
WHERE name LIKE '%LA GUARDIA%'
LIMIT 10;

#Step 3: Preview the Ride Data
SELECT  starttime, stoptime, tripduration
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
LIMIT 10;

#Step 4: Size Up the Problem
# 53,108,721 trips
SELECT COUNT(bikeid) AS total_trips
FROM `bigquery-public-data.new_york_citibike.citibike_trips`;

#Step 5: Rides Per Day 
SELECT DATE(starttime) AS ride_date, COUNT(*) AS num_rides
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE starttime IS NOT NULL AND
DATE(starttime) BETWEEN '2013-07-01' AND '2018-05-31'
GROUP BY ride_date
ORDER BY ride_date ASC
LIMIT 100;

#Step 6: Add Average Trip Duration 
SELECT DATE(starttime) AS ride_date, COUNT(*) AS num_rides,AVG(tripduration)/60 AS avg_duration_min
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE starttime IS NOT NULL AND
DATE(starttime) BETWEEN '2013-07-01' AND '2018-05-31'
GROUP BY ride_date
ORDER BY ride_date ASC;


#Step 7: One Station, Six Years of Weather Now the weather side.
SELECT 
  CAST(CONCAT(year, '-', mo, '-', da) AS date) AS obs_date,
  temp AS temp_f, max AS max_temp_f, 
  min AS min_temp_f, 
  wdsp AS wind_speed_knots, 
  prcp AS precip_in
FROM `bigquery-public-data.noaa_gsod.gsod20*`
WHERE 
  _TABLE_SUFFIX BETWEEN '13' AND '18' AND
  stn = "725030" AND PARSE_DATE('%Y-%m-%d', CONCAT(year, '-', mo, '-', da)) BETWEEN '2013-01-01' AND '2018-12-31';

#Step 8: The Join — Your Final Query
# The inner join keeps the days of the week which are not in the weather data
WITH daily_rides AS (
  SELECT 
    DATE(starttime) AS ride_date, 
    COUNT(*) AS num_rides,
    AVG(tripduration)/60 AS avg_duration_min,
    EXTRACT(DAY FROM starttime) AS day,
    FORMAT_DATE('%A', DATE(starttime)) AS day_of_week,
    EXTRACT(MONTH FROM starttime) AS month
FROM `bigquery-public-data.new_york_citibike.citibike_trips` AS ride_trips
WHERE starttime IS NOT NULL AND
DATE(starttime) BETWEEN '2013-07-01' AND '2018-05-31'
GROUP BY ride_date, day, month, day_of_week
ORDER BY ride_date ASC
),
daily_weather AS (SELECT 
  CAST(CONCAT(year, '-', mo, '-', da) AS date) AS obs_date,
  temp AS temp_f, max AS max_temp_f, 
  min AS min_temp_f, 
  wdsp AS wind_speed_knots, 
  prcp AS precip_in
FROM `bigquery-public-data.noaa_gsod.gsod20*`
WHERE 
  _TABLE_SUFFIX BETWEEN '13' AND '18' AND
  stn = "725030" AND PARSE_DATE('%Y-%m-%d', CONCAT(year, '-', mo, '-', da)) BETWEEN '2013-01-01' AND '2018-12-31')

SELECT *
FROM daily_rides
INNER JOIN 
daily_weather
ON daily_rides.ride_date = daily_weather.obs_date;

  