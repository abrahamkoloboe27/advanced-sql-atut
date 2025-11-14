-- ============================================================================
-- Script: update_delete_truncate.sql
-- Description: Exemples UPDATE, DELETE et TRUNCATE
-- ============================================================================

\echo '============================================================'
\echo 'MODIFICATION ET SUPPRESSION DE DONNÉES'
\echo '============================================================'
\echo ''

-- ============================================================================
-- PARTIE 1: UPDATE - Modifier des données existantes
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 1: UPDATE - Modifier des lignes'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: UPDATE
-- Description: Modifie des lignes existantes dans une table
-- Syntaxe: UPDATE table SET colonne = valeur WHERE condition
-- ⚠️ TOUJOURS utiliser WHERE pour éviter de modifier toutes les lignes!
-- ============================================================================

-- Exemple 1: UPDATE simple (une colonne, une ligne)
-- ============================================================================
\echo '1️⃣ Modifier le prix d un produit spécifique:'

-- Afficher avant modification
\echo 'Avant:'
SELECT product_id, name, price FROM products WHERE product_id = 1;

-- Mise à jour
UPDATE products 
SET price = 799.99 
WHERE product_id = 1;

-- Afficher après modification
\echo 'Après:'
SELECT product_id, name, price FROM products WHERE product_id = 1;

\echo '✅ Prix du produit 1 modifié!'
\echo ''


-- Exemple 2: UPDATE multiple colonnes
-- ============================================================================
\echo '2️⃣ Modifier plusieurs colonnes en même temps:'

UPDATE products 
SET 
    price = 899.99,
    stock = 20
WHERE product_id = 1;

\echo '✅ Prix et stock du produit 1 modifiés!'

SELECT product_id, name, price, stock FROM products WHERE product_id = 1;

\echo ''


-- Exemple 3: UPDATE avec calcul
-- ============================================================================
\echo '3️⃣ Appliquer une réduction de 10% sur tous les produits Informatique:'

-- Afficher avant
\echo 'Avant:'
SELECT name, price, category FROM products WHERE category = 'Informatique';

-- Appliquer la réduction
UPDATE products 
SET price = price * 0.9 
WHERE category = 'Informatique';

-- Afficher après
\echo 'Après (réduction 10%):'
SELECT name, price, category FROM products WHERE category = 'Informatique';

\echo '✅ Réduction appliquée!'
\echo ''


-- Exemple 4: UPDATE avec sous-requête
-- ============================================================================
\echo '4️⃣ UPDATE avec sous-requête (augmenter le stock des produits populaires):'

-- Créer une condition basée sur une sous-requête
UPDATE products 
SET stock = stock + 10
WHERE product_id IN (
    SELECT DISTINCT p.product_id 
    FROM products p
    INNER JOIN orders o ON p.category = 'Informatique'
    WHERE o.status = 'COMPLETED'
    LIMIT 3
);

\echo '✅ Stock augmenté pour les produits populaires!'
\echo ''


-- Exemple 5: UPDATE avec RETURNING (retourne les lignes modifiées)
-- ============================================================================
\echo '5️⃣ UPDATE avec RETURNING:'

UPDATE products 
SET stock = stock - 1 
WHERE product_id = 2
RETURNING product_id, name, stock;

\echo '✅ Stock décrémenté avec RETURNING!'
\echo ''


-- ============================================================================
-- PARTIE 2: DELETE - Supprimer des données
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 2: DELETE - Supprimer des lignes'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: DELETE
-- Description: Supprime des lignes d'une table
-- Syntaxe: DELETE FROM table WHERE condition
-- ⚠️ TOUJOURS utiliser WHERE pour éviter de supprimer toutes les lignes!
-- ============================================================================

-- Exemple 6: DELETE simple
-- ============================================================================
\echo '6️⃣ Supprimer une commande annulée:'

-- Afficher avant suppression
\echo 'Avant:'
SELECT order_id, customer_id, status FROM orders WHERE status = 'CANCELLED';

-- Suppression
DELETE FROM orders 
WHERE status = 'CANCELLED';

-- Vérifier
\echo 'Après:'
SELECT COUNT(*) AS nb_cancelled FROM orders WHERE status = 'CANCELLED';

\echo '✅ Commandes annulées supprimées!'
\echo ''


-- Exemple 7: DELETE avec condition multiple
-- ============================================================================
\echo '7️⃣ Supprimer les produits en rupture de stock depuis plus de 30 jours:'

-- Créer un produit de test
INSERT INTO products (name, price, category, stock) 
VALUES ('Produit Obsolète', 9.99, 'General', 0);

-- Le supprimer
DELETE FROM products 
WHERE stock = 0 AND name LIKE '%Obsolète%';

\echo '✅ Produit obsolète supprimé!'
\echo ''


-- Exemple 8: DELETE avec sous-requête
-- ============================================================================
\echo '8️⃣ DELETE avec sous-requête:'

-- Créer des données de test
INSERT INTO orders (customer_id, order_date, total_amount, status) 
VALUES (1, NOW(), 0.01, 'PENDING');

-- Supprimer les commandes de montant négligeable
DELETE FROM orders 
WHERE order_id IN (
    SELECT order_id FROM orders WHERE total_amount < 1
);

\echo '✅ Commandes de faible montant supprimées!'
\echo ''


-- Exemple 9: DELETE avec RETURNING
-- ============================================================================
\echo '9️⃣ DELETE avec RETURNING (affiche les lignes supprimées):'

-- Créer une commande de test
INSERT INTO orders (customer_id, order_date, total_amount, status) 
VALUES (99, NOW(), 1.00, 'PENDING')
RETURNING order_id;

-- La supprimer avec RETURNING
DELETE FROM orders 
WHERE customer_id = 99
RETURNING order_id, total_amount, status;

\echo '✅ Ligne supprimée avec RETURNING!'
\echo ''


-- ============================================================================
-- PARTIE 3: TRUNCATE - Vider une table
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 3: TRUNCATE - Vider une table rapidement'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: TRUNCATE
-- Description: Supprime TOUTES les lignes d'une table (très rapide)
-- Différence avec DELETE:
--   - TRUNCATE: Vide complètement la table, réinitialise les séquences
--   - DELETE: Supprime ligne par ligne (plus lent mais peut être ROLLBACK)
-- ⚠️ TRUNCATE ne peut pas être annulé facilement!
-- ============================================================================

-- Exemple 10: TRUNCATE simple
-- ============================================================================
\echo '🔟 Créer et vider une table de test:'

-- Créer une table temporaire
CREATE TEMP TABLE test_truncate (
    id SERIAL PRIMARY KEY,
    value TEXT
);

-- Insérer des données
INSERT INTO test_truncate (value) VALUES ('Test 1'), ('Test 2'), ('Test 3');

\echo 'Avant TRUNCATE:'
SELECT COUNT(*) AS nb_rows FROM test_truncate;

-- Vider la table
TRUNCATE test_truncate;

\echo 'Après TRUNCATE:'
SELECT COUNT(*) AS nb_rows FROM test_truncate;

\echo '✅ Table vidée avec TRUNCATE!'
\echo ''


-- Exemple 11: TRUNCATE avec RESTART IDENTITY
-- ============================================================================
\echo '1️⃣1️⃣ TRUNCATE avec réinitialisation des séquences:'

-- Insérer des données
INSERT INTO test_truncate (value) VALUES ('New 1'), ('New 2');

\echo 'IDs avant TRUNCATE:'
SELECT id, value FROM test_truncate;

-- TRUNCATE avec réinitialisation de l'auto-increment
TRUNCATE test_truncate RESTART IDENTITY;

-- Réinsérer
INSERT INTO test_truncate (value) VALUES ('After Truncate');

\echo 'IDs après TRUNCATE RESTART IDENTITY (commence à 1):'
SELECT id, value FROM test_truncate;

\echo '✅ Séquence réinitialisée!'
\echo ''


-- Exemple 12: TRUNCATE avec CASCADE
-- ============================================================================
\echo '1️⃣2️⃣ TRUNCATE avec CASCADE (vide aussi les tables liées):'

-- Créer deux tables liées
CREATE TEMP TABLE parent_table (
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TEMP TABLE child_table (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES parent_table(id),
    description TEXT
);

-- Insérer des données
INSERT INTO parent_table (name) VALUES ('Parent 1'), ('Parent 2');
INSERT INTO child_table (parent_id, description) VALUES (1, 'Child 1'), (2, 'Child 2');

\echo 'Avant TRUNCATE:'
SELECT COUNT(*) FROM parent_table AS parent_count;
SELECT COUNT(*) FROM child_table AS child_count;

-- TRUNCATE avec CASCADE (vide parent ET child)
TRUNCATE parent_table CASCADE;

\echo 'Après TRUNCATE CASCADE:'
SELECT COUNT(*) FROM parent_table AS parent_count;
SELECT COUNT(*) FROM child_table AS child_count;

\echo '✅ Tables parent et enfant vidées!'
\echo ''


-- ============================================================================
-- COMPARAISON DELETE vs TRUNCATE
-- ============================================================================

\echo '============================================================'
\echo 'COMPARAISON: DELETE vs TRUNCATE'
\echo '============================================================'
\echo ''

-- Créer une table de test
CREATE TEMP TABLE comparison_test (
    id SERIAL PRIMARY KEY,
    data TEXT
);

-- Insérer 1000 lignes
INSERT INTO comparison_test (data)
SELECT 'Data ' || generate_series(1, 1000);

\echo 'Table avec 1000 lignes créée.'
\echo ''

-- Test 1: DELETE (ligne par ligne)
\echo '⏱️  Test DELETE:'
\timing on
DELETE FROM comparison_test;
\timing off

-- Réinsérer les données
INSERT INTO comparison_test (data)
SELECT 'Data ' || generate_series(1, 1000);

-- Test 2: TRUNCATE (rapide)
\echo '⏱️  Test TRUNCATE:'
\timing on
TRUNCATE comparison_test;
\timing off

\echo ''
\echo '💡 TRUNCATE est généralement beaucoup plus rapide que DELETE!'
\echo ''


-- ============================================================================
-- BONNES PRATIQUES
-- ============================================================================

\echo '============================================================'
\echo 'BONNES PRATIQUES UPDATE/DELETE/TRUNCATE'
\echo '============================================================'
\echo ''
\echo '⚠️  UPDATE:'
\echo '  ✓ Toujours utiliser WHERE (sauf si mise à jour totale intentionnelle)'
\echo '  ✓ Vérifier avec SELECT avant UPDATE'
\echo '  ✓ Utiliser RETURNING pour confirmer les modifications'
\echo '  ✓ Entourer d une transaction si critique (BEGIN/COMMIT)'
\echo ''
\echo '⚠️  DELETE:'
\echo '  ✓ TOUJOURS utiliser WHERE (sauf suppression totale intentionnelle)'
\echo '  ✓ Vérifier avec SELECT avant DELETE'
\echo '  ✓ Faire un backup avant suppression massive'
\echo '  ✓ Préférer le soft delete (flag deleted=true) pour l historique'
\echo ''
\echo '⚠️  TRUNCATE:'
\echo '  ✓ Utiliser pour vider complètement une table (rapide)'
\echo '  ✓ Attention: ne peut pas être facilement annulé'
\echo '  ✓ RESTART IDENTITY pour réinitialiser les auto-increment'
\echo '  ✓ CASCADE pour vider aussi les tables liées'
\echo ''
\echo '🔒 Sécurité:'
\echo '  ✓ Utiliser des transactions pour opérations critiques'
\echo '  ✓ Limiter les permissions UPDATE/DELETE en production'
\echo '  ✓ Logger les modifications importantes'
\echo '  ✓ Faire des backups réguliers'
\echo '============================================================'


-- Restaurer les prix d'origine (annuler la réduction de 10%)
UPDATE products SET price = price / 0.9 WHERE category = 'Informatique';

\echo ''
\echo '✅ Script terminé! Données restaurées à leur état initial.'
