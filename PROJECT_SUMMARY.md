# Food Delivery Analytics — Project Summary

## 1. Project Overview

This project demonstrates an end-to-end data engineering and analytics workflow for a food delivery business. Data is ingested from MySQL, replicated through AWS RDS/Aurora and Fivetran, transformed and modeled in Snowflake, and visualized in Power BI.

## 2. Architecture

MySQL → AWS RDS/Aurora → Fivetran CDC → Snowflake → Power BI

**Important:** The architecture describes the intended project pipeline. Confirm that each cloud service is currently deployed and running before claiming live production operation.

## 3. Technologies Used

- **MySQL:** Source database
- **AWS RDS/Aurora:** Database replication/source infrastructure
- **Fivetran:** Data ingestion and change data capture (CDC)
- **Snowflake:** Cloud data warehouse and SQL transformations
- **Power BI:** Business intelligence and interactive reporting
- **GitHub:** Version control and project documentation

## 4. Data Warehouse Design

The Snowflake model contains six dimension tables:

- `DIM_CUSTOMER`
- `DIM_RESTAURANT`
- `DIM_ITEM`
- `DIM_DELIVERY_PARTNER`
- `DIM_LOCATION`
- `DIM_DATE`

It also contains three fact tables:

- `FACT_ORDERS` — one row per order
- `FACT_ORDER_LINES` — one row per order line
- `FACT_REVIEWS` — one row per review

The model uses a star-schema approach to support business analysis in Power BI.

## 5. Verified Report Metrics

- Total orders: **6,000**
- Total order lines: **14,763**
- Total items: **5,180**
- Total customer reviews: **2,483**
- Delivered revenue: **₹2,905,823**
- Cancelled orders: **458**
- Average delivery time: **56.88 minutes** (approximately 57 minutes)

These figures represent the verified report version and should be revalidated if the underlying data changes.

## 6. Data Engineering Concepts Demonstrated

- Source-to-warehouse data movement
- Change data capture (CDC)
- Raw/staging and core data layers
- SQL views and transformations
- Dimension and fact table design
- Fact-table grain
- Deduplication using `ROW_NUMBER()`
- Data quality and reconciliation checks
- BI reporting and business KPI analysis

## 7. Business Questions Answered

- What is the delivered revenue?
- How many orders are placed or cancelled?
- How does order volume change month by month?
- What is the average delivery time?
- Which restaurants perform best?
- What do customer ratings and reviews indicate?

## 8. Repository Contents

- `snowflake/` — SQL scripts for validation, staging views, dimensions, and fact tables
- `powerbi/` — Power BI report
- `screenshots/` — dashboard preview
- `README.md` — project introduction and setup guidance

## 9. Key Learning Outcomes

This project demonstrates practical skills in SQL, data ingestion concepts, warehouse modeling, data validation, KPI design, and communicating business insights through dashboards.

## 10. Security Note

No passwords, access keys, private connection strings, or production credentials should be committed to this repository.
