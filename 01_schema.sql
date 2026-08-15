-- ============================================================
-- E-COMMERCE USER PROFILE SYSTEM - DATABASE SCHEMA
-- ============================================================
-- Compatible with: PostgreSQL 13+
-- ============================================================
-- NOTE: Create the database first (outside this script), then
-- connect to it and run this file:
--
--   CREATE DATABASE ecommerce_profile_db;
--   \c ecommerce_profile_db
--
-- (psql -U postgres -d ecommerce_profile_db -f 01_schema.sql)
-- ============================================================

-- Drop tables if they already exist (reverse dependency order)
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS wishlist CASCADE;
DROP TABLE IF EXISTS cart CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS addresses CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Drop enum types if they exist
DROP TYPE IF EXISTS gender_type;
DROP TYPE IF EXISTS address_type_enum;
DROP TYPE IF EXISTS order_status_type;
DROP TYPE IF EXISTS payment_method_type;
DROP TYPE IF EXISTS payment_status_type;

-- ------------------------------------------------------------
-- CUSTOM ENUM TYPES (PostgreSQL way of doing ENUM)
-- ------------------------------------------------------------
CREATE TYPE gender_type AS ENUM ('Male', 'Female', 'Other');
CREATE TYPE address_type_enum AS ENUM ('Home', 'Work', 'Other');
CREATE TYPE order_status_type AS ENUM ('Pending', 'Shipped', 'Delivered', 'Cancelled');
CREATE TYPE payment_method_type AS ENUM ('UPI', 'Credit Card', 'Debit Card', 'COD', 'Net Banking');
CREATE TYPE payment_status_type AS ENUM ('Pending', 'Success', 'Failed', 'Refunded');

-- ------------------------------------------------------------
-- 1. USERS TABLE - Core profile information
-- ------------------------------------------------------------
CREATE TABLE users (
    user_id       SERIAL PRIMARY KEY,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100) NOT NULL UNIQUE,
    phone         VARCHAR(15) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    gender        gender_type,
    date_of_birth DATE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active     BOOLEAN DEFAULT TRUE
);

-- ------------------------------------------------------------
-- 2. ADDRESSES TABLE - Users can have multiple addresses
-- ------------------------------------------------------------
CREATE TABLE addresses (
    address_id    SERIAL PRIMARY KEY,
    user_id       INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    address_line  VARCHAR(255) NOT NULL,
    city          VARCHAR(50) NOT NULL,
    state         VARCHAR(50) NOT NULL,
    pincode       VARCHAR(10) NOT NULL,
    country       VARCHAR(50) DEFAULT 'India',
    address_type  address_type_enum DEFAULT 'Home',
    is_default    BOOLEAN DEFAULT FALSE
);

-- ------------------------------------------------------------
-- 3. CATEGORIES TABLE - Product categories
-- ------------------------------------------------------------
CREATE TABLE categories (
    category_id   SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);

-- ------------------------------------------------------------
-- 4. PRODUCTS TABLE
-- ------------------------------------------------------------
CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    category_id   INT REFERENCES categories(category_id) ON DELETE SET NULL,
    product_name  VARCHAR(150) NOT NULL,
    description   TEXT,
    price         DECIMAL(10,2) NOT NULL,
    stock_qty     INT DEFAULT 0,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- 5. CART TABLE - Active shopping cart per user
-- ------------------------------------------------------------
CREATE TABLE cart (
    cart_id       SERIAL PRIMARY KEY,
    user_id       INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    product_id    INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    quantity      INT NOT NULL DEFAULT 1,
    added_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_cart_item UNIQUE (user_id, product_id)
);

-- ------------------------------------------------------------
-- 6. WISHLIST TABLE
-- ------------------------------------------------------------
CREATE TABLE wishlist (
    wishlist_id   SERIAL PRIMARY KEY,
    user_id       INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    product_id    INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    added_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_wishlist_item UNIQUE (user_id, product_id)
);

-- ------------------------------------------------------------
-- 7. ORDERS TABLE
-- ------------------------------------------------------------
CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    user_id       INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    address_id    INT NOT NULL REFERENCES addresses(address_id),
    order_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status        order_status_type DEFAULT 'Pending',
    total_amount  DECIMAL(10,2) NOT NULL
);

-- ------------------------------------------------------------
-- 8. ORDER_ITEMS TABLE - Line items for each order
-- ------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL,
    price_each    DECIMAL(10,2) NOT NULL
);

-- ------------------------------------------------------------
-- 9. PAYMENTS TABLE
-- ------------------------------------------------------------
CREATE TABLE payments (
    payment_id     SERIAL PRIMARY KEY,
    order_id       INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_method payment_method_type NOT NULL,
    payment_status payment_status_type DEFAULT 'Pending',
    paid_at        TIMESTAMP NULL
);

-- ------------------------------------------------------------
-- 10. REVIEWS TABLE - Product reviews by users
-- ------------------------------------------------------------
CREATE TABLE reviews (
    review_id     SERIAL PRIMARY KEY,
    user_id       INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    product_id    INT NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    rating        SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment       TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------
-- INDEXES for performance
-- ------------------------------------------------------------
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_cart_user ON cart(user_id);
CREATE INDEX idx_wishlist_user ON wishlist(user_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);

-- ------------------------------------------------------------
-- TRIGGER: auto-update "updated_at" on users table
-- (Postgres has no native ON UPDATE CURRENT_TIMESTAMP like MySQL)
-- ------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();
