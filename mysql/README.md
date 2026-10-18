# MySQL Source Dataset

This folder contains the source SQL dataset for the Food Delivery Analytics project.

## Source Database

- **Database:** `food_ops`
- **Database engine:** MySQL / AWS Aurora MySQL-compatible
- **Purpose:** Source data for the food delivery analytics pipeline.

## Tables

- `food_orders` — order and order-line details.
- `restaurant_menu` — restaurant and menu item details.
- `customer_reviews` — customer ratings and review details.

## Pipeline

MySQL → Fivetran → Snowflake → Power BI

## Usage

Review the SQL dump before importing it. Test it in a development database rather than overwriting an existing database.

Do not store credentials or sensitive personal information in this repository.
