# Food Delivery Analytics

## Project Overview
An end-to-end data engineering and analytics project to analyze food delivery orders, revenue, restaurant performance, customer reviews, and delivery efficiency.

## Architecture
MySQL → AWS Aurora RDS → Fivetran → Snowflake → Power BI

## Technologies Used
- MySQL
- AWS Aurora RDS
- Fivetran
- Snowflake SQL
- Microsoft Power BI

## Key Business Metrics
- Total Revenue
- Total Orders
- Average Order Value
- Total Customers
- Order Cancellation Rate
- Average Delivery Time
- Restaurant Performance
- Customer Ratings

## Data Engineering
- MySQL serves as the source database.
- AWS Aurora RDS hosts the replicated source data.
- Fivetran replicates data into Snowflake using binary-log-based change capture.
- Snowflake supports analytical SQL and data modeling.
- Fact and dimension tables support Power BI reporting.

## Power BI Dashboard
The report analyzes business KPIs, monthly order trends, order status, customer reviews, and delivery operations.

## Dataset Summary
- Orders: 6,000
- Order lines: 14,763
- Items: 5,180
- Customer reviews: 2,483

## Future Improvements
- Automate Snowflake transformations.
- Add data quality checks.
- Validate source-to-target row counts.
- Document incremental loading and deduplication.
- Improve restaurant and delivery analytics.

## Security
Never publish passwords, private keys, database credentials, or confidential customer data.