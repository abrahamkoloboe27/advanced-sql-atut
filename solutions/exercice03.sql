-- ============================================================================
-- SOLUTION EXERCICE 3 : UPDATE et DELETE sécurisés (DML)
-- ============================================================================

\echo '========================================';
\echo 'SOLUTION EXERCICE 3';
\echo '========================================';
\echo '';

-- ============================================================================
-- 3.1 - Augmenter les prix de 5%
-- ============================================================================

\echo '3.1 - Augmentation de 5% pour produits Informatique:';
\echo '';

-- Afficher avant
\echo 'Prix AVANT augmentation:';
SELECT product_id, name, price, category 
FROM products 
WHERE category = 'Informatique';

\echo '';

-- Mise à jour avec RETURNING
UPDATE products 
SET price = price * 1.05
WHERE category = 'Informatique'
RETURNING product_id, name, price AS nouveau_prix, category;

\echo '';
\echo '✅ Prix augmentés de 5%!';
\echo '';

-- ============================================================================
-- 3.2 - Annuler les commandes en attente depuis plus de 30 jours
-- ============================================================================

\echo '3.2 - Annulation des commandes PENDING > 30 jours:';
\echo '';

-- Créer une commande de test (ancienne)
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES (1, '2024-01-01', 50.00, 'PENDING')
RETURNING order_id, order_date, status;

\echo '';
\echo 'Commande de test créée avec date ancienne.';
\echo '';

-- Afficher les commandes PENDING avant mise à jour
\echo 'Commandes PENDING de plus de 30 jours:';
SELECT 
    order_id, 
    order_date, 
    status,
    CURRENT_DATE - order_date::DATE AS jours_depuis_commande
FROM orders
WHERE status = 'PENDING' 
  AND order_date < CURRENT_DATE - INTERVAL '30 days';

\echo '';

-- Mise à jour
UPDATE orders
SET status = 'CANCELLED'
WHERE status = 'PENDING' 
  AND order_date < CURRENT_DATE - INTERVAL '30 days'
RETURNING order_id, order_date, status, total_amount;

\echo '';
\echo '✅ Commandes anciennes annulées!';
\echo '';

-- ============================================================================
-- 3.3 - Supprimer les produits en rupture de stock jamais commandés
-- ============================================================================

\echo '3.3 - Suppression des produits en rupture jamais commandés:';
\echo '';

-- D'abord, créer un produit de test
INSERT INTO products (name, price, category, stock)
VALUES ('Produit Obsolète Test', 9.99, 'General', 0)
RETURNING product_id, name, stock;

\echo '';

-- Vérifier avec SELECT avant de supprimer
\echo 'Produits en rupture (stock = 0):';
SELECT p.product_id, p.name, p.stock
FROM products p
WHERE p.stock = 0;

\echo '';

-- Si order_items existe, supprimer uniquement ceux jamais commandés
DO $$
BEGIN
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'order_items') THEN
        -- Avec order_items
        DELETE FROM products p
        WHERE p.stock = 0
          AND NOT EXISTS (
              SELECT 1 FROM order_items oi 
              WHERE oi.product_id = p.product_id
          );
        RAISE NOTICE 'Produits en rupture jamais commandés supprimés (avec order_items)';
    ELSE
        -- Sans order_items, supprimer tous les produits stock = 0 de catégorie General
        DELETE FROM products
        WHERE stock = 0 AND category = 'General';
        RAISE NOTICE 'Produits en rupture de stock (catégorie General) supprimés';
    END IF;
END $$;

\echo '';

-- Vérifier après suppression
\echo 'Produits en rupture après suppression:';
SELECT product_id, name, stock
FROM products
WHERE stock = 0;

\echo '';
\echo '✅ Produits obsolètes supprimés!';
\echo '';

-- ============================================================================
-- Restauration des données (optionnel)
-- ============================================================================

\echo '♻️  Restauration des prix d origine (annulation +5%):';

UPDATE products 
SET price = price / 1.05
WHERE category = 'Informatique';

\echo '✅ Prix restaurés!';
\echo '';
\echo '========================================';
