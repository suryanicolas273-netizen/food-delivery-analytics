# Fivetran to Snowflake — Data Ingestion

## 1. Objective

Fivetran replicates operational data from the MySQL-compatible `food_ops` source database into Snowflake for downstream transformation and analytics.

## 2. Source

- **Database:** `food_ops`
- **Engine:** MySQL / Aurora MySQL-compatible
- **Tables:** `food_orders`, `restaurant_menu`, `customer_reviews`

## 3. Destination

- **Warehouse:** Snowflake
- **Database:** `FOOD_DATA_DB`
- **Source schema:** `food_ops`
- **Staging schema:** `STAGING`

## 4. Ingestion Process

1. Configure the MySQL source connector in Fivetran.
2. Configure access to the source database and its change logs.
3. Configure the Snowflake destination.
4. Select the required source tables.
5. Run the initial synchronization.
6. Allow subsequent synchronization to replicate changes.
7. Transform replicated data using Snowflake SQL.

## 5. Change Data Capture (CDC)

The project uses the MySQL binary-log method for capturing source changes. Fivetran synchronizes supported inserts, updates, and deletes into the destination.

The `_fivetran_deleted` and `_fivetran_synced` metadata columns can help track replicated records and synchronization state.

## 6. Data Flow

MySQL → Fivetran → Snowflake STAGING → Snowflake CORE → Power BI

## 7. Security

Credentials, private keys, hostnames containing sensitive information, and connection strings must not be committed to GitHub. Store credentials securely in the appropriate service configuration.

## 8. Validation

Validate replicated row counts, deleted-record handling, identifier uniqueness, and data consistency before building downstream fact tables and reports.
