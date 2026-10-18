
-- ============================================================
-- Food Delivery Analytics
-- Layer: CORE - Dimension Tables
-- Source: Fivetran-replicated food_ops data
-- Purpose: Build dimensions for the Power BI star schema
-- ============================================================

USE DATABASE FOOD_DATA_DB;
USE SCHEMA CORE;

-- 1. CUSTOMER DIMENSION
CREATE OR REPLACE TABLE DIM_CUSTOMER AS
SELECT
    customer_id,
    customer_name,
    customer_email,
    customer_phone,
    loyalty_tier
FROM FOOD_DATA_DB.STAGING.STG_FOOD_ORDERS
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY updated_at DESC, order_line_id DESC
) = 1;


-- 2. RESTAURANT DIMENSION
CREATE OR REPLACE TABLE DIM_RESTAURANT AS
SELECT
    restaurant_id,
    restaurant_name,
    cuisine_type
FROM FOOD_DATA_DB.STAGING.STG_RESTAURANT_MENU
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY restaurant_id
    ORDER BY updated_at DESC, item_id DESC
) = 1;


-- 3. ITEM DIMENSION
CREATE OR REPLACE TABLE DIM_ITEM AS
SELECT
    item_id,
    restaurant_id,
    item_name,
    category,
    is_veg,
    price,
    is_available
FROM FOOD_DATA_DB.STAGING.STG_RESTAURANT_MENU
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY item_id
    ORDER BY updated_at DESC, item_id DESC
) = 1;


-- 4. DELIVERY PARTNER DIMENSION
CREATE OR REPLACE TABLE DIM_DELIVERY_PARTNER AS
SELECT
    partner_id,
    partner_name,
    partner_phone,
    vehicle_type
FROM FOOD_DATA_DB.STAGING.STG_FOOD_ORDERS
WHERE partner_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY partner_id
    ORDER BY updated_at DESC, order_line_id DESC
) = 1;


-- 5. LOCATION DIMENSION
-- A location is identified by its delivery address attributes.
CREATE OR REPLACE TABLE DIM_LOCATION AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY delivery_city, delivery_state,
                 delivery_locality, delivery_pincode
    ) AS LOCATION_KEY,
    delivery_address,
    delivery_locality,
    delivery_city,
    delivery_state,
    delivery_pincode
FROM (
    SELECT DISTINCT
        delivery_address,
        delivery_locality,
        delivery_city,
        delivery_state,
        delivery_pincode
    FROM FOOD_DATA_DB.STAGING.STG_FOOD_ORDERS
);


-- 6. DATE DIMENSION
-- Date range: 2024-01-01 to 2027-12-31 (inclusive).
CREATE OR REPLACE TABLE DIM_DATE AS
WITH date_series AS (
    SELECT DATEADD(
        DAY,
        ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1,
        '2024-01-01'::DATE
    ) AS date_value
    FROM TABLE(GENERATOR(ROWCOUNT => 1461))
)
SELECT
    TO_NUMBER(TO_CHAR(date_value, 'YYYYMMDD')) AS DATE_KEY,
    date_value AS FULL_DATE,
    YEAR(date_value) AS YEAR,
    QUARTER(date_value) AS QUARTER,
    MONTH(date_value) AS MONTH,
    MONTHNAME(date_value) AS MONTH_NAME,
    DAY(date_value) AS DAY,
    DAYOFWEEKISO(date_value) AS DAY_OF_WEEK,
    DAYNAME(date_value) AS DAY_NAME,
    IFF(DAYOFWEEKISO(date_value) IN (6, 7), TRUE, FALSE) AS IS_WEEKEND
FROM date_series;
