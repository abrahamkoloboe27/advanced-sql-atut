-- ===================================================================
-- Fichier seed.sql - Données de démonstration pour shop_db
-- ===================================================================
-- Description : Petites données fictives pour reproduire tous les
--               exemples des slides de formation SQL PostgreSQL
-- Tables : customers, products, orders (≤ 5 lignes chacune)
-- Usage : psql -h localhost -p 5433 -U pguser -d shop_db -f sql/seed.sql
-- ===================================================================

-- Nettoyer les tables existantes (si nécessaire)
TRUNCATE TABLE orders, products, customers CASCADE;

-- ===================================================================
-- Table customers (clients)
-- ===================================================================
INSERT INTO customers (first_name, last_name, email, created_at) VALUES
    ('Alice', 'Martin', 'alice@example.com', '2023-06-15 10:00:00'),
    ('Bob', 'Dupont', 'bob@example.com', '2023-07-20 14:30:00'),
    ('Charlie', 'Bernard', 'charlie@example.com', '2023-08-10 09:15:00'),
    ('Diana', 'Lefevre', 'diana@example.com', '2023-09-05 16:45:00'),
    ('Eve', 'Moreau', 'eve@example.com', '2023-10-12 11:20:00');

-- ===================================================================
-- Table products (produits)
-- ===================================================================
INSERT INTO products (name, price, category, stock, created_at) VALUES
    ('Laptop', 899.99, 'Informatique', 10, '2024-01-05'),
    ('Souris', 29.99, 'Informatique', 50, '2024-01-10'),
    ('Clavier', 79.99, 'Informatique', 25, '2024-01-15'),
    ('Écran', 299.99, 'Informatique', 15, '2024-02-01'),
    ('Cahier', 5.99, 'Papeterie', 100, '2024-02-10'),
    ('Stylo', 2.49, 'Papeterie', 200, '2024-02-15');

-- ===================================================================
-- Table orders (commandes)
-- ===================================================================
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
    (1, '2024-01-15', 150.00, 'COMPLETED'),
    (1, '2024-01-20', 200.00, 'COMPLETED'),
    (2, '2024-01-18', 75.00, 'COMPLETED'),
    (3, '2024-02-01', 300.00, 'COMPLETED'),
    (2, '2024-02-05', 50.00, 'PENDING'),
    (4, '2024-02-10', 125.00, 'COMPLETED');

-- ===================================================================
-- Vérification des insertions
-- ===================================================================
SELECT 'Customers count:' AS info, COUNT(*) AS count FROM customers
UNION ALL
SELECT 'Products count:', COUNT(*) FROM products
UNION ALL
SELECT 'Orders count:', COUNT(*) FROM orders;

-- ===================================================================
-- Afficher un échantillon des données
-- ===================================================================
SELECT '=== CUSTOMERS ===' AS table_name;
SELECT customer_id, first_name, last_name, email FROM customers LIMIT 3;

SELECT '=== PRODUCTS ===' AS table_name;
SELECT product_id, name, price, category, stock FROM products LIMIT 3;

SELECT '=== ORDERS ===' AS table_name;
SELECT order_id, customer_id, order_date, total_amount, status FROM orders LIMIT 3;

-- ===================================================================
-- Notes :
-- - Ces données sont cohérentes avec les exemples des slides
-- - Les IDs sont séquentiels (1, 2, 3...) pour facilité lecture
-- - Montants et stocks réalistes mais simplifiés
-- - Dates en 2024 pour pertinence
-- ===================================================================
