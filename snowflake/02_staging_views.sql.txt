-- Food Delivery Analytics
-- Layer: STAGING
-- Purpose: Exclude deleted records from Fivetran CDC data

USE DATABASE FOOD_DATA_DB;

CREATE SCHEMA IF NOT EXISTS STAGING;

-- 1. Staging view for food orders
CREATE OR REPLACE VIEW STAGING.STG_FOOD_ORDERS AS
SELECT *
FROM "food_ops"."food_orders"
WHERE COALESCE("_fivetran_deleted", FALSE) = FALSE;

-- 2. Staging view for restaurant menu
CREATE OR REPLACE VIEW STAGING.STG_RESTAURANT_MENU AS
SELECT *
FROM "food_ops"."restaurant_menu"
WHERE COALESCE("_fivetran_deleted", FALSE) = FALSE;

-- 3. Staging view for customer reviews
CREATE OR REPLACE VIEW STAGING.STG_CUSTOMER_REVIEWS AS
SELECT *
FROM "food_ops"."customer_reviews"
WHERE COALESCE("_fivetran_deleted", FALSE) = FALSE;