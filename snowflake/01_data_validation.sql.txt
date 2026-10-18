
-- ============================================================
-- FOOD DELIVERY ANALYTICS
-- File: 01_data_validation.sql
-- Purpose: Validate staging and core data in Snowflake
-- ============================================================

USE DATABASE FOOD_DATA_DB;
USE WAREHOUSE FOOD_FIVETRAN_WH;

-- 1. Validate staging row counts
SELECT 'STG_FOOD_ORDERS' AS TABLE_NAME, COUNT(*) AS ROW_COUNT
FROM STAGING.STG_FOOD_ORDERS

UNION ALL

SELECT 'STG_RESTAURANT_MENU', COUNT(*)
FROM STAGING.STG_RESTAURANT_MENU

UNION ALL

SELECT 'STG_CUSTOMER_REVIEWS', COUNT(*)
FROM STAGING.STG_CUSTOMER_REVIEWS;


-- 2. Validate order-line IDs
SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT(DISTINCT "order_line_id") AS UNIQUE_ORDER_LINES,
    COUNT_IF("order_line_id" IS NULL) AS NULL_ORDER_LINE_IDS
FROM STAGING.STG_FOOD_ORDERS;


-- 3. Find duplicate order-line IDs
SELECT
    "order_line_id",
    COUNT(*) AS DUPLICATE_COUNT
FROM STAGING.STG_FOOD_ORDERS
GROUP BY "order_line_id"
HAVING COUNT(*) > 1
ORDER BY DUPLICATE_COUNT DESC;


-- 4. Validate line totals against quantity * unit price
SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT_IF(
        "quantity" IS NULL
        OR "unit_price" IS NULL
        OR "line_total" IS NULL
    ) AS NULL_VALUE_ROWS,
    COUNT_IF(
        "quantity" IS NOT NULL
        AND "unit_price" IS NOT NULL
        AND "line_total" IS NOT NULL
        AND ABS("line_total" - ("quantity" * "unit_price")) > 0.01
    ) AS MISMATCH_ROWS
FROM STAGING.STG_FOOD_ORDERS;


-- 5. Check consistency of order totals across order lines
SELECT
    "order_id",
    COUNT(*) AS ORDER_LINE_COUNT,
    COUNT(DISTINCT "order_total") AS DISTINCT_ORDER_TOTALS,
    MIN("order_total") AS MIN_ORDER_TOTAL,
    MAX("order_total") AS MAX_ORDER_TOTAL
FROM STAGING.STG_FOOD_ORDERS
WHERE "order_id" IS NOT NULL
GROUP BY "order_id"
HAVING COUNT(DISTINCT "order_total") > 1
ORDER BY "order_id";


-- 6. Validate menu item IDs
SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT(DISTINCT "item_id") AS UNIQUE_ITEM_IDS,
    COUNT_IF("item_id" IS NULL) AS NULL_ITEM_IDS
FROM STAGING.STG_RESTAURANT_MENU;


-- 7. Validate customer review IDs
SELECT
    COUNT(*) AS TOTAL_ROWS,
    COUNT(DISTINCT "review_id") AS UNIQUE_REVIEW_IDS,
    COUNT_IF("review_id" IS NULL) AS NULL_REVIEW_IDS
FROM STAGING.STG_CUSTOMER_REVIEWS;


-- 8. Validate core fact-table row counts
SELECT 'FACT_ORDER_LINES' AS TABLE_NAME, COUNT(*) AS ROW_COUNT
FROM CORE.FACT_ORDER_LINES

UNION ALL

SELECT 'FACT_ORDERS', COUNT(*)
FROM CORE.FACT_ORDERS

UNION ALL

SELECT 'FACT_REVIEWS', COUNT(*)
FROM CORE.FACT_REVIEWS;


-- 9. Check for unmatched order-line dates
SELECT
    COUNT(*) AS TOTAL_FACT_ROWS,
    COUNT_IF(f.ORDER_DATE_KEY IS NULL) AS NULL_DATE_KEYS,
    COUNT_IF(d.DATE_KEY IS NULL) AS UNMATCHED_DATE_KEYS
FROM CORE.FACT_ORDER_LINES f
LEFT JOIN CORE.DIM_DATE d
    ON f.ORDER_DATE_KEY = d.DATE_KEY;


-- 10. Check customer, restaurant and item dimension matches
SELECT
    'CUSTOMER' AS CHECK_TYPE,
    COUNT(DISTINCT f."customer_id") AS FACT_IDS,
    COUNT(DISTINCT d."customer_id") AS MATCHED_IDS,
    COUNT(DISTINCT f."customer_id")
      - COUNT(DISTINCT d."customer_id") AS UNMATCHED_IDS
FROM CORE.FACT_ORDER_LINES f
LEFT JOIN CORE.DIM_CUSTOMER d
    ON f."customer_id" = d."customer_id"

UNION ALL

SELECT
    'RESTAURANT',
    COUNT(DISTINCT f."restaurant_id"),
    COUNT(DISTINCT d."restaurant_id"),
    COUNT(DISTINCT f."restaurant_id")
      - COUNT(DISTINCT d."restaurant_id")
FROM CORE.FACT_ORDER_LINES f
LEFT JOIN CORE.DIM_RESTAURANT d
    ON f."restaurant_id" = d."restaurant_id"

UNION ALL

SELECT
    'ITEM',
    COUNT(DISTINCT f."item_id"),
    COUNT(DISTINCT d."item_id"),
    COUNT(DISTINCT f."item_id")
      - COUNT(DISTINCT d."item_id")
FROM CORE.FACT_ORDER_LINES f
LEFT JOIN CORE.DIM_ITEM d
    ON f."item_id" = d."item_id";
