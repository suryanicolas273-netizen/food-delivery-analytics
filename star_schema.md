# Food Delivery Analytics — Star Schema

## 1. What Is a Star Schema?

A star schema is a data warehouse design in which a central fact table connects to dimension tables. It simplifies analytical queries and reporting in Power BI.

## 2. Fact Tables

| Fact table | Grain | Example measures |
|---|---|---|
| `FACT_ORDER_LINES` | One row per order line | Quantity, line total, unit price |
| `FACT_ORDERS` | One row per order | Order total, discount, delivery fee |
| `FACT_REVIEWS` | One row per review | Restaurant rating, delivery rating |

**Grain** means what a single row represents. Establishing the grain prevents double-counting.

## 3. Dimension Tables

| Dimension | Purpose |
|---|---|
| `DIM_CUSTOMER` | Customer details and loyalty tier |
| `DIM_RESTAURANT` | Restaurant name and cuisine |
| `DIM_ITEM` | Menu item, category, and price |
| `DIM_DELIVERY_PARTNER` | Partner details and vehicle type |
| `DIM_LOCATION` | Delivery address and location attributes |
| `DIM_DATE` | Date, month, quarter, and year analysis |

## 4. Relationship Design

Dimension tables provide descriptive attributes. Fact tables contain transactional records and measures.

Typical relationships use one-to-many cardinality:

`Dimension (1) → Fact (*)`

Examples:
- Customer to orders.
- Restaurant to orders.
- Item to order lines.
- Date to orders.

The exact foreign-key columns and relationship paths must match the implemented Snowflake model and Power BI relationships.

## 5. Why Use a Star Schema?

- Simplifies analytical SQL.
- Reduces repeated descriptive data in the reporting model.
- Supports filtering and grouping by customer, restaurant, item, and date.
- Makes Power BI measures easier to maintain.
- Helps prevent double-counting when fact-table grain is respected.

## 6. Example Business Questions

- What is the delivered revenue by month?
- Which restaurants receive the most orders?
- What percentage of orders are cancelled?
- What is the average delivery time by month?
- How do customer ratings vary across restaurants?

## 7. Key Interview Point

A fact table stores measurable business events at a defined grain. A dimension table stores descriptive attributes used to filter, group, and analyze those events.
