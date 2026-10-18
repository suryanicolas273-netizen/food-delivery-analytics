# Food Delivery Analytics — End-to-End Data Engineering Project

## Project Overview

This project demonstrates an end-to-end data engineering and analytics pipeline for a food delivery business. It integrates data ingestion, cloud data warehousing, SQL-based transformation, dimensional modeling, and business intelligence reporting.

The goal is to analyze order performance, revenue, customer behavior, restaurant performance, customer reviews, and delivery operations.

## Architecture

**MySQL → AWS Aurora / Amazon RDS → Fivetran → Snowflake → Power BI**

1. **MySQL:** Source database containing food delivery orders, restaurant menus, and customer reviews.
2. **AWS Aurora / Amazon RDS:** Intended managed MySQL-compatible database hosting layer. Confirm the actual deployment status before describing it as an active environment.
3. **Fivetran:** Data ingestion and replication into Snowflake.
4. **Snowflake:** Data staging, SQL transformations, dimensional modeling, and analytical tables.
5. **Power BI:** Interactive dashboards for business analysis and reporting.

## Technologies Used

- **Database:** MySQL
- **Cloud Database:** AWS Aurora / Amazon RDS (intended architecture)
- **Data Ingestion:** Fivetran
- **Cloud Data Warehouse:** Snowflake
- **Transformation:** SQL
- **Business Intelligence:** Microsoft Power BI
- **Version Control:** Git and GitHub

## Data Sources

The project uses three primary source tables:

| Table | Description |
|---|---|
| `food_orders` | Food order and order-line details |
| `restaurant_menu` | Restaurant and menu item information |
| `customer_reviews` | Customer ratings and review information |

## Data Engineering Workflow

1. Ingest source data from MySQL through Fivetran.
2. Replicate source tables into Snowflake.
3. Build staging objects for cleaning and preparation.
4. Transform data into core dimensions and fact tables.
5. Validate record counts, relationships, and data quality.
6. Connect the analytical model to Power BI.
7. Develop dashboards to monitor business performance.

## Snowflake Data Modeling

The analytical model uses a star-schema approach with six dimension tables and three fact tables.

### Dimension Tables

- `DIM_CUSTOMER`
- `DIM_RESTAURANT`
- `DIM_ITEM`
- `DIM_DELIVERY_PARTNER`
- `DIM_LOCATION`
- `DIM_DATE`

### Fact Tables

- `FACT_ORDER_LINES` — one row per order line.
- `FACT_ORDERS` — one row per order.
- `FACT_REVIEWS` — one row per customer review.

The dimensions provide descriptive attributes, while the fact tables store measurable business events and metrics.

## Power BI Dashboard

The Power BI report analyzes:

- Total Revenue
- Total Orders
- Average Order Value
- Total Customers
- Cancelled Orders and Cancellation Rate
- Monthly Order Trends
- Average Delivery Time
- Restaurant Performance
- Customer Ratings and Reviews

### Verified Project Metrics

The current report contains the following recorded dataset figures:

| Metric | Value |
|---|---:|
| Total Orders | 6,000 |
| Order Lines | 14,763 |
| Menu Items | 5,180 |
| Customer Reviews | 2,483 |
| Delivered Revenue | ₹2,905,823 |
| Cancelled Orders | 458 |
| Average Delivery Time | 56.88 minutes |

These figures describe the current project dataset and may change if the underlying data or model is updated.

## Repository Structure

```text
food-delivery-analytics/
│
├── documentation/
│   ├── architecture.md
│   ├── star_schema.md
│   ├── powerbi_dashboard.md
│   ├── fivetran_setup.md
│   └── aws_aurora_setup.md
│
├── mysql/
│   ├── README.md
│   └── food_ops_mysql.sql
│
├── snowflake/
│   ├── README.md
│   ├── 01_data_validation.sql
│   ├── 02_staging_views.sql
│   ├── 03_core_dimensions.sql
│   └── 04_core_fact_tables.sql
│
├── powerbi/
│   ├── README.md
│   └── Food_Delivery_Analytics_2026.pbix
│
└── screenshots/
    └── food_delivery_overview.png
```

## Project Documentation and Files

- [Data Architecture](documentation/architecture.md)
- [Star Schema and Fact Table Grain](documentation/star_schema.md)
- [Power BI Dashboard Documentation](documentation/powerbi_dashboard.md)
- [Fivetran Ingestion Setup](documentation/fivetran_setup.md)
- [AWS Aurora / RDS Source Database Documentation](documentation/aws_aurora_setup.md)
- [MySQL Source Dataset and SQL Dump](mysql/)
- [Snowflake SQL Scripts](snowflake/)
- [Power BI Report](powerbi/)
- [Dashboard Screenshot](screenshots/food_delivery_overview.png)

## Data Quality and Validation

The project includes SQL scripts and validation practices for:

- Source and target record-count comparisons
- Duplicate record checks
- Null and missing-value checks
- Fact-table grain validation
- Dimension and fact relationship checks
- Order status and revenue consistency

## Security Notes

- Do not commit database passwords, private keys, connection strings, or AWS credentials.
- Do not publish live database endpoints or sensitive connection details.
- Review SQL scripts before executing them in any production or shared environment.

## Future Improvements

- Automate scheduled ingestion and transformations.
- Add monitoring and failure notifications.
- Expand data quality checks and reconciliation reporting.
- Optimize Snowflake warehouse usage and query performance.
- Add incremental processing and historical trend analysis.

## Author

**Surya Nicolas**

GitHub: [suryanicolas273-netizen](https://github.com/suryanicolas273-netizen)

---

*This project is intended as a practical portfolio demonstration of data engineering, cloud data warehousing, dimensional modeling, and business intelligence.*
