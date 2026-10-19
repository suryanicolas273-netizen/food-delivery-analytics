
-- ============================================================
-- Food Delivery Analytics
-- Layer: CORE - Fact Tables
-- Source: STAGING views
-- Grain:
--   FACT_ORDER_LINES = one row per order line
--   FACT_ORDERS      = one row per order
--   FACT_REVIEWS     = one row per review
-- ============================================================

USE DATABASE FOOD_DATA_DB;
USE SCHEMA CORE;

-- 1. FACT ORDER LINES
-- One row per order_line_id.
CREATE OR REPLACE TABLE FACT_ORDER_LINES AS
SELECT
    fo.order_line_id,
    fo.order_id,
    fo.order_line_no,
    fo.customer_id,
    fo.restaurant_id,
    fo.item_id,
    fo.partner_id,
    TO_NUMBER(TO_CHAR(TO_DATE(fo.order_placed_at), 'YYYYMMDD'))
        AS ORDER_DATE_KEY,
    fo.order_status,
    fo.order_placed_at,
    fo.accepted_at,
    fo.picked_up_at,
    fo.delivered_at,
    fo.cancelled_at,
    fo.quantity,
    fo.unit_price,
    fo.line_total,
    fo.order_subtotal,
    fo.discount_amount,
    fo.delivery_fee,
    fo.tax_amount,
    fo.order_total,
    fo.payment_method,
    fo.payment_status,
    fo.promo_code
FROM FOOD_DATA_DB.STAGING.STG_FOOD_ORDERS fo
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY fo.order_line_id
    ORDER BY fo.updated_at DESC
) = 1;


-- 2. FACT ORDERS
-- One row per order_id.
-- Order-level values are repeated across order lines in the source,
-- so retain one latest record per order.
CREATE OR REPLACE TABLE FACT_ORDERS AS
SELECT
    order_id,
    customer_id,
    restaurant_id,
    partner_id,
    TO_NUMBER(TO_CHAR(TO_DATE(order_placed_at), 'YYYYMMDD'))
        AS ORDER_DATE_KEY,
    order_status,
    order_placed_at,
    accepted_at,
    picked_up_at,
    delivered_at,
    cancelled_at,
    order_subtotal,
    discount_amount,
    delivery_fee,
    tax_amount,
    order_total,
    payment_method,
    payment_status,
    promo_code
FROM FOOD_DATA_DB.STAGING.STG_FOOD_ORDERS
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY order_id
    ORDER BY updated_at DESC, order_line_id DESC
) = 1;


-- 3. FACT REVIEWS
-- One row per review_id.
CREATE OR REPLACE TABLE FACT_REVIEWS AS
SELECT
    review_id,
    order_id,
    customer_id,
    restaurant_id,
    partner_id,
    TO_NUMBER(
        TO_CHAR(TO_DATE(review_created_at), 'YYYYMMDD')
    ) AS REVIEW_DATE_KEY,
    restaurant_rating,
    delivery_rating,
    review_text,
    review_created_at,
    order_total,
    order_delivered_at
FROM FOOD_DATA_DB.STAGING.STG_CUSTOMER_REVIEWS
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY review_id
    ORDER BY updated_at DESC
) = 1;
