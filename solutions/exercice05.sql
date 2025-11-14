-- ============================================================================
-- SOLUTION EXERCICE 5 : Optimisation avec index (Administration)
-- ============================================================================

\echo '========================================';
\echo 'SOLUTION EXERCICE 5';
\echo '========================================';
\echo '';

-- ============================================================================
-- 5.1 - Mesurer la performance SANS index
-- ============================================================================

\echo '5.1 - Performance SANS index sur category:';
\echo '';

-- Supprimer tout index existant sur category (au cas où)
DROP INDEX IF EXISTS idx_products_category;

\echo 'Requête : SELECT * FROM products WHERE category = ''Informatique'';';
\echo '';

EXPLAIN ANALYZE
SELECT * FROM products WHERE category = 'Informatique';

\echo '';
\echo '📊 Observations:';
\echo '  - Type de scan: Seq Scan (parcours complet)';
\echo '  - Note le "Execution Time" ci-dessus';
\echo '';

-- ============================================================================
-- 5.2 - Créer un index approprié
-- ============================================================================

\echo '5.2 - Création d un index sur category:';
\echo '';

CREATE INDEX idx_products_category ON products(category);

\echo '✅ Index idx_products_category créé!';
\echo '';

-- ============================================================================
-- 5.3 - Re-mesurer la performance
-- ============================================================================

\echo '5.3 - Performance AVEC index sur category:';
\echo '';

EXPLAIN ANALYZE
SELECT * FROM products WHERE category = 'Informatique';

\echo '';
\echo '📊 Observations:';
\echo '  - Type de scan: Index Scan (ou Bitmap Index Scan)';
\echo '  - Comparez "Execution Time" avec le résultat précédent';
\echo '  - L index améliore les performances!';
\echo '';

-- ============================================================================
-- 5.4 - Index composé (category, price)
-- ============================================================================

\echo '5.4 - Index composé sur (category, price):';
\echo '';

-- Créer index composé
CREATE INDEX idx_products_category_price ON products(category, price);

\echo '✅ Index idx_products_category_price créé!';
\echo '';

-- Tester la requête
\echo 'Requête : SELECT * FROM products WHERE category = ''Informatique'' ORDER BY price DESC;';
\echo '';

EXPLAIN ANALYZE
SELECT * FROM products 
WHERE category = 'Informatique' 
ORDER BY price DESC;

\echo '';
\echo '📊 Observations:';
\echo '  - Index utilisé: idx_products_category_price';
\echo '  - L index composé optimise à la fois le WHERE et le ORDER BY';
\echo '  - Pas de "Sort" séparé car l index est déjà trié';
\echo '';

-- ============================================================================
-- Question : Quel index est utilisé ? Pourquoi ?
-- ============================================================================

\echo '💡 Réponse à la question:';
\echo '  PostgreSQL utilise idx_products_category_price car:';
\echo '  1. Cet index couvre la colonne filtrée (category)';
\echo '  2. Il contient aussi la colonne de tri (price)';
\echo '  3. Index composé (category, price) permet un tri sans "Sort" séparé';
\echo '  4. Plus efficace que idx_products_category seul';
\echo '';

-- ============================================================================
-- Comparaison détaillée des différents scénarios
-- ============================================================================

\echo '========================================';
\echo 'COMPARAISON COMPLÈTE';
\echo '========================================';
\echo '';

-- Créer une table de test avec plus de données
CREATE TEMP TABLE products_large AS
SELECT 
    generate_series(1, 1000) AS product_id,
    'Product ' || generate_series(1, 1000) AS name,
    (random() * 1000)::NUMERIC(10, 2) AS price,
    CASE (random() * 4)::INTEGER
        WHEN 0 THEN 'Informatique'
        WHEN 1 THEN 'Audio'
        WHEN 2 THEN 'Video'
        ELSE 'General'
    END AS category,
    (random() * 100)::INTEGER AS stock;

\echo '📊 Table products_large créée (1000 lignes)';
\echo '';

-- Test 1: Sans index
\echo '⏱️  Test 1: SANS index';
EXPLAIN ANALYZE
SELECT * FROM products_large WHERE category = 'Informatique';

\echo '';

-- Test 2: Avec index simple
CREATE INDEX idx_large_category ON products_large(category);
\echo '⏱️  Test 2: AVEC index simple sur category';
EXPLAIN ANALYZE
SELECT * FROM products_large WHERE category = 'Informatique';

\echo '';

-- Test 3: Avec tri
\echo '⏱️  Test 3: AVEC index simple + ORDER BY (nécessite Sort)';
EXPLAIN ANALYZE
SELECT * FROM products_large WHERE category = 'Informatique' ORDER BY price DESC;

\echo '';

-- Test 4: Avec index composé
CREATE INDEX idx_large_category_price ON products_large(category, price);
\echo '⏱️  Test 4: AVEC index composé (category, price) + ORDER BY';
EXPLAIN ANALYZE
SELECT * FROM products_large WHERE category = 'Informatique' ORDER BY price DESC;

\echo '';

-- ============================================================================
-- Visualisation des index
-- ============================================================================

\echo '========================================';
\echo 'INDEX CRÉÉS';
\echo '========================================';
\echo '';

-- Lister tous les index sur products
\echo 'Index sur la table products:';
SELECT 
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'products'
ORDER BY indexname;

\echo '';

-- Statistiques d'utilisation (si pg_stat_statements est activé)
\echo 'Tailles des index:';
SELECT 
    indexrelname AS index_name,
    pg_size_pretty(pg_relation_size(indexrelid)) AS index_size
FROM pg_stat_user_indexes
WHERE schemaname = 'public' AND relname = 'products'
ORDER BY pg_relation_size(indexrelid) DESC;

\echo '';

-- ============================================================================
-- Recommandations
-- ============================================================================

\echo '========================================';
\echo 'RECOMMANDATIONS';
\echo '========================================';
\echo '';
\echo '✅ Quand créer un index:';
\echo '  • Colonnes fréquemment utilisées dans WHERE';
\echo '  • Colonnes de jointure (FK)';
\echo '  • Colonnes utilisées dans ORDER BY';
\echo '  • Tables avec > 1000 lignes';
\echo '';
\echo '⚠️  Quand NE PAS créer d index:';
\echo '  • Petites tables (< 100 lignes)';
\echo '  • Colonnes rarement filtrées';
\echo '  • Colonnes avec peu de valeurs distinctes (sauf index partiel)';
\echo '  • Tables avec beaucoup d INSERT/UPDATE (overhead)';
\echo '';
\echo '💡 Types d index PostgreSQL:';
\echo '  • B-tree (défaut): La plupart des cas';
\echo '  • Hash: Égalité stricte uniquement';
\echo '  • GIN: Recherche full-text, JSONB, arrays';
\echo '  • GiST: Données géométriques, full-text';
\echo '  • BRIN: Très grandes tables triées';
\echo '';
\echo '🔧 Maintenance:';
\echo '  • ANALYZE après modifications massives';
\echo '  • REINDEX si index fragmenté';
\echo '  • Surveiller la taille des index';
\echo '  • Supprimer les index inutilisés';
\echo '';
\echo '========================================';

-- ============================================================================
-- Nettoyage (optionnel)
-- ============================================================================

-- Garder les index pour utilisation ultérieure
-- Commenter les lignes ci-dessous si vous voulez les conserver

-- DROP INDEX IF EXISTS idx_products_category;
-- DROP INDEX IF EXISTS idx_products_category_price;

\echo '';
\echo '✅ Exercice 5 terminé!';
\echo '';
