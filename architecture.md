# Food Delivery Analytics — Data Architecture

## 1. Project Overview

This project builds an end-to-end food delivery analytics pipeline. Operational data is ingested into Snowflake, transformed into a dimensional data model, and presented through an interactive Power BI dashboard.

## 2. Technology Stack

- **Source database:** MySQL / AWS Aurora RDS
- **Data ingestion:** Fivetran
- **Cloud data warehouse:** Snowflake
- **Data transformation:** Snowflake SQL
- **Visualization:** Power BI
- **Version control:** Git and GitHub

## 3. Data Flow

MySQL / Aurora RDS → Fivetran → Snowflake → Power BI

1. **Source:** MySQL stores food orders, restaurant menu items, and customer reviews.
2. **Ingestion:** Fivetran replicates source data into Snowflake and captures changes using change data capture (CDC).
3. **Staging:** Staging views filter records marked as deleted by Fivetran.
4. **Core modeling:** Snowflake SQL transforms denormalized operational data into dimension and fact tables.
5. **Reporting:** Power BI uses the dimensional model to calculate KPIs and display trends.

## 4. Dimensional Model

### Dimension tables

- `DIM_CUSTOMER`
- `DIM_RESTAURANT`
- `DIM_ITEM`
- `DIM_DELIVERY_PARTNER`
- `DIM_LOCATION`
- `DIM_DATE`

### Fact tables

- `FACT_ORDER_LINES` — one row per order line.
- `FACT_ORDERS` — one row per order.
- `FACT_REVIEWS` — one row per customer review.

The fact-table grain is important because it determines which metrics can be calculated without double-counting.

## 5. Data Quality

The project includes SQL checks for:

- Null and duplicate identifiers.
- Order-line totals compared with quantity multiplied by unit price.
- Consistency of order-level totals across order lines.
- Review and menu item identifiers.
- Date-key and dimension matching.

## 6. Power BI Dashboard

The report analyzes revenue, orders, average order value, customers, cancellations, customer ratings, and average delivery time.

## 7. Important Note

The SQL scripts in this repository should be checked against the verified Snowflake implementation before execution. Never commit database passwords, private keys, or other credentials.
