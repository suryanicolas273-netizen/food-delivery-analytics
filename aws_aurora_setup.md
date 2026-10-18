# AWS Aurora RDS — MySQL Source Database

## 1. Purpose

AWS Aurora MySQL-compatible is the managed relational database layer in the Food Delivery Analytics architecture. It hosts the operational data consumed by the ingestion pipeline.

## 2. Database

- **Database name:** `food_ops`
- **Engine:** MySQL-compatible database
- **Hosting layer:** AWS Aurora / Amazon RDS
- **Ingestion tool:** Fivetran
- **Destination:** Snowflake

## 3. Source Tables

| Table | Purpose |
|---|---|
| `food_orders` | Order-line, customer, restaurant, delivery and payment details |
| `restaurant_menu` | Restaurant and menu item attributes |
| `customer_reviews` | Customer ratings and written reviews |

## 4. Pipeline Flow

1. Operational records are stored in the `food_ops` database.
2. Fivetran connects to the configured MySQL-compatible source.
3. Fivetran reads changes using the configured binary-log CDC method.
4. Replicated records are loaded into Snowflake.
5. Snowflake SQL builds staging views and analytical fact and dimension tables.
6. Power BI uses the modeled data for dashboards.

## 5. Connectivity and Security

The source must be reachable from Fivetran using the configured network and database permissions. Only the necessary access should be granted.

Do not publish database endpoints, usernames, passwords, security keys, or connection strings in this repository.

## 6. Validation

Validate source-to-destination row counts, primary identifiers, update and delete handling, and data consistency.

## 7. Environment Note

Document the actual AWS deployment details only when verified. The project architecture describes the intended database hosting layer; it does not imply that an AWS instance is currently running.
