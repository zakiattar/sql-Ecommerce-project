# 🛒 E-Commerce User Profile System (SQL Project)

A relational database project simulating an **e-commerce user profile system** — covering user accounts, addresses, product catalog, shopping cart, wishlist, orders, payments, and reviews.

Built to demonstrate schema design, normalization, relationships (1:1, 1:N, M:N), and real-world SQL querying skills (joins, subqueries, aggregations, window functions).

---

## 📌 Features

- **User Profiles** – account details, multiple saved addresses
- **Product Catalog** – categorized products with stock tracking
- **Cart & Wishlist** – active shopping cart and saved-for-later items
- **Orders & Order Items** – full order lifecycle with line items
- **Payments** – payment method & status tracking per order
- **Reviews & Ratings** – users can rate/review products
- **15+ ready-to-run analytical queries** – revenue reports, top customers, best sellers, etc.

---

## 🗂️ Entity Relationship Overview

users has many addresses.
users has many cart items and wishlist items, which link to products.
products belong to categories.
users place many orders, each order linked to one address.
each order has many order_items, which link to products.
each order has one payment.
users write many reviews, linked to products.

**Relationship summary:**

| Relationship | Type |
|---|---|
| users to addresses | One-to-Many |
| users to orders | One-to-Many |
| orders to order_items | One-to-Many |
| orders to payments | One-to-One |
| users and products via cart | Many-to-Many |
| users and products via wishlist | Many-to-Many |
| users and products via reviews | Many-to-Many |

---

## 📁 Project Structure

- 01_schema.sql — Table definitions, keys, constraints, indexes
- 02_sample_data.sql — Sample records for testing
- 03_queries.sql — 15 analytical/reporting queries
- README.md

---

## 🚀 How to Run (PostgreSQL)

1. Install PostgreSQL locally, or use an online sandbox like DB Fiddle (select PostgreSQL as the DBMS).
2. Create the database first:
   createdb ecommerce_profile_db
   (or in psql: CREATE DATABASE ecommerce_profile_db;)
3. Run the files in order:
   psql -U postgres -d ecommerce_profile_db -f 01_schema.sql
   psql -U postgres -d ecommerce_profile_db -f 02_sample_data.sql
   psql -U postgres -d ecommerce_profile_db -f 03_queries.sql
4. Or open each file in pgAdmin / DBeaver and execute sequentially against ecommerce_profile_db.

Note: This schema uses native PostgreSQL ENUM types (CREATE TYPE ... AS ENUM) and a trigger to auto-update the updated_at column, since Postgres doesn't have MySQL's ON UPDATE CURRENT_TIMESTAMP.

---

## 🔍 Sample Query Highlights

- Total amount spent per user (successful payments only)
- Most wishlisted / best-selling products
- Average product rating with review count
- Users who haven't placed any order yet
- Category-wise revenue breakdown
- Monthly revenue trend
- Top 3 customers using RANK() OVER window function

See 03_queries.sql for all 15 queries.

---

## 🛠️ Tech Used

- Database: PostgreSQL 13+
- Concepts: Normalization, Foreign Keys, Joins, Subqueries, Aggregate Functions, Window Functions, Indexing, Custom ENUM Types, Triggers

---

## 📈 Possible Extensions

- Add a coupons / discounts table
- Add product_images table for multiple images per product
- Add stored procedures for placing an order (with stock deduction)
- Build a front-end (Node.js / Django) on top of this schema

---

## 👤 Author

Built as a learning/portfolio project to practice relational database design and SQL querying.

---

⭐ If you found this useful, consider starring the repo!
