-- ============================================================================
-- Script: explain_analyze_examples.sql
-- Description: Exemples EXPLAIN et EXPLAIN ANALYZE pour optimisation
-- ============================================================================

\echo '============================================================'
\echo 'EXPLAIN et EXPLAIN ANALYZE - Analyse de performance'
\echo '============================================================'
\echo ''

-- ============================================================================
-- EXPLAIN et EXPLAIN ANALYZE
-- Description: Outils d'analyse des plans d'exécution des requêtes
-- EXPLAIN: Montre le plan d'exécution prévu
-- EXPLAIN ANALYZE: Exécute réellement et montre les temps réels
-- ============================================================================

\echo '💡 Outils d analyse de performance:'
\echo '  • EXPLAIN: Plan d exécution prévu (sans exécution)'
\echo '  • EXPLAIN ANALYZE: Exécution réelle + statistiques'
\echo '  • EXPLAIN (BUFFERS, ANALYZE): Ajoute infos sur buffers'
\echo ''


-- ============================================================================
-- PARTIE 1: EXPLAIN de base
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 1: EXPLAIN - Plan d exécution'
\echo '============================================================'
\echo ''

-- Exemple 1: EXPLAIN simple
-- ============================================================================
\echo '1️⃣ EXPLAIN sur une requête simple:'
\echo ''

EXPLAIN
SELECT * FROM customers WHERE customer_id = 1;

\echo ''
\echo 'Lecture du plan:'
\echo '  • Seq Scan: Parcours séquentiel (lit toute la table)'
\echo '  • Index Scan: Utilise un index (plus rapide)'
\echo '  • cost=X..Y: Estimation du coût (unités arbitraires)'
\echo '  • rows=N: Nombre de lignes estimées'
\echo ''


-- Exemple 2: EXPLAIN avec jointure
-- ============================================================================
\echo '2️⃣ EXPLAIN sur une jointure:'
\echo ''

EXPLAIN
SELECT 
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id = 1;

\echo ''
\echo 'Types de jointures:'
\echo '  • Nested Loop: Boucle imbriquée (petites tables)'
\echo '  • Hash Join: Jointure par hash (grosses tables)'
\echo '  • Merge Join: Jointure par fusion (données triées)'
\echo ''


-- ============================================================================
-- PARTIE 2: EXPLAIN ANALYZE - Exécution réelle
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 2: EXPLAIN ANALYZE - Temps réels'
\echo '============================================================'
\echo ''

-- Exemple 3: EXPLAIN ANALYZE simple
-- ============================================================================
\echo '3️⃣ EXPLAIN ANALYZE (exécution réelle):'
\echo ''

EXPLAIN ANALYZE
SELECT * FROM customers WHERE last_name = 'Dupont';

\echo ''
\echo 'Informations supplémentaires:'
\echo '  • actual time=X..Y: Temps réel en millisecondes'
\echo '  • rows=N: Nombre réel de lignes retournées'
\echo '  • loops=N: Nombre d itérations'
\echo '  • Planning Time: Temps de planification'
\echo '  • Execution Time: Temps d exécution total'
\echo ''


-- Exemple 4: Comparaison SANS index
-- ============================================================================
\echo '4️⃣ Performance SANS index sur email:'
\echo ''

EXPLAIN ANALYZE
SELECT * FROM customers WHERE email = 'marie.martin@email.fr';

\echo ''
\echo '⚠️  Seq Scan utilisé (parcours complet de la table)'
\echo ''


-- Exemple 5: Création d'index et comparaison
-- ============================================================================
\echo '5️⃣ Création d un index et nouvelle mesure:'
\echo ''

-- Créer un index
CREATE INDEX IF NOT EXISTS idx_customers_email_test ON customers(email);

\echo 'Index créé sur customers.email'
\echo ''

EXPLAIN ANALYZE
SELECT * FROM customers WHERE email = 'marie.martin@email.fr';

\echo ''
\echo '✅ Index Scan utilisé (beaucoup plus rapide!)'
\echo ''

-- Supprimer l'index
DROP INDEX IF EXISTS idx_customers_email_test;


-- ============================================================================
-- PARTIE 3: EXPLAIN avec options
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 3: EXPLAIN avec options avancées'
\echo '============================================================'
\echo ''

-- Exemple 6: EXPLAIN (ANALYZE, BUFFERS)
-- ============================================================================
\echo '6️⃣ EXPLAIN avec informations sur les buffers:'
\echo ''

EXPLAIN (ANALYZE, BUFFERS)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS nb_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

\echo ''
\echo 'Buffers:'
\echo '  • shared hit: Blocs trouvés en cache'
\echo '  • shared read: Blocs lus depuis le disque'
\echo '  • Plus de "hit", meilleure la performance!'
\echo ''


-- Exemple 7: EXPLAIN (ANALYZE, VERBOSE)
-- ============================================================================
\echo '7️⃣ EXPLAIN VERBOSE (détails complets):'
\echo ''

EXPLAIN (ANALYZE, VERBOSE)
SELECT name, price FROM products WHERE category = 'Informatique' ORDER BY price DESC LIMIT 3;

\echo ''


-- Exemple 8: Format JSON
-- ============================================================================
\echo '8️⃣ EXPLAIN au format JSON (pour outils):'
\echo ''

EXPLAIN (ANALYZE, FORMAT JSON)
SELECT * FROM orders WHERE status = 'COMPLETED';

\echo ''


-- ============================================================================
-- PARTIE 4: Optimisation avec index
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 4: Impact des index sur les performances'
\echo '============================================================'
\echo ''

-- Créer une table de test avec plus de données
CREATE TEMP TABLE large_test AS
SELECT 
    generate_series(1, 10000) AS id,
    'User ' || generate_series(1, 10000) AS username,
    MD5(random()::text) AS email,
    random() * 1000 AS score
FROM generate_series(1, 10000);

\echo '📊 Table de test créée avec 10 000 lignes'
\echo ''

-- Test 1: SANS index
\echo '⏱️  Test 1: Recherche SANS index'
EXPLAIN ANALYZE
SELECT * FROM large_test WHERE email LIKE 'a%';

\echo ''

-- Créer un index
CREATE INDEX idx_large_test_email ON large_test(email);

\echo '📌 Index créé sur email'
\echo ''

-- Test 2: AVEC index
\echo '⏱️  Test 2: Recherche AVEC index'
EXPLAIN ANALYZE
SELECT * FROM large_test WHERE email LIKE 'a%';

\echo ''
\echo '💡 Comparaison: L index améliore significativement les performances!'
\echo ''


-- ============================================================================
-- PARTIE 5: Analyse de requêtes complexes
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 5: Analyse de requêtes complexes'
\echo '============================================================'
\echo ''

-- Exemple 9: Sous-requête vs JOIN
-- ============================================================================
\echo '9️⃣ Comparaison: Sous-requête vs JOIN'
\echo ''

\echo 'Méthode 1: Sous-requête'
EXPLAIN ANALYZE
SELECT * FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders WHERE status = 'COMPLETED');

\echo ''

\echo 'Méthode 2: JOIN'
EXPLAIN ANALYZE
SELECT DISTINCT c.* FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'COMPLETED';

\echo ''


-- Exemple 10: Window functions
-- ============================================================================
\echo '🔟 Analyse de window functions:'
\echo ''

EXPLAIN ANALYZE
SELECT 
    customer_id,
    order_id,
    total_amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_rank
FROM orders;

\echo ''


-- ============================================================================
-- PARTIE 6: Statistiques de la base
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 6: Statistiques et maintenance'
\echo '============================================================'
\echo ''

-- Exemple 11: ANALYZE (mise à jour des statistiques)
-- ============================================================================
\echo '1️⃣1️⃣ ANALYZE - Mettre à jour les statistiques:'
\echo ''

-- Analyser une table
ANALYZE customers;

\echo '✅ Statistiques de customers mises à jour'
\echo ''

-- Analyser toute la base
ANALYZE;

\echo '✅ Statistiques de toutes les tables mises à jour'
\echo ''


-- Exemple 12: VACUUM ANALYZE
-- ============================================================================
\echo '1️⃣2️⃣ VACUUM ANALYZE (nettoyage + statistiques):'
\echo ''

VACUUM ANALYZE products;

\echo '✅ Table products nettoyée et statistiques mises à jour'
\echo ''


-- Exemple 13: Vérifier les statistiques
-- ============================================================================
\echo '1️⃣3️⃣ Statistiques d une table:'
\echo ''

SELECT
    schemaname,
    tablename,
    last_vacuum,
    last_autovacuum,
    last_analyze,
    last_autoanalyze,
    n_live_tup AS live_rows,
    n_dead_tup AS dead_rows
FROM pg_stat_user_tables
WHERE tablename = 'customers';

\echo ''


-- ============================================================================
-- PARTIE 7: Détection de problèmes de performance
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 7: Détection de problèmes courants'
\echo '============================================================'
\echo ''

\echo '🔍 Problèmes fréquents dans EXPLAIN ANALYZE:'
\echo ''

\echo '1. Seq Scan sur grande table'
\echo '   → Ajouter un index approprié'
\echo ''

\echo '2. Estimation vs réalité très différente (rows estimé != rows réel)'
\echo '   → Exécuter ANALYZE sur la table'
\echo ''

\echo '3. Nested Loop avec beaucoup de lignes'
\echo '   → Vérifier les index sur les clés de jointure'
\echo ''

\echo '4. Sort / Hash de grosses quantités'
\echo '   → Augmenter work_mem ou optimiser la requête'
\echo ''

\echo '5. Buffers shared read élevé'
\echo '   → Données non en cache, considérer augmenter shared_buffers'
\echo ''


-- ============================================================================
-- PARTIE 8: Outils de visualisation
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 8: Outils de visualisation'
\echo '============================================================'
\echo ''

\echo '🔧 Outils pour analyser les plans d exécution:'
\echo ''

\echo '1. pgAdmin'
\echo '   • Interface graphique avec visualisation du plan'
\echo '   • Très pratique pour comprendre les plans complexes'
\echo ''

\echo '2. explain.depesz.com'
\echo '   • Coller le résultat de EXPLAIN'
\echo '   • Visualisation colorée et interactive'
\echo ''

\echo '3. explain.dalibo.com'
\echo '   • Alternative française'
\echo '   • Analyse et suggestions d optimisation'
\echo ''

\echo '4. pev2 (Postgres Explain Visualizer 2)'
\echo '   • https://github.com/dalibo/pev2'
\echo '   • Outil open-source'
\echo ''


-- ============================================================================
-- RÉCAPITULATIF
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF - EXPLAIN & ANALYZE'
\echo '============================================================'
\echo ''
\echo '📌 Commandes principales:'
\echo '  ✓ EXPLAIN - Plan d exécution prévu (sans exécution)'
\echo '  ✓ EXPLAIN ANALYZE - Exécution réelle + temps'
\echo '  ✓ EXPLAIN (ANALYZE, BUFFERS) - Avec infos buffers'
\echo '  ✓ EXPLAIN (ANALYZE, VERBOSE) - Détails complets'
\echo ''
\echo '📌 Lecture du plan:'
\echo '  ✓ Seq Scan: Parcours séquentiel (lent sur grosses tables)'
\echo '  ✓ Index Scan: Utilise un index (rapide)'
\echo '  ✓ Hash Join / Nested Loop / Merge Join: Types de jointures'
\echo '  ✓ cost=X..Y: Coût estimé (relatif)'
\echo '  ✓ rows=N: Nombre de lignes (estimé ou réel)'
\echo '  ✓ actual time: Temps réel en ms'
\echo ''
\echo '📌 Optimisation:'
\echo '  ✓ Créer des index sur colonnes filtrées/jointures'
\echo '  ✓ Exécuter ANALYZE régulièrement'
\echo '  ✓ VACUUM pour nettoyage'
\echo '  ✓ Vérifier shared_buffers et work_mem'
\echo ''
\echo '⚠️  Bonnes pratiques:'
\echo '  • Toujours tester sur données réalistes'
\echo '  • Comparer avant/après optimisation'
\echo '  • Ne pas sur-indexer (ralentit les INSERT/UPDATE)'
\echo '  • Utiliser EXPLAIN ANALYZE sur requêtes lentes'
\echo '  • Mettre à jour statistiques après modifications massives'
\echo ''
\echo '💡 Performance PostgreSQL:'
\echo '  1. Identifier les requêtes lentes (logs, pg_stat_statements)'
\echo '  2. Analyser avec EXPLAIN ANALYZE'
\echo '  3. Optimiser (index, requête, configuration)'
\echo '  4. Mesurer l amélioration'
\echo '  5. Répéter'
\echo '============================================================'
