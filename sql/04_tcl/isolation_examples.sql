-- ============================================================================
-- Script: isolation_examples.sql
-- Description: Exemples des niveaux d'isolation des transactions
-- Niveaux: READ UNCOMMITTED, READ COMMITTED, REPEATABLE READ, SERIALIZABLE
-- ============================================================================

\echo '============================================================'
\echo 'NIVEAUX D ISOLATION DES TRANSACTIONS'
\echo '============================================================'
\echo ''

-- ============================================================================
-- ISOLATION DES TRANSACTIONS
-- Description: Contrôle la visibilité des modifications entre transactions
-- concurrentes
-- Problèmes d'isolation:
--   - Dirty Read: Lire des données non validées
--   - Non-Repeatable Read: Lecture différente lors de relecture
--   - Phantom Read: Nouvelles lignes apparaissent lors de relecture
-- ============================================================================

\echo '💡 Niveaux d isolation (du moins strict au plus strict):'
\echo '  1. READ UNCOMMITTED (non supporté par PostgreSQL)'
\echo '  2. READ COMMITTED (défaut PostgreSQL)'
\echo '  3. REPEATABLE READ'
\echo '  4. SERIALIZABLE'
\echo ''

\echo '📋 Problèmes d isolation:'
\echo '  • Dirty Read: Lire des données non validées'
\echo '  • Non-Repeatable Read: Résultat différent à la relecture'
\echo '  • Phantom Read: Nouvelles lignes apparaissent'
\echo ''


-- ============================================================================
-- PARTIE 1: READ COMMITTED (Défaut PostgreSQL)
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 1: READ COMMITTED (niveau par défaut)'
\echo '============================================================'
\echo ''

-- ============================================================================
-- READ COMMITTED
-- Description: Lit uniquement les données validées (COMMIT)
-- Protège contre: Dirty Reads
-- Permet: Non-Repeatable Reads, Phantom Reads
-- ============================================================================

\echo '1️⃣ Démonstration READ COMMITTED:'
\echo ''

-- Afficher le niveau d'isolation actuel
\echo 'Niveau d isolation actuel:'
SHOW transaction_isolation;
\echo ''

-- Créer une table de test
CREATE TEMP TABLE balance_test (
    id SERIAL PRIMARY KEY,
    account VARCHAR(50),
    amount NUMERIC(10, 2)
);

INSERT INTO balance_test (account, amount) VALUES ('Account A', 1000.00);

\echo 'Solde initial:'
SELECT * FROM balance_test;
\echo ''

-- Simulation de deux transactions concurrentes
\echo '📝 Scénario:'
\echo '  Transaction 1: Lit le solde'
\echo '  Transaction 2: Modifie le solde et COMMIT'
\echo '  Transaction 1: Relit le solde'
\echo ''

-- Transaction 1
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

\echo 'Transaction 1 - Première lecture:'
SELECT amount AS first_read FROM balance_test WHERE id = 1;

-- Simuler Transaction 2 qui modifie et COMMIT
-- (dans une vraie application, ce serait une autre session)
\echo ''
\echo 'Transaction 2 (simulée) - Modification et COMMIT:'

-- Sauvegarder l'état de la transaction 1
SAVEPOINT before_tx2;

-- Simuler la transaction 2
UPDATE balance_test SET amount = 1500.00 WHERE id = 1;
\echo '  • Solde modifié à 1500.00'

-- Transaction 1 relit (va voir la nouvelle valeur car READ COMMITTED)
\echo ''
\echo 'Transaction 1 - Deuxième lecture (après COMMIT de Tx2):'
SELECT amount AS second_read FROM balance_test WHERE id = 1;

\echo ''
\echo '✅ Non-Repeatable Read possible en READ COMMITTED'
\echo '   (la valeur a changé entre deux lectures)'

COMMIT;

\echo ''


-- ============================================================================
-- PARTIE 2: REPEATABLE READ
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 2: REPEATABLE READ'
\echo '============================================================'
\echo ''

-- ============================================================================
-- REPEATABLE READ
-- Description: Garantit des lectures cohérentes dans la même transaction
-- Protège contre: Dirty Reads, Non-Repeatable Reads
-- Permet: Phantom Reads (mais PostgreSQL protège aussi contre ça!)
-- ============================================================================

\echo '2️⃣ Démonstration REPEATABLE READ:'
\echo ''

-- Réinitialiser
TRUNCATE balance_test;
INSERT INTO balance_test (account, amount) VALUES ('Account B', 2000.00);

\echo 'Solde initial:'
SELECT * FROM balance_test;
\echo ''

-- Transaction 1 en REPEATABLE READ
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;

\echo 'Transaction 1 (REPEATABLE READ) - Première lecture:'
SELECT amount AS first_read FROM balance_test WHERE id = 1;

-- Simuler Transaction 2
\echo ''
\echo 'Transaction 2 (simulée) - Tente de modifier:'

SAVEPOINT before_modify;

-- Créer une nouvelle connexion simulée qui modifie
-- Note: En REPEATABLE READ, Tx1 ne verra PAS cette modification
UPDATE balance_test SET amount = 2500.00 WHERE id = 1;
\echo '  • Solde modifié à 2500.00'

RELEASE SAVEPOINT before_modify;

-- Transaction 1 relit
\echo ''
\echo 'Transaction 1 - Deuxième lecture (snapshot de transaction):'
SELECT amount AS second_read FROM balance_test WHERE id = 1;

\echo ''
\echo '✅ En REPEATABLE READ, la valeur reste identique'
\echo '   (snapshot de la transaction au moment du BEGIN)'

COMMIT;

\echo ''
\echo 'Après COMMIT de Tx1:'
SELECT amount FROM balance_test WHERE id = 1;

\echo ''


-- ============================================================================
-- PARTIE 3: SERIALIZABLE
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 3: SERIALIZABLE (isolation maximale)'
\echo '============================================================'
\echo ''

-- ============================================================================
-- SERIALIZABLE
-- Description: Isolation complète, comme si les transactions étaient
--              exécutées en série (une après l'autre)
-- Protège contre: Dirty Reads, Non-Repeatable Reads, Phantom Reads
-- Coût: Performance réduite, risque de conflits de sérialisation
-- ============================================================================

\echo '3️⃣ Démonstration SERIALIZABLE:'
\echo ''

-- Créer une table pour démo
CREATE TEMP TABLE inventory (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    stock INTEGER CHECK (stock >= 0)
);

INSERT INTO inventory VALUES
    (1, 'Laptop', 10),
    (2, 'Mouse', 50),
    (3, 'Keyboard', 30);

\echo 'Inventaire initial:'
SELECT * FROM inventory;
\echo ''

-- Transaction 1: SERIALIZABLE
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

\echo 'Transaction 1 (SERIALIZABLE) - Lecture du stock total:'
SELECT SUM(stock) AS total_stock FROM inventory;

-- Calculer une statistique
SELECT 
    product_name,
    stock,
    ROUND(stock * 100.0 / SUM(stock) OVER (), 2) AS percentage
FROM inventory;

\echo ''
\echo 'Transaction 1 attend avant de COMMIT...'
\echo ''

-- Simuler Transaction 2 qui ajoute une ligne
\echo 'Transaction 2 (simulée) - Ajoute un nouveau produit:'

SAVEPOINT before_insert;

INSERT INTO inventory VALUES (4, 'Monitor', 20);
\echo '  • Nouveau produit ajouté'

RELEASE SAVEPOINT before_insert;

-- Transaction 1 recalcule
\echo ''
\echo 'Transaction 1 - Recalcul des statistiques:'
SELECT SUM(stock) AS total_stock FROM inventory;

\echo ''
\echo '✅ En SERIALIZABLE, Tx1 ne voit PAS le nouveau produit'
\echo '   (phantom read évité)'

COMMIT;

\echo ''


-- ============================================================================
-- PARTIE 4: Comparaison des niveaux
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 4: Tableau comparatif des niveaux d isolation'
\echo '============================================================'
\echo ''

-- Créer une table récapitulative
CREATE TEMP TABLE isolation_comparison (
    isolation_level VARCHAR(30),
    dirty_read VARCHAR(10),
    non_repeatable_read VARCHAR(10),
    phantom_read VARCHAR(10),
    performance VARCHAR(20)
);

INSERT INTO isolation_comparison VALUES
    ('READ UNCOMMITTED', 'Possible', 'Possible', 'Possible', 'Très élevée'),
    ('READ COMMITTED', 'Non', 'Possible', 'Possible', 'Élevée'),
    ('REPEATABLE READ', 'Non', 'Non', 'Possible*', 'Moyenne'),
    ('SERIALIZABLE', 'Non', 'Non', 'Non', 'Faible');

\echo '📊 Comparaison des niveaux d isolation:'
\echo ''
SELECT 
    isolation_level AS "Niveau",
    dirty_read AS "Dirty Read",
    non_repeatable_read AS "Non-Rep. Read",
    phantom_read AS "Phantom Read",
    performance AS "Performance"
FROM isolation_comparison;

\echo ''
\echo '* PostgreSQL protège contre les Phantom Reads même en REPEATABLE READ'
\echo ''


-- ============================================================================
-- PARTIE 5: Exemples pratiques de choix d'isolation
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 5: Quand utiliser quel niveau?'
\echo '============================================================'
\echo ''

\echo '💼 Cas d usage par niveau:'
\echo ''

\echo '1️⃣ READ COMMITTED (défaut):'
\echo '  ✓ Applications web standards'
\echo '  ✓ Lectures de rapports non critiques'
\echo '  ✓ 80% des cas d usage'
\echo ''

\echo '2️⃣ REPEATABLE READ:'
\echo '  ✓ Rapports nécessitant cohérence'
\echo '  ✓ Calculs sur plusieurs lectures'
\echo '  ✓ Exports de données'
\echo '  ✓ Migrations de données'
\echo ''

\echo '3️⃣ SERIALIZABLE:'
\echo '  ✓ Transactions financières critiques'
\echo '  ✓ Comptabilité stricte'
\echo '  ✓ Quand l intégrité est absolument critique'
\echo '  ⚠️  Risque de conflits de sérialisation'
\echo ''


-- ============================================================================
-- PARTIE 6: Gestion des conflits en SERIALIZABLE
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 6: Gestion des conflits de sérialisation'
\echo '============================================================'
\echo ''

\echo '6️⃣ Exemple de conflit et retry pattern:'
\echo ''

-- Fonction de retry avec gestion d'erreur
DO $$
DECLARE
    max_retries INTEGER := 3;
    retry_count INTEGER := 0;
    success BOOLEAN := FALSE;
BEGIN
    WHILE retry_count < max_retries AND NOT success LOOP
        BEGIN
            -- Tenter la transaction
            BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
            
            -- Opération critique
            UPDATE inventory SET stock = stock - 1 WHERE product_id = 1;
            
            COMMIT;
            success := TRUE;
            
            RAISE NOTICE 'Transaction réussie au %è essai', retry_count + 1;
            
        EXCEPTION
            WHEN serialization_failure THEN
                retry_count := retry_count + 1;
                RAISE NOTICE 'Conflit de sérialisation, retry % / %', retry_count, max_retries;
                
                IF retry_count >= max_retries THEN
                    RAISE EXCEPTION 'Échec après % tentatives', max_retries;
                END IF;
                
                -- Attendre un peu avant de réessayer
                PERFORM pg_sleep(0.1 * retry_count);
        END;
    END LOOP;
END $$;

\echo ''


-- ============================================================================
-- PARTIE 7: Définir le niveau d'isolation
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 7: Comment définir le niveau d isolation'
\echo '============================================================'
\echo ''

\echo 'Méthode 1: Par transaction'
\echo '  BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;'
\echo '  BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;'
\echo '  BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;'
\echo ''

\echo 'Méthode 2: Pour la session courante'
\echo '  SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;'
\echo ''

\echo 'Méthode 3: Pour la base de données (postgresql.conf)'
\echo '  default_transaction_isolation = repeatable read'
\echo ''

-- Exemple: Changer pour la session
\echo 'Changement du niveau par défaut pour cette session:'
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SHOW transaction_isolation;

-- Restaurer à READ COMMITTED
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

\echo ''


-- ============================================================================
-- RÉCAPITULATIF
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF - ISOLATION DES TRANSACTIONS'
\echo '============================================================'
\echo ''
\echo '📌 Niveaux d isolation PostgreSQL:'
\echo '  1. READ COMMITTED (défaut)'
\echo '     • Lit uniquement les données validées'
\echo '     • Performance élevée'
\echo '     • Recommandé pour la plupart des cas'
\echo ''
\echo '  2. REPEATABLE READ'
\echo '     • Snapshot de la transaction'
\echo '     • Lectures cohérentes'
\echo '     • Idéal pour rapports et calculs'
\echo ''
\echo '  3. SERIALIZABLE'
\echo '     • Isolation maximale'
\echo '     • Comme exécution en série'
\echo '     • Utiliser avec précaution (performance)'
\echo ''
\echo '⚠️  Problèmes d isolation:'
\echo '  • Dirty Read: Lire des données non validées'
\echo '  • Non-Repeatable Read: Valeur change entre lectures'
\echo '  • Phantom Read: Nouvelles lignes apparaissent'
\echo ''
\echo '💡 Bonnes pratiques:'
\echo '  ✓ Utiliser READ COMMITTED par défaut'
\echo '  ✓ REPEATABLE READ pour cohérence de lecture'
\echo '  ✓ SERIALIZABLE uniquement si absolument nécessaire'
\echo '  ✓ Implémenter retry logic pour SERIALIZABLE'
\echo '  ✓ Garder les transactions courtes'
\echo '  ✓ Tester avec charge concurrente'
\echo ''
\echo '📚 Documentation PostgreSQL:'
\echo '  https://www.postgresql.org/docs/current/transaction-iso.html'
\echo '============================================================'
