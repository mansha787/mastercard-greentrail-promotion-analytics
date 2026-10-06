USE mastercard;


-- Number of Stores
SELECT COUNT(*) AS total_stores
FROM greentrail_store_data;


-- Standarize the Column Name
ALTER TABLE greentrail_store_data
RENAME COLUMN `Store ID` TO store_id,
RENAME COLUMN `Location` TO location,
RENAME COLUMN `Store Size` TO store_size,
RENAME COLUMN `Store Type` TO store_type,
RENAME COLUMN `Promotion ID` TO promotion_id,
RENAME COLUMN `Type of Promotion` TO type_of_promotion,
RENAME COLUMN `Promotion Start Date` TO promotion_start_date,
RENAME COLUMN `Promotion End Date` TO promotion_end_date,
RENAME COLUMN `Weekly Sales During Promotion` TO weekly_sales_during_promotion,
RENAME COLUMN `Weekly Sales Before Promotion` TO weekly_sales_before_promotion,
RENAME COLUMN `Weekly Sales After Promotion` TO weekly_sales_after_promotion,
RENAME COLUMN `Average Daily Visits During Promotion` TO average_daily_visits_during_promotion,
RENAME COLUMN `Average Daily Visits Before Promotion` TO average_daily_visits_before_promotion,
RENAME COLUMN `Average Daily Visits After Promotion` TO average_daily_visits_after_promotion;


-- Describe the Dataset
DESCRIBE greentrail_store_data;


-- Check NULL/Missing Values
SELECT
    SUM(store_id IS NULL) AS missing_store_id,
    SUM(location IS NULL) AS missing_location,
    SUM(store_size IS NULL) AS missing_store_size,
    SUM(store_type IS NULL) AS missing_store_type,
    SUM(promotion_id IS NULL) AS missing_promotion_id,
    SUM(type_of_promotion IS NULL) AS missing_type_of_promotion,
    SUM(promotion_start_date IS NULL) AS missing_promotion_start_date,
    SUM(promotion_end_date IS NULL) AS missing_promotion_end_date,
    SUM(weekly_sales_during_promotion IS NULL) AS missing_sales_during,
    SUM(weekly_sales_before_promotion IS NULL) AS missing_sales_before,
    SUM(weekly_sales_after_promotion IS NULL) AS missing_sales_after,
    SUM(average_daily_visits_during_promotion IS NULL) AS missing_visits_during,
    SUM(average_daily_visits_before_promotion IS NULL) AS missing_visits_before,
    SUM(average_daily_visits_after_promotion IS NULL) AS missing_visits_after
FROM greentrail_store_data;


-- Check Duplicate Store ID
SELECT store_id, COUNT(*) AS count_records
FROM greentrail_store_data
GROUP BY store_id
HAVING COUNT(*) > 1;

-- Check frequency of promotion types
SELECT type_of_promotion, COUNT(*) AS number_of_stores
FROM greentrail_store_data
GROUP BY type_of_promotion
ORDER BY number_of_stores DESC;


-- Check Store type Distribution
SELECT store_type, COUNT(*) AS number_of_stores
FROM greentrail_store_data
GROUP BY store_type;


-- Check for negative sales
SELECT *
FROM greentrail_store_data
WHERE weekly_sales_before_promotion < 0
   OR weekly_sales_during_promotion < 0
   OR weekly_sales_after_promotion < 0;
   
   
-- Check for negative visits
SELECT *
FROM greentrail_store_data
WHERE average_daily_visits_before_promotion < 0
   OR average_daily_visits_during_promotion < 0
   OR average_daily_visits_after_promotion < 0;
   
   
-- Check Promotion dates
SELECT store_id, promotion_start_date, promotion_end_date
FROM greentrail_store_data
WHERE promotion_end_date < promotion_start_date;


-- Calculate promotion duration
SELECT store_id, promotion_start_date, promotion_end_date,
    DATEDIFF(
        promotion_end_date,
        promotion_start_date
    ) + 1 AS promotion_days
FROM greentrail_store_data;


-- Check whether sales values make sense 
SELECT store_id, type_of_promotion, weekly_sales_before_promotion, weekly_sales_during_promotion, weekly_sales_after_promotion
FROM greentrail_store_data
WHERE weekly_sales_during_promotion
      < weekly_sales_before_promotion;
      

-- Check relationship between Store ID and Promotion ID
SELECT store_id, COUNT(DISTINCT promotion_id) AS promotion_count
FROM greentrail_store_data
GROUP BY store_id;


-- One consolidated data-quality query
SELECT
COUNT(*) AS total_rows,
COUNT(DISTINCT store_id) AS unique_stores,
COUNT(DISTINCT promotion_id) AS unique_promotions,
COUNT(DISTINCT location) AS unique_locations,
COUNT(DISTINCT store_type) AS unique_store_types,
COUNT(DISTINCT type_of_promotion) AS unique_promotion_types
FROM greentrail_store_data;