-- ============================================================================
-- Script: insert_seed.sql
-- Description: Données initiales (seed) pour les tables de shop_db
-- ============================================================================

\echo '============================================================'
\echo 'INSERTION DES DONNÉES INITIALES (SEED)'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: INSERT INTO
-- Description: Insère de nouvelles lignes dans une table
-- Syntaxe: INSERT INTO table (col1, col2, ...) VALUES (val1, val2, ...)
-- ============================================================================


-- INSERTION dans CUSTOMERS
-- ============================================================================

\echo '1️⃣ Insertion de clients...'

INSERT INTO customers (first_name, last_name, email, created_at) VALUES
    ('Jean', 'Dupont', 'jean.dupont@email.fr', '2024-01-15 10:30:00'),
    ('Marie', 'Martin', 'marie.martin@email.fr', '2024-02-20 14:15:00'),
    ('Pierre', 'Durand', 'pierre.durand@email.fr', '2024-03-10 09:45:00'),
    ('Sophie', 'Leclerc', 'sophie.leclerc@email.fr', '2024-04-05 16:20:00'),
    ('Lucas', 'Moreau', 'lucas.moreau@email.fr', '2024-05-12 11:00:00');

\echo '✅ 5 clients insérés!'
\echo ''


-- INSERTION dans PRODUCTS
-- ============================================================================

\echo '2️⃣ Insertion de produits...'

INSERT INTO  products (name, price, category, stock) VALUES
    ('Laptop', 899.99, 'Electronics', 10),
    ('Souris', 29.99, 'Electronics', 50),
    ('Clavier', 79.99, 'Electronics', 30),
    ('Écran', 249.99, 'Electronics', 20),
    ('Casque', 59.99, 'Accessories', 40),
    ('Webcam', 49.99, 'Accessories', 25);
\echo '✅ 6 produits insérés!'
\echo ''


-- INSERTION dans ORDERS
-- ============================================================================

\echo '3️⃣ Insertion de commandes...'

-- Commandes complètes
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
    (1, '2024-06-01 10:00:00', 929.98, 'COMPLETED'),   -- Jean: Laptop + Souris
    (2, '2024-06-05 14:30:00', 79.99, 'COMPLETED'),    -- Marie: Clavier
    (3, '2024-06-10 09:15:00', 249.98, 'COMPLETED'),   -- Pierre: Écran + Souris
    (1, '2024-06-15 16:45:00', 109.98, 'COMPLETED'),   -- Jean: Casque + Webcam
    (4, '2024-06-20 11:20:00', 899.99, 'PENDING'),     -- Sophie: Laptop (en cours)
    (5, '2024-06-25 13:00:00', 139.98, 'CANCELLED');   -- Lucas: Écran (annulée)

\echo '✅ 6 commandes insérées!'
\echo ''


-- ============================================================================
-- VÉRIFICATION DES DONNÉES INSÉRÉES
-- ============================================================================

\echo '============================================================'
\echo 'VÉRIFICATION DES DONNÉES'
\echo '============================================================'
\echo ''

\echo '📊 Contenu de la table CUSTOMERS:'
SELECT * FROM customers ORDER BY customer_id;

\echo ''
\echo '📊 Contenu de la table PRODUCTS:'
SELECT * FROM products ORDER BY product_id;

\echo ''
\echo '📊 Contenu de la table ORDERS:'
SELECT * FROM orders ORDER BY order_id;

\echo ''


-- ============================================================================
-- STATISTIQUES RAPIDES
-- ============================================================================

\echo '============================================================'
\echo 'STATISTIQUES'
\echo '============================================================'
\echo ''

\echo '📈 Nombre total de clients:'
SELECT
    COUNT(*) AS total_customers
FROM customers;

\echo ''
\echo '📈 Nombre total de produits:'
SELECT COUNT(*) AS total_products FROM products;

\echo ''
\echo '📈 Nombre total de commandes:'
SELECT COUNT(*) AS total_orders FROM orders;

\echo ''
\echo '📈 Chiffre d affaires total (commandes complétées):'
SELECT SUM(total_amount) AS total_revenue 
FROM orders 
WHERE status = 'COMPLETED';

\echo ''


-- ============================================================================
-- AUTRES EXEMPLES D'INSERT
-- ============================================================================

\echo '============================================================'
\echo 'AUTRES TECHNIQUES D INSERTION'
\echo '============================================================'
\echo ''

-- Exemple 1: INSERT avec RETURNING (retourne les valeurs insérées)
-- ============================================================================
\echo '📝 Exemple: INSERT avec RETURNING...'

INSERT INTO customers (first_name, last_name, email) 
VALUES ('Alice', 'Bernard', 'alice.bernard@email.fr')
RETURNING customer_id, first_name, last_name, created_at;

\echo ''


-- Exemple 2: INSERT depuis une requête SELECT
-- ============================================================================
\echo '📝 Exemple: INSERT depuis SELECT...'

-- Créer une table temporaire pour la démo
CREATE TEMP TABLE premium_customers AS
SELECT customer_id, first_name, last_name, email
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id 
    FROM orders 
    WHERE total_amount > 500
);

\echo '✅ Table temporaire premium_customers créée!'

SELECT * FROM premium_customers;

\echo ''


-- Exemple 3: INSERT avec DEFAULT VALUES
-- ============================================================================
\echo '📝 Exemple: INSERT avec valeurs par défaut...'

-- Insérer un produit avec valeurs par défaut pour stock et category
INSERT INTO products (name, price) 
VALUES ('Adaptateur USB-C', 19.99);

\echo '✅ Produit inséré avec valeurs par défaut!'
\echo '   (category = General, stock = 0)'

SELECT * FROM products WHERE name = 'Adaptateur USB-C';

\echo ''


-- ============================================================================
-- NETTOYAGE (optionnel)
-- ============================================================================

-- Supprimer le produit de test
DELETE FROM products WHERE name = 'Adaptateur USB-C';

-- Supprimer le client de test
DELETE FROM customers WHERE email = 'alice.bernard@email.fr';

\echo ''
\echo '============================================================'
\echo '✅ SEED TERMINÉ AVEC SUCCÈS!'
\echo '============================================================'
\echo ''
\echo 'Base de données shop_db peuplée avec:'
\echo '  • 5 clients'
\echo '  • 6 produits'
\echo '  • 6 commandes'
\echo ''
\echo 'Vous pouvez maintenant explorer les données avec SELECT!'
\echo '============================================================'
