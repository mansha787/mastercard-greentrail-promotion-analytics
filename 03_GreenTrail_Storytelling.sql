USE mastercard;

-- Extra queries supporting the Task 2 presentation.
-- Table and column names follow 01_GreenTrail_DataCleaning.sql.
-- Store-level % uplift is calculated first, then averaged (same convention as 02_Greentrail_Analysis.sql).


-- 1. Spend per visit: weekly sales / (average daily visits x 7), totalled across stores
SELECT
ROUND(SUM(weekly_sales_before_promotion) / (SUM(average_daily_visits_before_promotion) * 7), 2) AS spend_per_visit_before,
ROUND(SUM(weekly_sales_during_promotion) / (SUM(average_daily_visits_during_promotion) * 7), 2) AS spend_per_visit_during,
ROUND(SUM(weekly_sales_after_promotion)  / (SUM(average_daily_visits_after_promotion)  * 7), 2) AS spend_per_visit_after
FROM greentrail_store_data;


-- 2. Share of the promotional lift still present after the promotion, by promotion type
SELECT type_of_promotion,
ROUND(AVG((weekly_sales_during_promotion - weekly_sales_before_promotion) / weekly_sales_before_promotion * 100), 2) AS during_uplift_pct,
ROUND(AVG((weekly_sales_after_promotion  - weekly_sales_before_promotion) / weekly_sales_before_promotion * 100), 2) AS post_uplift_pct,
ROUND(AVG((weekly_sales_after_promotion  - weekly_sales_before_promotion) / weekly_sales_before_promotion * 100)
    / AVG((weekly_sales_during_promotion - weekly_sales_before_promotion) / weekly_sales_before_promotion * 100) * 100, 1) AS lift_retained_pct
FROM greentrail_store_data
GROUP BY type_of_promotion;


-- 3. Stores that ended below their pre-promotion sales, by promotion type
SELECT type_of_promotion,
COUNT(*) AS total_stores,
SUM(CASE WHEN weekly_sales_after_promotion < weekly_sales_before_promotion THEN 1 ELSE 0 END) AS stores_below_baseline_after
FROM greentrail_store_data
GROUP BY type_of_promotion
ORDER BY type_of_promotion;


-- 4. Store-type mix inside each promotion (checks whether store type is mixed up with promotion type)
SELECT type_of_promotion,
COUNT(*) AS total_stores,
SUM(CASE WHEN store_type = 'Urban' THEN 1 ELSE 0 END) AS urban_stores,
ROUND(SUM(CASE WHEN store_type = 'Urban' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 0) AS urban_share_pct
FROM greentrail_store_data
GROUP BY type_of_promotion
ORDER BY type_of_promotion;


-- 5. Highest and lowest sales uplift stores (anomaly check)
SELECT store_id, store_type, type_of_promotion, store_size,
ROUND((weekly_sales_during_promotion - weekly_sales_before_promotion) / weekly_sales_before_promotion * 100, 1) AS sales_uplift_during_pct,
ROUND((weekly_sales_after_promotion  - weekly_sales_before_promotion) / weekly_sales_before_promotion * 100, 1) AS sales_uplift_post_pct
FROM greentrail_store_data
ORDER BY sales_uplift_during_pct DESC;


-- 6. Smaller vs larger stores (split at the median store size)
WITH median_size AS (
    SELECT store_id, store_size,
    ROW_NUMBER() OVER (ORDER BY store_size) AS rn,
    COUNT(*) OVER () AS n
    FROM greentrail_store_data
)
SELECT
CASE WHEN m.rn <= (m.n + 1) / 2 THEN 'Smaller half' ELSE 'Larger half' END AS size_group,
COUNT(*) AS no_of_stores,
ROUND(AVG((g.weekly_sales_during_promotion - g.weekly_sales_before_promotion) / g.weekly_sales_before_promotion * 100), 1) AS sales_uplift_during_pct,
ROUND(AVG((g.weekly_sales_after_promotion  - g.weekly_sales_before_promotion) / g.weekly_sales_before_promotion * 100), 1) AS sales_uplift_post_pct
FROM greentrail_store_data g
JOIN median_size m ON g.store_id = m.store_id
GROUP BY size_group;


-- Note: MySQL has no built-in correlation function. The 0.62 (store size vs sales uplift) and
-- 0.85 (visit uplift vs sales uplift) figures were calculated in 02_Greentrail_Analysis_v2.sql.
