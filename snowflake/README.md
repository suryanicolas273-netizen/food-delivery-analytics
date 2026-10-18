# Snowflake Data Engineering

This folder contains SQL scripts for the Food Delivery Analytics project.

## Contents

- `01_data_validation.sql` — Data quality validation queries.
- `02_staging_views.sql` — Staging views and Fivetran CDC deleted-row filtering.
- `03_core_dimensions.sql` — Customer, restaurant, item, delivery partner, location, and date dimensions.
- `04_core_fact_tables.sql` — Order lines, orders, and customer reviews fact tables.

## Data Pipeline

MySQL / Aurora RDS → Fivetran → Snowflake → Power BI

**Note:** Review SQL scripts against the verified Snowflake definitions before executing them.
