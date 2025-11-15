-- ============================================================================
-- Script: indexes_views.sql
-- Description: Exemples de création et suppression d'INDEX et de VIEWS
-- ============================================================================

-- ============================================================================
-- PARTIE 1: INDEX - Optimisation des requêtes
-- ============================================================================
\c shop_db

\echo '============================================================'
\echo 'PARTIE 1: INDEX - Optimisation des performances'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: CREATE INDEX
-- Description: Crée un index pour accélérer les recherches sur une/des colonnes
-- Types d'index: B-tree (défaut), Hash, GIN, GiST, BRIN
-- Utilisé pour: WHERE, JOIN, ORDER BY
-- ============================================================================

-- Exemple 1: Index simple sur une colonne
-- ============================================================================
\echo '1️⃣ Création d un index sur customers.email...'

CREATE INDEX idx_customers_email ON customers(email);

COMMENT ON INDEX idx_customers_email IS 'Index pour recherches rapides par email';

\echo '✅ Index idx_customers_email créé!'
\echo '   Utilité: Accélère les requêtes WHERE email = ...'
\echo ''


-- Exemple 2: Index sur plusieurs colonnes (index composé)
-- ============================================================================
\echo '2️⃣ Création d un index composé sur customers(last_name, first_name)...'

CREATE INDEX idx_customers_name ON customers(last_name, first_name);

COMMENT ON INDEX idx_customers_name IS 'Index pour tri et recherche par nom complet';

\echo '✅ Index idx_customers_name créé!'
\echo '   Utilité: Accélère ORDER BY last_name, first_name'
\echo ''


-- Exemple 3: Index unique (impose l'unicité)
-- ============================================================================
\echo '3️⃣ Création d un index UNIQUE sur products.name...'

CREATE UNIQUE INDEX idx_products_name_unique ON products(name);

COMMENT ON INDEX idx_products_name_unique IS 'Garantit l unicité des noms de produits';

\echo '✅ Index unique idx_products_name_unique créé!'
\echo '   Utilité: Empêche les doublons de noms de produits'
\echo ''


-- Exemple 4: Index partiel (filtre WHERE)
-- ============================================================================
\echo '4️⃣ Création d un index partiel sur orders en cours...'

CREATE INDEX idx_orders_pending ON orders(order_date)
WHERE status = 'PENDING';

COMMENT ON INDEX idx_orders_pending IS 'Index uniquement sur les commandes en attente';

\echo '✅ Index partiel idx_orders_pending créé!'
\echo '   Utilité: Optimise les requêtes sur commandes PENDING uniquement'
\echo ''


-- Exemple 5: Index sur expression (index fonctionnel)
-- ============================================================================
\echo '5️⃣ Création d un index sur LOWER(email)...'

CREATE INDEX idx_customers_email_lower ON customers(LOWER(email));

COMMENT ON INDEX idx_customers_email_lower IS 'Index pour recherches insensibles à la casse';

\echo '✅ Index fonctionnel idx_customers_email_lower créé!'
\echo '   Utilité: Accélère WHERE LOWER(email) = lower(...)'
\echo ''


-- ============================================================================
-- Vérification des index créés
-- ============================================================================

\echo ''
\echo '📋 Liste des index créés:'
\di


-- ============================================================================
-- Mot-clé: DROP INDEX
-- Description: Supprime un index existant
-- ============================================================================

\echo ''
\echo '============================================================'
\echo 'Suppression d index'
\echo '============================================================'
\echo ''

\echo '6️⃣ Suppression de l index idx_customers_email_lower...'

DROP INDEX IF EXISTS idx_customers_email_lower;

\echo '✅ Index idx_customers_email_lower supprimé!'
\echo ''


-- ============================================================================
-- PARTIE 2: VIEWS - Vues (requêtes nommées réutilisables)
-- ============================================================================

\echo ''
\echo '============================================================'
\echo 'PARTIE 2: VIEWS - Vues SQL'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: CREATE VIEW
-- Description: Crée une vue (requête stockée et nommée)
-- Avantages: Simplifie les requêtes complexes, encapsule la logique, sécurité
-- ============================================================================

-- Exemple 1: Vue simple - Liste des clients avec leurs commandes
-- ============================================================================
\echo '1️⃣ Création de la vue customer_orders_summary...'

CREATE VIEW customer_orders_summary AS
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

COMMENT ON VIEW customer_orders_summary IS 
'Vue récapitulative des commandes par client';

\echo '✅ Vue customer_orders_summary créée!'
\echo '   Utilisation: SELECT * FROM customer_orders_summary;'
\echo ''


-- Exemple 2: Vue avec filtres - Produits en rupture de stock
-- ============================================================================
\echo '2️⃣ Création de la vue out_of_stock_products...'

CREATE VIEW out_of_stock_products AS
SELECT 
    product_id,
    name,
    category,
    price
FROM products
WHERE stock = 0;

COMMENT ON VIEW out_of_stock_products IS 
'Produits actuellement en rupture de stock';

\echo '✅ Vue out_of_stock_products créée!'
\echo ''


-- Exemple 3: Vue matérialisée (stocke les résultats physiquement)
-- ============================================================================
\echo '3️⃣ Création de la vue matérialisée monthly_sales...'

CREATE MATERIALIZED VIEW monthly_sales AS
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status = 'COMPLETED'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month DESC;

COMMENT ON MATERIALIZED VIEW monthly_sales IS 
'Statistiques de ventes par mois (vue matérialisée)';

\echo '✅ Vue matérialisée monthly_sales créée!'
\echo '   💡 Rafraîchir avec: REFRESH MATERIALIZED VIEW monthly_sales;'
\echo ''


-- Exemple 4: Vue dans le schéma analytics
-- ============================================================================
\echo '4️⃣ Création de la vue analytics.product_performance...'
CREATE SCHEMA analytics
CREATE VIEW analytics.product_performance AS
SELECT 
    p.product_id,
    p.name,
    p.category,
    p.price,
    p.stock,
    COUNT(o.order_id) AS times_ordered,
    COALESCE(SUM(o.total_amount), 0) AS revenue_generated
FROM products p
LEFT JOIN orders o ON p.product_id = o.customer_id  -- Note: Jointure fictive pour démo
GROUP BY p.product_id, p.name, p.category, p.price, p.stock;

COMMENT ON VIEW analytics.product_performance IS 
'Analyse des performances par produit';

\echo '✅ Vue analytics.product_performance créée!'
\echo ''


-- ============================================================================
-- Utilisation des vues
-- ============================================================================

\echo ''
\echo '📋 Exemple d utilisation des vues:'
\echo ''

-- Sélectionner depuis une vue (comme une table normale)
SELECT * FROM customer_orders_summary LIMIT 3;

\echo ''


-- ============================================================================
-- Mot-clé: DROP VIEW
-- Description: Supprime une vue existante
-- ============================================================================

\echo '============================================================'
\echo 'Suppression de vues'
\echo '============================================================'
\echo ''

\echo '5️⃣ Suppression de la vue out_of_stock_products...'

DROP VIEW IF EXISTS out_of_stock_products;

\echo '✅ Vue out_of_stock_products supprimée!'
\echo ''


-- ============================================================================
-- Rafraîchir une vue matérialisée
-- ============================================================================

\echo '6️⃣ Rafraîchissement de la vue matérialisée monthly_sales...'

REFRESH MATERIALIZED VIEW monthly_sales;

\echo '✅ Vue matérialisée monthly_sales rafraîchie!'
\echo ''


-- ============================================================================
-- ALTER VIEW (Remplacer une vue)
-- ============================================================================

\echo '7️⃣ Modification de la vue customer_orders_summary...'

CREATE OR REPLACE VIEW customer_orders_summary AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

\echo '✅ Vue customer_orders_summary modifiée (ajout de full_name)!'
\echo ''


-- ============================================================================
-- Lister toutes les vues
-- ============================================================================

\echo ''
\echo '📋 Liste de toutes les vues:'
\dv

\echo ''
\echo '📋 Liste des vues matérialisées:'
\dm

\echo ''


-- ============================================================================
-- RÉCAPITULATIF
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF INDEX & VIEWS'
\echo '============================================================'
\echo ''
\echo '📌 INDEX:'
\echo '  ✓ CREATE INDEX: Accélère les requêtes (WHERE, JOIN, ORDER BY)'
\echo '  ✓ Index composé: Sur plusieurs colonnes'
\echo '  ✓ Index unique: Garantit l unicité'
\echo '  ✓ Index partiel: Avec clause WHERE'
\echo '  ✓ DROP INDEX: Supprime un index'
\echo ''
\echo '📌 VIEWS:'
\echo '  ✓ CREATE VIEW: Requête nommée réutilisable'
\echo '  ✓ Vue matérialisée: Stocke les résultats (performances++)'
\echo '  ✓ CREATE OR REPLACE VIEW: Modifier une vue'
\echo '  ✓ REFRESH MATERIALIZED VIEW: Mettre à jour les données'
\echo '  ✓ DROP VIEW: Supprime une vue'
\echo ''
\echo '⚠️  Bonnes pratiques:'
\echo '  - Créer des index sur colonnes fréquemment filtrées/triées'
\echo '  - Ne pas sur-indexer (ralentit INSERT/UPDATE/DELETE)'
\echo '  - Utiliser EXPLAIN ANALYZE pour vérifier l utilisation des index'
\echo '  - Rafraîchir régulièrement les vues matérialisées'
\echo '============================================================'
