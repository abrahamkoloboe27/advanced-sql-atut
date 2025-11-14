-- ============================================================================
-- SOLUTION EXERCICE 2 : Requêtes SELECT avec jointures (DML)
-- ============================================================================

\echo '========================================';
\echo 'SOLUTION EXERCICE 2';
\echo '========================================';
\echo '';

-- ============================================================================
-- 2.1 - Liste des commandes avec nom du client
-- ============================================================================

\echo '2.1 - Commandes avec nom du client:';
\echo '';

SELECT 
    c.first_name || ' ' || c.last_name AS client,
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC;

\echo '';

-- ============================================================================
-- 2.2 - Clients ayant passé plus d'une commande
-- ============================================================================

\echo '2.2 - Clients avec plusieurs commandes:';
\echo '';

SELECT 
    c.first_name || ' ' || c.last_name AS client,
    COUNT(o.order_id) AS nombre_commandes
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > 1
ORDER BY nombre_commandes DESC;

\echo '';

-- ============================================================================
-- 2.3 - Top 3 des clients par montant dépensé
-- ============================================================================

\echo '2.3 - Top 3 des meilleurs clients:';
\echo '';

SELECT 
    c.first_name || ' ' || c.last_name AS client,
    SUM(o.total_amount) AS total_depense
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'COMPLETED'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_depense DESC
LIMIT 3;

\echo '';

-- ============================================================================
-- 2.4 - Produits jamais commandés (si order_items existe)
-- ============================================================================

\echo '2.4 - Produits jamais commandés:';
\echo '';

-- Vérifier si order_items existe
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'order_items') THEN
        RAISE NOTICE 'Table order_items trouvée, exécution de la requête...';
    ELSE
        RAISE NOTICE 'Table order_items non trouvée. Créez-la avec l exercice 1.';
    END IF;
END $$;

-- Requête principale (si order_items existe)
SELECT 
    p.name,
    p.category,
    p.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL
ORDER BY p.category, p.name;

\echo '';

-- Alternative sans order_items (basée sur un lien fictif)
\echo 'Alternative : Produits de catégorie "Audio" (exemple):';
SELECT name, category, price 
FROM products 
WHERE category = 'Audio'
ORDER BY price DESC;

\echo '';
\echo '========================================';
