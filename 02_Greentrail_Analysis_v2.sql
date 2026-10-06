USE mastercard;


-- Overall Sales Performance
SELECT
ROUND(AVG(weekly_sales_before_promotion), 2) AS avg_sales_before,
ROUND(AVG(weekly_sales_during_promotion), 2) AS avg_sales_during,
ROUND(AVG(weekly_sales_after_promotion), 2) AS avg_sales_after
FROM greentrail_store_data;


-- Overall Customer Traffic
SELECT
ROUND(AVG(average_daily_visits_before_promotion), 2) AS avg_visits_before,
ROUND(AVG(average_daily_visits_during_promotion), 2) AS avg_visits_during,
ROUND(AVG(average_daily_visits_after_promotion), 2) AS avg_visits_after
FROM greentrail_store_data;

-- Sales Uplift Percentage
SELECT store_id, weekly_sales_during_promotion, weekly_sales_before_promotion,
ROUND(((weekly_sales_during_promotion - weekly_sales_before_promotion)/weekly_sales_before_promotion)*100) AS sales_uplift_percentage
FROM greentrail_store_data;


-- Post Sales Uplift Percentage
SELECT store_id, weekly_sales_after_promotion, weekly_sales_before_promotion,
ROUND(((weekly_sales_after_promotion - weekly_sales_before_promotion)/weekly_sales_before_promotion)*100) AS post_sales_uplift_percentage
FROM greentrail_store_data;


-- Average Sales Uplift %
SELECT ROUND(AVG((weekly_sales_during_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS avg_sales_uplift_pct
FROM greentrail_store_data;


-- Average Post-Sales Uplift %
SELECT ROUND(AVG((weekly_sales_after_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS avg_post_sales_uplift_pct
FROM greentrail_store_data;


-- Promotion Type Analysis
SELECT type_of_promotion, COUNT(*) AS no_of_stores, 
ROUND(AVG(((weekly_sales_during_promotion - weekly_sales_before_promotion)/weekly_sales_before_promotion)*100),2) AS during_sales_uplift_percentage,
ROUND(AVG(((weekly_sales_after_promotion - weekly_sales_before_promotion)/weekly_sales_before_promotion)*100),2) AS post_sales_uplift_percentage
FROM greentrail_store_data
GROUP BY type_of_promotion
ORDER BY no_of_stores DESC;


-- Customer Traffic Analysis

-- Visit Uplift During %
SELECT store_id,average_daily_visits_during_promotion,average_daily_visits_before_promotion,
ROUND(((average_daily_visits_during_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100,2) AS visit_uplift_during_percent
FROM greentrail_store_data;
-- AVG Visit Uplift During %
SELECT 
ROUND(AVG(((average_daily_visits_during_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100),2) AS avg_visit_uplift_during_percent
FROM greentrail_store_data;

-- Visit Uplift Post %
SELECT store_id,average_daily_visits_after_promotion,average_daily_visits_before_promotion,
ROUND(((average_daily_visits_after_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100,2) AS visit_uplift_post_percent
FROM greentrail_store_data;
-- AVG Visit Uplift Post %
SELECT 
ROUND(AVG(((average_daily_visits_after_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100),2) AS avg_visit_uplift_after_percent
FROM greentrail_store_data;

-- Store Type Analysis
SELECT store_type,
ROUND(AVG(weekly_sales_during_promotion),2) AS avg_sales_during, 
ROUND(AVG(weekly_sales_before_promotion),2) AS avg_sales_before, 
ROUND(AVG(weekly_sales_after_promotion),2) AS avg_sales_after,
ROUND(AVG((weekly_sales_during_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS sales_uplift_during_pct,
ROUND(AVG((weekly_sales_after_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS sales_uplift_post_pct,
ROUND(AVG(((average_daily_visits_during_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100),2) AS visit_uplift_during_pct,
ROUND(AVG(((average_daily_visits_after_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100),2) AS visit_uplift_after_pct
FROM greentrail_store_data
GROUP BY store_type;


-- Promotion and Store Analysis
-- Which promotion type worked for which store?
SELECT store_type, type_of_promotion, COUNT(*) AS no_of_stores,
ROUND(AVG((weekly_sales_during_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS sales_uplift_during_pct,
ROUND(AVG((weekly_sales_after_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS sales_uplift_post_pct,
ROUND(AVG(((average_daily_visits_during_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100),2) AS visit_uplift_during_pct,
ROUND(AVG(((average_daily_visits_after_promotion - average_daily_visits_before_promotion)/average_daily_visits_before_promotion)*100),2) AS visit_uplift_after_pct
FROM greentrail_store_data
GROUP BY store_type, type_of_promotion
ORDER BY store_type, type_of_promotion;


-- Store Size Analysis
-- Is promotion response related to store size?
SELECT store_id, store_size, ROUND(((weekly_sales_during_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion) * 100,2) AS sales_uplift_during_pct
FROM greentrail_store_data
ORDER BY store_size;


-- Location Analysis
SELECT location, COUNT(*) AS no_of_stores,
ROUND(AVG((weekly_sales_during_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS sales_uplift_during_pct,
ROUND(AVG((weekly_sales_after_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS sales_uplift_after_pct,
ROUND(AVG((average_daily_visits_during_promotion - average_daily_visits_before_promotion)/ average_daily_visits_before_promotion * 100),2) AS visit_uplift_during_pct,
ROUND(AVG((average_daily_visits_after_promotion - average_daily_visits_before_promotion)/ average_daily_visits_before_promotion * 100),2) AS visit_uplift_after_pct
FROM greentrail_store_data
GROUP BY location
ORDER BY sales_uplift_during_pct DESC;


-- Promotion Response Persistence / Decay
-- How much of the promotional response appears to persist after the promotion?
SELECT type_of_promotion,
ROUND(AVG((weekly_sales_during_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS during_sales_uplift_pct,
ROUND(AVG((weekly_sales_after_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100),2) AS post_sales_uplift_pct,
ROUND(AVG(((weekly_sales_during_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100)-((weekly_sales_after_promotion - weekly_sales_before_promotion)/ weekly_sales_before_promotion * 100)),2)
AS uplift_decay_pct
FROM greentrail_store_data
GROUP BY type_of_promotion;
