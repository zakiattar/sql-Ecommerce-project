-- ============================================================
-- SAMPLE DATA - E-COMMERCE USER PROFILE SYSTEM
-- ============================================================
-- Run this after connecting to ecommerce_profile_db in psql:
--   psql -U postgres -d ecommerce_profile_db -f 02_sample_data.sql
-- ============================================================

-- ------------------------------------------------------------
-- USERS
-- ------------------------------------------------------------
INSERT INTO users (full_name, email, phone, password_hash, gender, date_of_birth) VALUES
('Aarav Sharma',   'aarav.sharma@email.com',   '9876543210', 'hashed_pw_1', 'Male',   '1998-05-12'),
('Priya Verma',    'priya.verma@email.com',    '9876543211', 'hashed_pw_2', 'Female', '2000-11-23'),
('Rohan Mehta',    'rohan.mehta@email.com',    '9876543212', 'hashed_pw_3', 'Male',   '1995-02-08'),
('Sneha Patil',    'sneha.patil@email.com',    '9876543213', 'hashed_pw_4', 'Female', '1999-07-19'),
('Karan Malhotra', 'karan.malhotra@email.com', '9876543214', 'hashed_pw_5', 'Male',   '1997-03-30');

-- ------------------------------------------------------------
-- ADDRESSES
-- ------------------------------------------------------------
INSERT INTO addresses (user_id, address_line, city, state, pincode, address_type, is_default) VALUES
(1, '12 MG Road', 'Pune', 'Maharashtra', '411001', 'Home', TRUE),
(1, 'Office Park, Hinjewadi', 'Pune', 'Maharashtra', '411057', 'Work', FALSE),
(2, '45 Sector 21', 'Gurgaon', 'Haryana', '122001', 'Home', TRUE),
(3, '78 Park Street', 'Kolkata', 'West Bengal', '700016', 'Home', TRUE),
(4, '23 FC Road', 'Pune', 'Maharashtra', '411004', 'Home', TRUE),
(5, '9 Koramangala', 'Bangalore', 'Karnataka', '560034', 'Home', TRUE);

-- ------------------------------------------------------------
-- CATEGORIES
-- ------------------------------------------------------------
INSERT INTO categories (category_name) VALUES
('Electronics'),
('Fashion'),
('Home & Kitchen'),
('Books'),
('Sports & Fitness');

-- ------------------------------------------------------------
-- PRODUCTS
-- ------------------------------------------------------------
INSERT INTO products (category_id, product_name, description, price, stock_qty) VALUES
(1, 'Wireless Earbuds Pro',      'Noise cancelling wireless earbuds', 2999.00, 150),
(1, 'Smartwatch Series X',       'Fitness tracking smartwatch',       4999.00, 80),
(1, 'Laptop Stand',              'Aluminium adjustable laptop stand', 1299.00, 200),
(2, 'Cotton Casual Shirt',       'Men''s slim fit cotton shirt',      899.00,  300),
(2, 'Running Shoes',             'Lightweight running shoes',         2499.00, 120),
(3, 'Non-Stick Cookware Set',    '5-piece non-stick cookware set',    1999.00, 90),
(3, 'LED Desk Lamp',             'Adjustable brightness desk lamp',   799.00,  160),
(4, 'The Alchemist',             'Bestselling novel by Paulo Coelho', 299.00,  500),
(4, 'Atomic Habits',             'Self-help book by James Clear',     399.00,  450),
(5, 'Yoga Mat',                  'Anti-slip yoga mat 6mm',            699.00,  200);

-- ------------------------------------------------------------
-- CART (active items in users' carts)
-- ------------------------------------------------------------
INSERT INTO cart (user_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 9, 2),
(2, 5, 1),
(3, 6, 1),
(4, 8, 3);

-- ------------------------------------------------------------
-- WISHLIST
-- ------------------------------------------------------------
INSERT INTO wishlist (user_id, product_id) VALUES
(1, 2),
(1, 5),
(2, 1),
(2, 10),
(3, 4),
(5, 2);

-- ------------------------------------------------------------
-- ORDERS
-- ------------------------------------------------------------
INSERT INTO orders (user_id, address_id, status, total_amount) VALUES
(1, 1, 'Delivered', 5998.00),
(2, 3, 'Shipped',   2499.00),
(3, 4, 'Pending',   1999.00),
(4, 5, 'Delivered', 897.00),
(5, 6, 'Cancelled', 699.00);

-- ------------------------------------------------------------
-- ORDER_ITEMS
-- ------------------------------------------------------------
INSERT INTO order_items (order_id, product_id, quantity, price_each) VALUES
(1, 1, 2, 2999.00),
(2, 5, 1, 2499.00),
(3, 6, 1, 1999.00),
(4, 8, 3, 299.00),
(5, 10, 1, 699.00);

-- ------------------------------------------------------------
-- PAYMENTS
-- ------------------------------------------------------------
INSERT INTO payments (order_id, payment_method, payment_status, paid_at) VALUES
(1, 'UPI',          'Success', '2026-06-10 10:15:00'),
(2, 'Credit Card',  'Success', '2026-07-02 14:20:00'),
(3, 'COD',          'Pending', NULL),
(4, 'Debit Card',   'Success', '2026-07-20 09:05:00'),
(5, 'UPI',          'Refunded', '2026-07-25 18:40:00');

-- ------------------------------------------------------------
-- REVIEWS
-- ------------------------------------------------------------
INSERT INTO reviews (user_id, product_id, rating, comment) VALUES
(1, 1, 5, 'Excellent sound quality, worth the price!'),
(2, 5, 4, 'Comfortable shoes, good for daily running.'),
(4, 8, 5, 'A must-read classic. Loved it.'),
(3, 6, 4, 'Good quality cookware, easy to clean.'),
(5, 10, 3, 'Decent mat but a bit thin.');
