-- ============================================================================
-- Script: select_queries.sql
-- Description: Exemples de requêtes SELECT (simples, jointures, agrégations)
-- ============================================================================

\echo '============================================================'
\echo 'EXEMPLES DE REQUÊTES SELECT'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: SELECT
-- Description: Récupère des données depuis une ou plusieurs tables
-- Clauses: WHERE, JOIN, GROUP BY, HAVING, ORDER BY, LIMIT, OFFSET
-- ============================================================================


-- PARTIE 1: SELECT SIMPLES
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 1: SELECT SIMPLES'
\echo '============================================================'
\echo ''

-- Exemple 1: Sélectionner toutes les colonnes
\echo '1️⃣ Sélectionner tous les clients:'
SELECT * FROM customers;

\echo ''

-- Exemple 2: Sélectionner des colonnes spécifiques
\echo '2️⃣ Sélectionner nom et email des clients:'
SELECT first_name, last_name, email FROM customers;

\echo ''

-- Exemple 3: SELECT avec WHERE (filtrage)
\echo '3️⃣ Clients dont le nom commence par M:'
SELECT * FROM customers WHERE last_name LIKE 'M%';

\echo ''

-- Exemple 4: SELECT avec opérateurs de comparaison
\echo '4️⃣ Produits dont le prix est supérieur à 50€:'
SELECT name, price, category FROM products WHERE price > 50;

\echo ''

-- Exemple 5: SELECT avec AND, OR
\echo '5️⃣ Produits Informatique de moins de 100€:'
SELECT name, price, category 
FROM products 
WHERE category = 'Informatique' AND price < 100;

\echo ''

-- Exemple 6: SELECT avec IN
\echo '6️⃣ Commandes avec statut PENDING ou CANCELLED:'
SELECT * FROM orders WHERE status IN ('PENDING', 'CANCELLED');

\echo ''


-- PARTIE 2: AGRÉGATIONS
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 2: FONCTIONS D AGRÉGATION'
\echo '============================================================'
\echo ''

-- Exemple 7: COUNT (compter)
\echo '7️⃣ Nombre total de clients:'
SELECT COUNT(*) AS total_clients FROM customers;

\echo ''

-- Exemple 8: SUM (somme)
\echo '8️⃣ Chiffre d affaires total:'
SELECT SUM(total_amount) AS ca_total FROM orders WHERE status = 'COMPLETED';

\echo ''

-- Exemple 9: AVG (moyenne)
\echo '9️⃣ Montant moyen des commandes:'
SELECT AVG(total_amount) AS montant_moyen FROM orders;

\echo ''

-- Exemple 10: MIN et MAX
\echo '🔟 Prix minimum et maximum des produits:'
SELECT 
    MIN(price) AS prix_min,
    MAX(price) AS prix_max
FROM products;

\echo ''


-- PARTIE 3: GROUP BY et HAVING
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 3: GROUP BY et HAVING'
\echo '============================================================'
\echo ''

-- Exemple 11: GROUP BY (regroupement)
\echo '1️⃣1️⃣ Nombre de produits par catégorie:'
SELECT 
    category,
    COUNT(*) AS nb_produits,
    AVG(price) AS prix_moyen
FROM products
GROUP BY category;

\echo ''

-- Exemple 12: GROUP BY avec ORDER BY
\echo '1️⃣2️⃣ Nombre de commandes par statut (trié):'
SELECT 
    status,
    COUNT(*) AS nb_commandes,
    SUM(total_amount) AS total
FROM orders
GROUP BY status
ORDER BY nb_commandes DESC;

\echo ''

-- Exemple 13: HAVING (filtre sur agrégations)
\echo '1️⃣3️⃣ Catégories avec prix moyen > 50€:'
SELECT 
    category,
    COUNT(*) AS nb_produits,
    AVG(price) AS prix_moyen
FROM products
GROUP BY category
HAVING AVG(price) > 50;

\echo ''


-- PARTIE 4: JOINTURES (JOIN)
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 4: JOINTURES (JOIN)'
\echo '============================================================'
\echo ''

-- Exemple 14: INNER JOIN (jointure interne)
\echo '1️⃣4️⃣ Commandes avec informations clients (INNER JOIN):'
SELECT 
    o.order_id,
    c.first_name,
    c.last_name,
    o.order_date,
    o.total_amount,
    o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;

\echo ''

-- Exemple 15: LEFT JOIN (jointure gauche)
\echo '1️⃣5️⃣ Tous les clients avec leurs commandes (LEFT JOIN):'
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS nb_commandes,
    COALESCE(SUM(o.total_amount), 0) AS total_depense
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_depense DESC;

\echo ''

-- Exemple 16: Jointure multiple
\echo '1️⃣6️⃣ Vue complète: Clients, Commandes (jointure simulée):'
-- Note: Normalement on aurait une table order_items pour lier orders et products
SELECT 
    c.first_name || ' ' || c.last_name AS client,
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'COMPLETED'
ORDER BY o.order_date DESC;

\echo ''


-- PARTIE 5: SOUS-REQUÊTES
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 5: SOUS-REQUÊTES'
\echo '============================================================'
\echo ''

-- Exemple 17: Sous-requête dans WHERE
\echo '1️⃣7️⃣ Clients ayant passé au moins une commande:'
SELECT first_name, last_name, email
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id FROM orders
);

\echo ''

-- Exemple 18: Sous-requête dans SELECT
\echo '1️⃣8️⃣ Clients avec nombre de commandes (sous-requête scalaire):'
SELECT 
    first_name,
    last_name,
    (SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id) AS nb_commandes
FROM customers c;

\echo ''


-- PARTIE 6: CTE (Common Table Expression) - WITH
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 6: CTE (WITH) - Requêtes nommées temporaires'
\echo '============================================================'
\echo ''

-- Exemple 19: CTE simple
\echo '1️⃣9️⃣ CTE pour calculer les meilleurs clients:'
WITH top_customers AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY customer_id
    HAVING SUM(total_amount) > 100
)
SELECT 
    c.first_name,
    c.last_name,
    tc.total_spent
FROM top_customers tc
JOIN customers c ON tc.customer_id = c.customer_id
ORDER BY tc.total_spent DESC;

\echo ''

-- Exemple 20: CTE multiple
\echo '2️⃣0️⃣ CTE multiples pour statistiques complexes:'
WITH 
    customer_stats AS (
        SELECT 
            customer_id,
            COUNT(*) AS nb_commandes,
            SUM(total_amount) AS total_depense
        FROM orders
        GROUP BY customer_id
    ),
    avg_stats AS (
        SELECT AVG(total_depense) AS avg_depense
        FROM customer_stats
    )
SELECT 
    c.first_name || ' ' || c.last_name AS client,
    cs.nb_commandes,
    cs.total_depense,
    CASE 
        WHEN cs.total_depense > avg_stats.avg_depense THEN 'Au-dessus de la moyenne'
        ELSE 'En-dessous de la moyenne'
    END AS categorie
FROM customer_stats cs
JOIN customers c ON cs.customer_id = c.customer_id
CROSS JOIN avg_stats
ORDER BY cs.total_depense DESC;

\echo ''


-- PARTIE 7: FONCTIONS FENÊTRES (Window Functions)
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 7: FONCTIONS FENÊTRES (Window Functions)'
\echo '============================================================'
\echo ''

-- Exemple 21: ROW_NUMBER() - Numérotation
\echo '2️⃣1️⃣ Numérotation des commandes par client:'
SELECT 
    customer_id,
    order_id,
    order_date,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_number
FROM orders
ORDER BY customer_id, order_date;

\echo ''

-- Exemple 22: RANK() et DENSE_RANK()
\echo '2️⃣2️⃣ Classement des produits par prix:'
SELECT 
    name,
    price,
    RANK() OVER (ORDER BY price DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank
FROM products;

\echo ''

-- Exemple 23: SUM() OVER - Cumul
\echo '2️⃣3️⃣ Cumul des ventes par date:'
SELECT 
    order_date::DATE AS date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY order_date) AS cumul_ventes
FROM orders
WHERE status = 'COMPLETED'
ORDER BY order_date;

\echo ''


-- PARTIE 8: EXPRESSIONS CONDITIONNELLES
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 8: CASE WHEN (Conditions)'
\echo '============================================================'
\echo ''

-- Exemple 24: CASE WHEN
\echo '2️⃣4️⃣ Catégorisation des produits par prix:'
SELECT 
    name,
    price,
    CASE 
        WHEN price < 50 THEN 'Économique'
        WHEN price BETWEEN 50 AND 200 THEN 'Moyen'
        ELSE 'Premium'
    END AS gamme
FROM products
ORDER BY price;

\echo ''


-- PARTIE 9: ORDER BY et LIMIT
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 9: TRI et LIMITATION'
\echo '============================================================'
\echo ''

-- Exemple 25: ORDER BY (tri)
\echo '2️⃣5️⃣ Produits triés par prix décroissant:'
SELECT name, price FROM products ORDER BY price DESC;

\echo ''

-- Exemple 26: LIMIT et OFFSET (pagination)
\echo '2️⃣6️⃣ Top 3 des produits les plus chers:'
SELECT name, price FROM products ORDER BY price DESC LIMIT 3;

\echo ''

-- Exemple 27: OFFSET (sauter des lignes)
\echo '2️⃣7️⃣ Produits 4 à 6 (pagination):'
SELECT name, price FROM products ORDER BY price DESC LIMIT 3 OFFSET 3;

\echo ''


-- PARTIE 10: DISTINCT
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 10: DISTINCT (Valeurs uniques)'
\echo '============================================================'
\echo ''

-- Exemple 28: DISTINCT
\echo '2️⃣8️⃣ Liste des catégories de produits (sans doublons):'
SELECT DISTINCT category FROM products ORDER BY category;

\echo ''


-- ============================================================================
-- RÉCAPITULATIF
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF DES REQUÊTES SELECT'
\echo '============================================================'
\echo ''
\echo '📌 SELECT de base:'
\echo '  ✓ SELECT *, colonnes spécifiques'
\echo '  ✓ WHERE (filtres), AND, OR, IN, LIKE'
\echo ''
\echo '📌 Agrégations:'
\echo '  ✓ COUNT, SUM, AVG, MIN, MAX'
\echo '  ✓ GROUP BY (regroupement)'
\echo '  ✓ HAVING (filtre sur agrégations)'
\echo ''
\echo '📌 Jointures:'
\echo '  ✓ INNER JOIN (intersection)'
\echo '  ✓ LEFT JOIN (toutes les lignes de gauche)'
\echo '  ✓ Jointures multiples'
\echo ''
\echo '📌 Avancé:'
\echo '  ✓ Sous-requêtes (IN, EXISTS, scalaires)'
\echo '  ✓ CTE (WITH) - requêtes nommées'
\echo '  ✓ Fonctions fenêtres (ROW_NUMBER, RANK, SUM OVER)'
\echo '  ✓ CASE WHEN (conditions)'
\echo ''
\echo '📌 Autres:'
\echo '  ✓ ORDER BY (tri), LIMIT (limitation), OFFSET (pagination)'
\echo '  ✓ DISTINCT (valeurs uniques)'
\echo '============================================================'
