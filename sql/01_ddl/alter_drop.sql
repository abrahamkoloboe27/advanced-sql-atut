-- ============================================================================
-- Script: alter_drop.sql
-- Description: Exemples d'utilisation d'ALTER TABLE et DROP TABLE
-- ============================================================================

-- ============================================================================
-- Mot-clé: ALTER TABLE
-- Description: Modifie la structure d'une table existante
-- Opérations possibles: ADD COLUMN, DROP COLUMN, RENAME, ALTER COLUMN, etc.
-- ============================================================================

\echo '============================================================'
\echo 'EXEMPLES: ALTER TABLE - Modifier la structure des tables'
\echo '============================================================'
\echo ''

-- Exemple 1: Ajouter une nouvelle colonne
-- ============================================================================
-- Mot-clé: ALTER TABLE ... ADD COLUMN
-- Ajoute une colonne 'phone' à la table customers

\echo '1️⃣ Ajout d une colonne phone à customers...'

ALTER TABLE customers 
ADD COLUMN phone VARCHAR(20);

COMMENT ON COLUMN customers.phone IS 'Numéro de téléphone du client (optionnel)';

\echo '✅ Colonne phone ajoutée!'
\echo ''


-- Exemple 2: Modifier une colonne existante
-- ============================================================================
-- Mot-clé: ALTER TABLE ... ALTER COLUMN
-- Permet de changer le type, la valeur par défaut, ou ajouter/enlever NOT NULL

\echo '2️⃣ Modification de la colonne category dans products...'

-- Ajouter une valeur par défaut
ALTER TABLE products 
ALTER COLUMN category SET DEFAULT 'General';

-- Rendre la colonne obligatoire
ALTER TABLE products 
ALTER COLUMN category SET NOT NULL;

\echo '✅ Colonne category modifiée (NOT NULL + DEFAULT)!'
\echo ''


-- Exemple 3: Renommer une colonne
-- ============================================================================
-- Mot-clé: ALTER TABLE ... RENAME COLUMN

\echo '3️⃣ Renommage de la colonne name en product_name dans products...'

ALTER TABLE products 
RENAME COLUMN name TO product_name;

\echo '✅ Colonne renommée: name -> product_name!'
\echo ''


-- Exemple 4: Ajouter une contrainte CHECK
-- ============================================================================
-- Mot-clé: ALTER TABLE ... ADD CONSTRAINT

\echo '4️⃣ Ajout d une contrainte sur total_amount dans orders...'

ALTER TABLE orders 
ADD CONSTRAINT check_total_positive 
CHECK (total_amount > 0);

\echo '✅ Contrainte check_total_positive ajoutée!'
\echo ''


-- Exemple 5: Supprimer une colonne
-- ============================================================================
-- Mot-clé: ALTER TABLE ... DROP COLUMN
-- ⚠️ ATTENTION: Supprime définitivement la colonne et ses données!

\echo '5️⃣ Suppression de la colonne phone de customers...'

ALTER TABLE customers 
DROP COLUMN IF EXISTS phone;

\echo '✅ Colonne phone supprimée!'
\echo ''


-- Exemple 6: Renommer la colonne product_name en name (revenir à l'original)
-- ============================================================================

\echo '6️⃣ Restauration du nom original de la colonne...'

ALTER TABLE products 
RENAME COLUMN product_name TO name;

\echo '✅ Colonne restaurée: product_name -> name!'
\echo ''


-- ============================================================================
-- Mot-clé: DROP TABLE
-- Description: Supprime une table de la base de données
-- ⚠️ ATTENTION: Opération destructive et irréversible!
-- Options: CASCADE (supprime aussi les objets dépendants), RESTRICT (par défaut)
-- ============================================================================

\echo ''
\echo '============================================================'
\echo 'EXEMPLES: DROP TABLE - Supprimer des tables'
\echo '============================================================'
\echo ''

-- Créer une table temporaire pour la démonstration
CREATE TABLE IF NOT EXISTS temp_demo (
    id SERIAL PRIMARY KEY,
    description TEXT
);

\echo '📋 Table temp_demo créée pour démonstration...'
\echo ''

-- Exemple 7: Supprimer une table simple
-- ============================================================================
-- Mot-clé: DROP TABLE [IF EXISTS]

\echo '7️⃣ Suppression de la table temp_demo...'

DROP TABLE IF EXISTS temp_demo;

\echo '✅ Table temp_demo supprimée!'
\echo ''


-- Exemple 8: DROP TABLE avec CASCADE
-- ============================================================================
-- CASCADE supprime aussi les objets dépendants (vues, contraintes, etc.)

-- Créer une table de test avec dépendances
CREATE TABLE IF NOT EXISTS test_parent (
    id SERIAL PRIMARY KEY,
    value VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS test_child (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER REFERENCES test_parent(id)
);

\echo '8️⃣ Tables test_parent et test_child créées avec relation FK...'
\echo ''

-- Tentative de suppression sans CASCADE (échouera si des contraintes existent)
-- DROP TABLE test_parent;  -- ❌ Échoue car test_child référence test_parent

-- Suppression avec CASCADE (supprime parent ET les contraintes dans child)
\echo 'Suppression de test_parent avec CASCADE...'

DROP TABLE IF EXISTS test_parent CASCADE;

\echo '✅ Table test_parent supprimée (+ contraintes dans test_child)!'
\echo ''

-- Nettoyage
DROP TABLE IF EXISTS test_child;

\echo '✅ Table test_child supprimée!'
\echo ''


-- ============================================================================
-- Exemple 9: TRUNCATE TABLE
-- ============================================================================
-- Mot-clé: TRUNCATE
-- Description: Vide toutes les lignes d'une table (plus rapide que DELETE)
-- ⚠️ Ne peut pas être annulé (ROLLBACK) facilement, utiliser dans une transaction!

-- Note: TRUNCATE sera détaillé dans sql/02_dml/update_delete_truncate.sql
\echo '💡 Note: Pour vider une table sans la supprimer, utilisez TRUNCATE'
\echo '   (voir sql/02_dml/update_delete_truncate.sql)'
\echo ''


-- ============================================================================
-- Vérification finale
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF des opérations ALTER/DROP'
\echo '============================================================'
\echo 'ALTER TABLE: Ajouter/Modifier/Supprimer colonnes et contraintes'
\echo 'DROP TABLE: Supprimer définitivement une table'
\echo 'CASCADE: Force la suppression malgré les dépendances'
\echo 'IF EXISTS: Évite les erreurs si l objet n existe pas'
\echo ''
\echo '⚠️  ATTENTION: Ces opérations modifient la structure de la base!'
\echo '    Toujours sauvegarder avant de modifier en production!'
\echo '============================================================'
