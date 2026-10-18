# Food Delivery Analytics Architecture

## Overview

This project demonstrates an end-to-end data engineering and analytics workflow for a food delivery business.

## Architecture Flow

MySQL → AWS Aurora / Amazon RDS → Fivetran → Snowflake → Power BI

## Components

### 1. MySQL — Source Database

Contains the source tables:
- `food_orders`
- `restaurant_menu`
- `customer_reviews`

### 2. AWS Aurora / Amazon RDS

The intended managed MySQL-compatible database hosting layer. The actual deployment status must be verified separately.

### 3. Fivetran — Data Ingestion

Replicates source data into Snowflake. The project uses binary-log-based change capture for MySQL ingestion.

### 4. Snowflake — Data Warehouse

Stores replicated source data and supports staging, transformations, dimensional modeling, and data validation.

### 5. Power BI — Reporting

Connects to the analytical data model to report revenue, orders, customer behavior, restaurant performance, reviews, and delivery time.

## Data Modeling

The analytical model contains six dimension tables and three fact tables:

**Dimensions:** `DIM_CUSTOMER`, `DIM_RESTAURANT`, `DIM_ITEM`, `DIM_DELIVERY_PARTNER`, `DIM_LOCATION`, `DIM_DATE`

**Facts:** `FACT_ORDER_LINES`, `FACT_ORDERS`, `FACT_REVIEWS`

## Security

Never commit passwords, private keys, database credentials, or sensitive connection details to GitHub.
