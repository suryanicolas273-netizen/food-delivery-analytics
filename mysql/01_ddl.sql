-- =====================================================================
-- food_ops : denormalized operational database (Aurora MySQL)
-- Source system for Fivetran CDC -> Snowflake -> Power BI.
-- Tables are intentionally WIDE and DENORMALIZED: customer, address, restaurant,
-- item, partner and payment attributes are repeated on every row, the way a
-- real legacy order system / export often looks. Normalizing them into
-- dimensions and facts is the job of the Snowflake transformation layer.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS food_ops CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE food_ops;

-- 1) One row per ORDER LINE. Order-level, customer, restaurant, partner and payment
--    columns repeat on every line of the same order.
CREATE TABLE food_orders (
  order_line_id       BIGINT       NOT NULL AUTO_INCREMENT,
  order_id            INT          NOT NULL,
  order_line_no       SMALLINT     NOT NULL,
  order_status        VARCHAR(20)  NOT NULL,          -- PLACED/CONFIRMED/PREPARING/OUT_FOR_DELIVERY/DELIVERED/CANCELLED
  order_placed_at     DATETIME     NOT NULL,
  accepted_at         DATETIME     NULL,
  picked_up_at        DATETIME     NULL,
  delivered_at        DATETIME     NULL,
  cancelled_at        DATETIME     NULL,
  cancellation_reason VARCHAR(80)  NULL,
  -- customer + delivery address (repeated)
  customer_id         INT          NOT NULL,
  customer_name       VARCHAR(100) NOT NULL,
  customer_email      VARCHAR(120) NOT NULL,
  customer_phone      VARCHAR(15)  NULL,
  loyalty_tier        VARCHAR(10)  NULL,
  delivery_address    VARCHAR(200) NULL,
  delivery_locality   VARCHAR(80)  NULL,
  delivery_city       VARCHAR(50)  NOT NULL,
  delivery_state      VARCHAR(50)  NOT NULL,
  delivery_pincode    CHAR(6)      NULL,
  -- restaurant (repeated)
  restaurant_id       INT          NOT NULL,
  restaurant_name     VARCHAR(120) NOT NULL,
  cuisine_type        VARCHAR(40)  NOT NULL,
  -- item on this line
  item_id             INT          NOT NULL,
  item_name           VARCHAR(120) NOT NULL,
  category            VARCHAR(40)  NULL,
  is_veg              TINYINT(1)   NOT NULL,
  quantity            SMALLINT     NOT NULL,
  unit_price          DECIMAL(10,2) NOT NULL,
  line_total          DECIMAL(10,2) NOT NULL,
  -- order-level money (repeated on every line)
  order_subtotal      DECIMAL(10,2) NOT NULL,
  discount_amount     DECIMAL(10,2) NOT NULL DEFAULT 0,
  delivery_fee        DECIMAL(10,2) NOT NULL DEFAULT 0,
  tax_amount          DECIMAL(10,2) NOT NULL DEFAULT 0,
  order_total         DECIMAL(10,2) NOT NULL,
  promo_code          VARCHAR(20)  NULL,
  -- delivery partner (repeated)
  partner_id          INT          NULL,
  partner_name        VARCHAR(100) NULL,
  partner_phone       VARCHAR(15)  NULL,
  vehicle_type        VARCHAR(20)  NULL,
  -- payment (repeated)
  payment_method      VARCHAR(15)  NULL,              -- NULL for unpaid COD orders not yet delivered
  payment_status      VARCHAR(10)  NULL,              -- SUCCESS/FAILED/REFUNDED/PENDING
  transaction_ref     VARCHAR(30)  NULL,
  paid_at             DATETIME     NULL,
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (order_line_id),
  UNIQUE KEY uq_order_line (order_id, order_line_no),
  KEY idx_fo_customer (customer_id),
  KEY idx_fo_restaurant (restaurant_id),
  KEY idx_fo_status (order_status),
  KEY idx_fo_placed (order_placed_at)
) ENGINE=InnoDB;

-- 2) One row per REVIEW, with customer / restaurant / partner / order details copied in.
CREATE TABLE customer_reviews (
  review_id           INT          NOT NULL AUTO_INCREMENT,
  order_id            INT          NOT NULL,
  customer_id         INT          NOT NULL,
  customer_name       VARCHAR(100) NOT NULL,
  customer_email      VARCHAR(120) NOT NULL,
  loyalty_tier        VARCHAR(10)  NULL,
  restaurant_id       INT          NOT NULL,
  restaurant_name     VARCHAR(120) NOT NULL,
  cuisine_type        VARCHAR(40)  NOT NULL,
  restaurant_city     VARCHAR(50)  NOT NULL,
  restaurant_locality VARCHAR(80)  NULL,
  partner_id          INT          NULL,
  partner_name        VARCHAR(100) NULL,
  order_total         DECIMAL(10,2) NOT NULL,
  order_delivered_at  DATETIME     NULL,
  restaurant_rating   TINYINT      NOT NULL,
  delivery_rating     TINYINT      NOT NULL,
  review_text         VARCHAR(300) NULL,
  review_created_at   DATETIME     NOT NULL,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (review_id),
  UNIQUE KEY uq_review_order (order_id),
  KEY idx_cr_restaurant (restaurant_id)
) ENGINE=InnoDB;

-- 3) Menu catalogue: restaurant attributes repeated on every menu item row.
CREATE TABLE restaurant_menu (
  item_id             INT          NOT NULL AUTO_INCREMENT,
  restaurant_id       INT          NOT NULL,
  restaurant_name     VARCHAR(120) NOT NULL,
  cuisine_type        VARCHAR(40)  NOT NULL,
  restaurant_city     VARCHAR(50)  NOT NULL,
  restaurant_state    VARCHAR(50)  NOT NULL,
  restaurant_locality VARCHAR(80)  NULL,
  restaurant_pincode  CHAR(6)      NULL,
  avg_prep_time_min   SMALLINT     NULL,
  restaurant_is_open  TINYINT(1)   NOT NULL DEFAULT 1,
  commission_pct      DECIMAL(4,1) NOT NULL,
  item_name           VARCHAR(120) NOT NULL,
  category            VARCHAR(40)  NULL,
  is_veg              TINYINT(1)   NOT NULL,
  price               DECIMAL(10,2) NOT NULL,
  is_available        TINYINT(1)   NOT NULL DEFAULT 1,
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (item_id),
  KEY idx_rm_restaurant (restaurant_id)
) ENGINE=InnoDB;
