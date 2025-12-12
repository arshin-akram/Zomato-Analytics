SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

CREATE DATABASE zomato_project;
USE zomato_project;
CREATE TABLE zomato_data (
    RestaurantID INT,
    RestaurantName VARCHAR(255),
    CountryCode INT,
    City VARCHAR(100),
    Address TEXT,
    Locality VARCHAR(255),
    LocalityVerbose VARCHAR(255),
    Longitude DECIMAL(10,6),
    Latitude DECIMAL(10,6),
    Cuisines TEXT,
    Currency VARCHAR(50),
    Has_Table_booking VARCHAR(10),
    Has_Online_delivery VARCHAR(10),
    Is_delivering_now VARCHAR(10),
    Switch_to_order_menu VARCHAR(10),
    Price_range INT,
    Votes INT,
    Average_Cost_for_two INT,
    Rating DECIMAL(3,1),
    `Year Opening` INT,
    `Month Opening` VARCHAR(20),
    `Day Opening` VARCHAR(20),
    USD_Rate DECIMAL(10,4),
    DateOpening DATE,
    Average_Cost_for_two_USD DECIMAL(10,2),
    Country VARCHAR(100),
    Year INT,
    Month VARCHAR(20),
    Quarter VARCHAR(10),
    Price_Bucket_USD VARCHAR(50)
);
LOAD DATA LOCAL INFILE 'C:\\Users\\lovel\\Downloads\\PowerBI_ready_Zomato.csv'
INTO TABLE zomato_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(RestaurantID, RestaurantName, CountryCode, City, Address, Locality, LocalityVerbose,
Longitude, Latitude, Cuisines, Currency, Has_Table_booking, Has_Online_delivery,
Is_delivering_now, Switch_to_order_menu, Price_range, Votes, Average_Cost_for_two,
Rating, `Year Opening`, `Month Opening`, `Day Opening`, USD_Rate, DateOpening,
Average_Cost_for_two_USD, Country, Year, Month, Quarter, Price_Bucket_USD);

SELECT COUNT(*) FROM zomato_data;
SELECT * FROM zomato_data;
DESCRIBE zomato_data;

# 1. Total Cities
SELECT COUNT(DISTINCT City) AS Total_Cities
FROM Zomato_data;

# 2. Total Countries
SELECT COUNT(DISTINCT Country) AS Total_Countries
FROM zomato_data;

# 3. Total number of restaurants
SELECT COUNT(DISTINCT RestaurantID) AS Total_Restaurants
FROM zomato_data;

# 4. Total number of Cuisines
SELECT COUNT(DISTINCT Cuisines) AS Total_Unique_Cuisines
FROM zomato_data
WHERE Cuisines IS NOT NULL AND Cuisines <> '';

# 5. count of restaurants based on average rating
SELECT 
CASE
WHEN Rating < 2 THEN 'Poor (<2)'
WHEN Rating >= 2 AND Rating < 3.5 THEN 'Average (2–3.4)'
WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'Good (3.5–4.4)'
ELSE 'Excellent (≥4.5)'
END AS Rating_Bucket,
COUNT(*) AS Number_of_Restaurants
FROM zomato_data
WHERE Rating IS NOT NULL
GROUP BY Rating_Bucket
ORDER BY MIN(Rating);

# 6. Table Booking
SELECT 
    Has_Table_booking,
    COUNT(*) AS Total_Restaurants
FROM zomato_data
GROUP BY Has_Table_booking;

# 7. Currently Delivery Restaurant
SELECT 
    COUNT(*) AS Currently_Delivering
FROM zomato_data
WHERE Is_Delivering_Now = 'Yes';

# 8. No. of resturants falls in each buckets
SELECT Price_Bucket_USD,
COUNT(*) AS Number_of_Restaurants
FROM zomato_data
WHERE Price_Bucket_USD IS NOT NULL
GROUP BY Price_Bucket_USD
ORDER BY MIN(Average_Cost_for_two_USD);

# 9. Restaurant opening by year
SELECT 
    YEAR(DateOpening) AS Opening_Year,
    COUNT(*) AS Total_Restaurants
FROM zomato_data
GROUP BY YEAR(DateOpening)
ORDER BY Opening_Year;

# 10. Restaurant Opened per month
SELECT 
    YEAR(DateOpening) AS Opening_Year,
    MONTH(DateOpening) AS Opening_Month,
    COUNT(*) AS Total_Restaurants
FROM zomato_data
GROUP BY 
    YEAR(DateOpening),
    MONTH(DateOpening)
ORDER BY 
    Opening_Year,
    Opening_Month;

# 11. Top Rated City
SELECT 
    City,
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM zomato_data
GROUP BY City
ORDER BY Avg_Rating DESC
LIMIT 1;

# 12. Percentage of Resturants based on "Has_Table_booking"
SELECT Has_Table_booking,
COUNT(*) AS Restaurant_Count,
ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato_data)), 2) AS Percentage_of_Restaurants
FROM zomato_data
GROUP BY Has_Table_booking;

# 13. % has online delivery
SELECT 
    ROUND(
        (SUM(CASE WHEN Has_Online_delivery = 'Yes' THEN 1 ELSE 0 END) 
         / COUNT(*)) * 100, 
        2
    ) AS Online_Delivery_Percentage
FROM zomato_data;

# 14. No of Votes
SELECT Country, SUM(Votes) AS Total_Votes
FROM zomato_data
GROUP BY Country
ORDER BY Total_Votes DESC;


