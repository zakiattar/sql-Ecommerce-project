-- ============================================================
-- USEFUL QUERIES - E-COMMERCE USER PROFILE SYSTEM
-- ============================================================
-- Run against ecommerce_profile_db (PostgreSQL)
-- ============================================================

-- ------------------------------------------------------------
-- 1. Get complete profile of a user (basic info + default address)
-- ------------------------------------------------------------
SELECT u.user_id, u.full_name, u.email, u.phone, u.gender,
       a.address_line, a.city, a.state, a.pincode
FROM users u
JOIN addresses a ON u.user_id = a.user_id AND a.is_default = TRUE
WHERE u.user_id = 1;

-- ------------------------------------------------------------
-- 2. View a user's current cart with product details and total price
-- ------------------------------------------------------------
SELECT c.cart_id, p.product_name, p.price, c.quantity,
       (p.price * c.quantity) AS subtotal
FROM cart c
JOIN products p ON c.product_id = p.product_id
WHERE c.user_id = 1;

-- ------------------------------------------------------------
-- 3. View a user's wishlist
-- ------------------------------------------------------------
SELECT w.wishlist_id, p.product_name, p.price, w.added_at
FROM wishlist w
JOIN products p ON w.product_id = p.product_id
WHERE w.user_id = 2;

-- ------------------------------------------------------------
-- 4. Full order history of a user with item-level details
-- ------------------------------------------------------------
SELECT o.order_id, o.order_date, o.status, o.total_amount,
       p.product_name, oi.quantity, oi.price_each
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.user_id = 1
ORDER BY o.order_date DESC;

-- ------------------------------------------------------------
-- 5. Total amount spent by each user (only successful payments)
-- ------------------------------------------------------------
SELECT u.user_id, u.full_name, SUM(o.total_amount) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.user_id
JOIN payments py ON o.order_id = py.order_id
WHERE py.payment_status = 'Success'
GROUP BY u.user_id, u.full_name
ORDER BY total_spent DESC;

-- ------------------------------------------------------------
-- 6. Most wishlisted products (popularity ranking)
-- ------------------------------------------------------------
SELECT p.product_name, COUNT(w.wishlist_id) AS wishlist_count
FROM wishlist w
JOIN products p ON w.product_id = p.product_id
GROUP BY p.product_name
ORDER BY wishlist_count DESC;

-- ------------------------------------------------------------
-- 7. Best-selling products by quantity sold
-- ------------------------------------------------------------
SELECT p.product_name, SUM(oi.quantity) AS total_units_sold,
       SUM(oi.quantity * oi.price_each) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC;

-- ------------------------------------------------------------
-- 8. Average product rating with review count
-- ------------------------------------------------------------
SELECT p.product_name, ROUND(AVG(r.rating), 2) AS avg_rating,
       COUNT(r.review_id) AS total_reviews
FROM reviews r
JOIN products p ON r.product_id = p.product_id
GROUP BY p.product_name
ORDER BY avg_rating DESC;

-- ------------------------------------------------------------
-- 9. Users who have not placed any order yet
-- ------------------------------------------------------------
SELECT u.user_id, u.full_name, u.email
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;

-- ------------------------------------------------------------
-- 10. Orders that are still pending payment
-- ------------------------------------------------------------
SELECT o.order_id, u.full_name, o.total_amount, py.payment_status
FROM orders o
JOIN users u ON o.user_id = u.user_id
JOIN payments py ON o.order_id = py.order_id
WHERE py.payment_status = 'Pending';

-- ------------------------------------------------------------
-- 11. Category-wise revenue breakdown
-- ------------------------------------------------------------
SELECT cat.category_name, SUM(oi.quantity * oi.price_each) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
GROUP BY cat.category_name
ORDER BY revenue DESC;

-- ------------------------------------------------------------
-- 12. Products low on stock (inventory alert, threshold = 100)
-- ------------------------------------------------------------
SELECT product_name, stock_qty
FROM products
WHERE stock_qty < 100
ORDER BY stock_qty ASC;

-- ------------------------------------------------------------
-- 13. Products in a user's cart that are ALSO in their wishlist
--     (cross-check demo using subquery)
-- ------------------------------------------------------------
SELECT p.product_name
FROM cart c
JOIN products p ON c.product_id = p.product_id
WHERE c.user_id = 1
  AND c.product_id IN (
      SELECT product_id FROM wishlist WHERE user_id = 1
  );

-- ------------------------------------------------------------
-- 14. Monthly order count and revenue trend
-- ------------------------------------------------------------
SELECT TO_CHAR(order_date, 'YYYY-MM') AS month,
       COUNT(order_id) AS total_orders,
       SUM(total_amount) AS revenue
FROM orders
GROUP BY month
ORDER BY month;

-- ------------------------------------------------------------
-- 15. Top 3 highest-spending customers (window function)
-- ------------------------------------------------------------
SELECT full_name, total_spent, spend_rank
FROM (
    SELECT u.full_name, SUM(o.total_amount) AS total_spent,
           RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS spend_rank
    FROM users u
    JOIN orders o ON u.user_id = o.user_id
    GROUP BY u.full_name
) ranked
WHERE spend_rank <= 3;
