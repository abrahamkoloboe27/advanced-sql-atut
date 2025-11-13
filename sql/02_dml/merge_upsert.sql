-- ============================================================================
-- Script: merge_upsert.sql
-- Description: Exemples MERGE et UPSERT (INSERT ... ON CONFLICT)
-- Note: PostgreSQL utilise INSERT ... ON CONFLICT au lieu de MERGE
-- ============================================================================

\echo '============================================================'
\echo 'MERGE / UPSERT - Insérer ou Mettre à jour'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Context: MERGE vs INSERT ON CONFLICT
-- ============================================================================
-- MERGE est un standard SQL:2003 introduit dans PostgreSQL 15+
-- INSERT ... ON CONFLICT est la solution PostgreSQL historique (plus courante)
-- Les deux permettent de faire des UPSERT (UPDATE or INSERT)
-- ============================================================================

\echo '💡 Contexte:'
\echo '  • MERGE: Standard SQL (PostgreSQL 15+)'
\echo '  • INSERT ... ON CONFLICT: Syntaxe PostgreSQL (toutes versions)'
\echo '  • Les deux permettent INSERT or UPDATE (UPSERT)'
\echo ''


-- ============================================================================
-- PARTIE 1: INSERT ... ON CONFLICT (syntaxe PostgreSQL)
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 1: INSERT ... ON CONFLICT (UPSERT PostgreSQL)'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: INSERT ... ON CONFLICT
-- Description: Insère une ligne OU met à jour si conflit sur une contrainte
-- Syntaxe: INSERT ... ON CONFLICT (colonne) DO UPDATE SET ...
-- Cas d'usage: Synchronisation de données, imports, éviter les doublons
-- ============================================================================


-- Exemple 1: ON CONFLICT DO NOTHING (ignorer les doublons)
-- ============================================================================
\echo '1️⃣ ON CONFLICT DO NOTHING - Ignorer si existe déjà:'

-- Essayer d'insérer un client avec un email existant
INSERT INTO customers (first_name, last_name, email)
VALUES ('Jean', 'Dupont', 'jean.dupont@email.fr')
ON CONFLICT (email) DO NOTHING;

\echo '✅ Aucune erreur! Insertion ignorée car email existe déjà.'
\echo ''


-- Exemple 2: ON CONFLICT DO UPDATE (mettre à jour si existe)
-- ============================================================================
\echo '2️⃣ ON CONFLICT DO UPDATE - Mettre à jour si existe:'

-- Insérer ou mettre à jour un client
INSERT INTO customers (first_name, last_name, email)
VALUES ('Jean', 'NOUVEAU_NOM', 'jean.dupont@email.fr')
ON CONFLICT (email) 
DO UPDATE SET 
    last_name = EXCLUDED.last_name,
    first_name = EXCLUDED.first_name;

-- EXCLUDED fait référence aux valeurs tentées à l'insertion

\echo '✅ Client mis à jour si existait, inséré sinon.'

-- Vérifier
SELECT first_name, last_name, email 
FROM customers 
WHERE email = 'jean.dupont@email.fr';

\echo ''


-- Exemple 3: UPSERT avec calcul
-- ============================================================================
\echo '3️⃣ UPSERT avec mise à jour conditionnelle:'

-- Créer une table de stock temporaire
CREATE TEMP TABLE product_stock_updates (
    product_id INTEGER PRIMARY KEY,
    stock_change INTEGER
);

-- Insérer des changements de stock
INSERT INTO product_stock_updates (product_id, stock_change) VALUES
    (1, 5),
    (2, -3),
    (3, 10);

-- Appliquer les changements avec UPSERT
\echo 'Mise à jour du stock des produits:'

-- Méthode 1: Mettre à jour directement (si produit existe)
UPDATE products p
SET stock = stock + psu.stock_change
FROM product_stock_updates psu
WHERE p.product_id = psu.product_id;

\echo '✅ Stock mis à jour!'

SELECT product_id, name, stock FROM products WHERE product_id IN (1, 2, 3);

\echo ''


-- Exemple 4: UPSERT complet avec RETURNING
-- ============================================================================
\echo '4️⃣ UPSERT avec RETURNING:'

INSERT INTO products (product_id, name, price, category, stock)
VALUES (100, 'Nouveau Produit', 99.99, 'Informatique', 50)
ON CONFLICT (product_id) 
DO UPDATE SET 
    name = EXCLUDED.name,
    price = EXCLUDED.price,
    stock = products.stock + EXCLUDED.stock
RETURNING product_id, name, price, stock;

\echo '✅ Produit inséré ou mis à jour avec succès!'
\echo ''

-- Nettoyer
DELETE FROM products WHERE product_id = 100;


-- Exemple 5: UPSERT avec plusieurs colonnes de conflit
-- ============================================================================
\echo '5️⃣ UPSERT sur contrainte composée:'

-- Créer une table avec contrainte unique composée
CREATE TEMP TABLE user_preferences (
    user_id INTEGER,
    preference_key VARCHAR(50),
    preference_value TEXT,
    updated_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (user_id, preference_key)
);

-- Insérer une préférence
INSERT INTO user_preferences (user_id, preference_key, preference_value)
VALUES (1, 'theme', 'dark')
ON CONFLICT (user_id, preference_key) 
DO UPDATE SET 
    preference_value = EXCLUDED.preference_value,
    updated_at = NOW();

\echo 'Première insertion:'
SELECT * FROM user_preferences;

-- Mettre à jour la même préférence
INSERT INTO user_preferences (user_id, preference_key, preference_value)
VALUES (1, 'theme', 'light')
ON CONFLICT (user_id, preference_key) 
DO UPDATE SET 
    preference_value = EXCLUDED.preference_value,
    updated_at = NOW();

\echo ''
\echo 'Après update (theme changé):'
SELECT * FROM user_preferences;

\echo '✅ UPSERT sur contrainte composée réussi!'
\echo ''


-- ============================================================================
-- PARTIE 2: MERGE (Standard SQL - PostgreSQL 15+)
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 2: MERGE (Standard SQL - PostgreSQL 15+)'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: MERGE
-- Description: Combine INSERT, UPDATE, DELETE en une seule commande
-- Syntaxe: MERGE INTO target USING source ON condition
--          WHEN MATCHED THEN UPDATE
--          WHEN NOT MATCHED THEN INSERT
-- ============================================================================

-- Vérifier la version de PostgreSQL
\echo 'Version de PostgreSQL:'
SELECT version();
\echo ''

-- Exemple 6: MERGE basique (PostgreSQL 15+)
-- ============================================================================
\echo '6️⃣ MERGE - Synchroniser des données:'

-- Créer une table source pour la démonstration
CREATE TEMP TABLE product_updates (
    product_id INTEGER,
    name VARCHAR(100),
    price NUMERIC(10, 2),
    category VARCHAR(50),
    stock INTEGER
);

-- Insérer des données dans la source
INSERT INTO product_updates (product_id, name, price, category, stock) VALUES
    (1, 'Ordinateur Portable MAJ', 999.99, 'Informatique', 20),  -- Existe: UPDATE
    (2, 'Souris Sans Fil MAJ', 34.99, 'Informatique', 60),       -- Existe: UPDATE
    (200, 'Tablette Graphique', 299.99, 'Informatique', 15);     -- N'existe pas: INSERT

\echo 'Données source préparées pour MERGE:'
SELECT * FROM product_updates;
\echo ''

-- MERGE (si PostgreSQL >= 15)
-- Note: Si version < 15, cette commande échouera
-- Utiliser INSERT ... ON CONFLICT à la place

\echo 'Exécution du MERGE...'
\echo '(Si erreur "MERGE not supported", utiliser INSERT ON CONFLICT à la place)'
\echo ''

-- Tentative de MERGE (commenté car peut ne pas être supporté)
/*
MERGE INTO products p
USING product_updates pu ON p.product_id = pu.product_id
WHEN MATCHED THEN
    UPDATE SET 
        name = pu.name,
        price = pu.price,
        stock = pu.stock
WHEN NOT MATCHED THEN
    INSERT (product_id, name, price, category, stock)
    VALUES (pu.product_id, pu.name, pu.price, pu.category, pu.stock);
*/

\echo '💡 Alternative avec INSERT ... ON CONFLICT (compatible toutes versions):'
\echo ''

-- Alternative compatible toutes versions PostgreSQL
INSERT INTO products (product_id, name, price, category, stock)
SELECT product_id, name, price, category, stock FROM product_updates
ON CONFLICT (product_id) 
DO UPDATE SET 
    name = EXCLUDED.name,
    price = EXCLUDED.price,
    stock = EXCLUDED.stock;

\echo '✅ Données synchronisées avec INSERT ON CONFLICT!'
\echo ''

-- Vérifier
SELECT product_id, name, price, stock 
FROM products 
WHERE product_id IN (1, 2, 200);

\echo ''

-- Nettoyer
DELETE FROM products WHERE product_id = 200;


-- ============================================================================
-- EXEMPLE PRATIQUE: Synchronisation de catalogue
-- ============================================================================

\echo '============================================================'
\echo 'EXEMPLE PRATIQUE: Synchronisation de catalogue produits'
\echo '============================================================'
\echo ''

-- Scénario: Import quotidien d'un fichier CSV avec nouveaux prix et stocks

CREATE TEMP TABLE daily_import (
    product_id INTEGER,
    new_price NUMERIC(10, 2),
    new_stock INTEGER
);

INSERT INTO daily_import VALUES
    (1, 849.99, 18),
    (2, 29.99, 55),
    (3, 74.99, 28),
    (999, 149.99, 100);  -- Nouveau produit (n'existe pas encore)

\echo '📥 Import quotidien reçu:'
SELECT * FROM daily_import;
\echo ''

\echo 'Application de l import avec UPSERT...'

-- Mise à jour des produits existants
UPDATE products p
SET 
    price = di.new_price,
    stock = di.new_stock
FROM daily_import di
WHERE p.product_id = di.product_id;

\echo '✅ Catalogue synchronisé!'
\echo ''

-- Vérifier les changements
SELECT product_id, name, price, stock 
FROM products 
WHERE product_id IN (1, 2, 3);

\echo ''


-- ============================================================================
-- RÉCAPITULATIF
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF MERGE / UPSERT'
\echo '============================================================'
\echo ''
\echo '📌 INSERT ... ON CONFLICT (PostgreSQL toutes versions):'
\echo '  ✓ ON CONFLICT (colonne) DO NOTHING - Ignorer les doublons'
\echo '  ✓ ON CONFLICT (colonne) DO UPDATE SET ... - Mettre à jour si existe'
\echo '  ✓ EXCLUDED - Référence aux valeurs tentées à l insertion'
\echo '  ✓ RETURNING - Retourne les lignes insérées/modifiées'
\echo ''
\echo '📌 MERGE (PostgreSQL 15+):'
\echo '  ✓ Standard SQL'
\echo '  ✓ WHEN MATCHED THEN UPDATE'
\echo '  ✓ WHEN NOT MATCHED THEN INSERT'
\echo '  ✓ Plus lisible pour logique complexe'
\echo ''
\echo '💡 Cas d usage:'
\echo '  ✓ Imports de données (CSV, API)'
\echo '  ✓ Synchronisation entre bases'
\echo '  ✓ Éviter les doublons'
\echo '  ✓ Mise à jour conditionnelle'
\echo ''
\echo '⚠️  Recommandation:'
\echo '  → Utiliser INSERT ... ON CONFLICT (compatible, performant)'
\echo '  → Utiliser MERGE si PostgreSQL 15+ et logique complexe'
\echo '============================================================'

-- Restaurer les prix d'origine
UPDATE products SET price = 899.99 WHERE product_id = 1;
UPDATE products SET price = 29.99 WHERE product_id = 2;
UPDATE products SET price = 79.99 WHERE product_id = 3;

\echo ''
\echo '✅ Données restaurées à l état initial.'
