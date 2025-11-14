-- ============================================================================
-- Script: transactions.sql
-- Description: Exemples de transactions (TCL - Transaction Control Language)
-- Mots-clés: BEGIN, COMMIT, ROLLBACK, SAVEPOINT
-- ============================================================================

\echo '============================================================'
\echo 'TCL - GESTION DES TRANSACTIONS'
\echo '============================================================'
\echo ''

-- ============================================================================
-- TCL (Transaction Control Language)
-- Description: Langage de contrôle des transactions (atomicité, cohérence)
-- Commandes: BEGIN, COMMIT, ROLLBACK, SAVEPOINT, RELEASE SAVEPOINT
-- Propriétés ACID: Atomicité, Cohérence, Isolation, Durabilité
-- ============================================================================

\echo '💡 TCL et propriétés ACID:'
\echo '  • Atomicité: Tout ou rien (COMMIT ou ROLLBACK)'
\echo '  • Cohérence: Respect des contraintes'
\echo '  • Isolation: Transactions indépendantes'
\echo '  • Durabilité: Données persistantes après COMMIT'
\echo ''


-- ============================================================================
-- PARTIE 1: Transactions de base
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 1: BEGIN, COMMIT, ROLLBACK'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: BEGIN (ou START TRANSACTION)
-- Description: Démarre une transaction
-- Tout ce qui suit est temporaire jusqu'à COMMIT ou ROLLBACK
-- ============================================================================

-- Exemple 1: Transaction simple avec COMMIT
-- ============================================================================
\echo '1️⃣ Transaction simple avec COMMIT:'

-- Afficher stock avant
\echo 'Stock du produit 1 AVANT transaction:'
SELECT product_id, name, stock FROM products WHERE product_id = 1;

-- Démarrer une transaction
BEGIN;

\echo ''
\echo '🔄 Transaction démarrée...'

-- Modifier le stock
UPDATE products SET stock = stock - 5 WHERE product_id = 1;

\echo 'Stock modifié (temporaire):'
SELECT product_id, name, stock FROM products WHERE product_id = 1;

-- Valider la transaction
COMMIT;

\echo ''
\echo '✅ Transaction validée (COMMIT)'
\echo 'Stock APRÈS transaction:'
SELECT product_id, name, stock FROM products WHERE product_id = 1;

\echo ''


-- Exemple 2: Transaction avec ROLLBACK
-- ============================================================================
\echo '2️⃣ Transaction avec ROLLBACK (annulation):'

-- Afficher stock avant
\echo 'Stock du produit 2 AVANT transaction:'
SELECT product_id, name, stock FROM products WHERE product_id = 2;

-- Démarrer une transaction
BEGIN;

\echo ''
\echo '🔄 Transaction démarrée...'

-- Modifier le stock (erreur simulée)
UPDATE products SET stock = stock - 100 WHERE product_id = 2;

\echo 'Stock modifié (temporaire - va être annulé):'
SELECT product_id, name, stock FROM products WHERE product_id = 2;

-- Annuler la transaction
ROLLBACK;

\echo ''
\echo '❌ Transaction annulée (ROLLBACK)'
\echo 'Stock APRÈS ROLLBACK (inchangé):'
SELECT product_id, name, stock FROM products WHERE product_id = 2;

\echo ''


-- ============================================================================
-- PARTIE 2: Transactions complexes
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 2: Transactions complexes (multi-tables)'
\echo '============================================================'
\echo ''

-- Exemple 3: Transaction de commande complète
-- ============================================================================
\echo '3️⃣ Scénario: Passer une commande (transaction atomique):'

-- État initial
\echo 'État AVANT la commande:'
SELECT product_id, name, stock FROM products WHERE product_id = 1;
SELECT COUNT(*) AS nb_orders FROM orders;

\echo ''

-- Démarrer la transaction
BEGIN;

\echo '🔄 Transaction démarrée: Traitement de la commande...'
\echo ''

-- Étape 1: Créer la commande
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES (1, NOW(), 899.99, 'PENDING')
RETURNING order_id;

-- Récupérer l'ID de la commande (simulation)
-- Dans une vraie application, on stockerait l'ID retourné

-- Étape 2: Décrémenter le stock
UPDATE products 
SET stock = stock - 1 
WHERE product_id = 1 AND stock > 0;

-- Vérifier que le stock a bien été décrémenté
SELECT product_id, name, stock FROM products WHERE product_id = 1;

-- Étape 3: Valider la commande
UPDATE orders 
SET status = 'COMPLETED' 
WHERE order_id = (SELECT MAX(order_id) FROM orders);

-- Valider la transaction
COMMIT;

\echo ''
\echo '✅ Commande validée!'
\echo 'État APRÈS la commande:'
SELECT product_id, name, stock FROM products WHERE product_id = 1;
SELECT COUNT(*) AS nb_orders FROM orders;

\echo ''


-- Exemple 4: Transaction qui échoue et ROLLBACK automatique
-- ============================================================================
\echo '4️⃣ Transaction avec erreur (ROLLBACK automatique):'

\echo 'État AVANT transaction échouée:'
SELECT product_id, name, stock FROM products WHERE product_id = 3;

\echo ''

-- Tenter une transaction avec erreur
BEGIN;

\echo '🔄 Transaction démarrée...'

-- Mise à jour valide
UPDATE products SET stock = stock - 1 WHERE product_id = 3;

-- Cette commande va échouer (violation de contrainte CHECK)
-- Le stock ne peut pas être négatif
UPDATE products SET stock = -10 WHERE product_id = 3;

-- Cette ligne ne sera jamais exécutée car erreur au-dessus
COMMIT;

\echo ''
\echo '❌ Transaction automatiquement annulée suite à l erreur'
\echo 'État APRÈS (inchangé grâce au ROLLBACK automatique):'
SELECT product_id, name, stock FROM products WHERE product_id = 3;

\echo ''


-- ============================================================================
-- PARTIE 3: SAVEPOINT (points de sauvegarde)
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 3: SAVEPOINT - Points de sauvegarde'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: SAVEPOINT
-- Description: Crée un point de sauvegarde dans une transaction
-- Permet de ROLLBACK à ce point sans annuler toute la transaction
-- ============================================================================

-- Exemple 5: SAVEPOINT et ROLLBACK TO
-- ============================================================================
\echo '5️⃣ Utilisation de SAVEPOINT:'

BEGIN;

\echo '🔄 Transaction démarrée'
\echo ''

-- Opération 1: Insérer un client
INSERT INTO customers (first_name, last_name, email)
VALUES ('Test', 'User1', 'test.user1@email.fr')
RETURNING customer_id, first_name, last_name;

\echo '✅ Client 1 inséré'

-- Créer un point de sauvegarde
SAVEPOINT after_first_insert;

\echo '💾 SAVEPOINT créé: after_first_insert'
\echo ''

-- Opération 2: Insérer un deuxième client
INSERT INTO customers (first_name, last_name, email)
VALUES ('Test', 'User2', 'test.user2@email.fr')
RETURNING customer_id, first_name, last_name;

\echo '✅ Client 2 inséré'
\echo ''

-- Problème détecté, on annule uniquement le deuxième client
\echo '⚠️  Problème détecté! Annulation du client 2...'
ROLLBACK TO SAVEPOINT after_first_insert;

\echo '↩️  ROLLBACK TO SAVEPOINT effectué (client 2 annulé, client 1 conservé)'
\echo ''

-- Valider la transaction (client 1 sera sauvegardé)
COMMIT;

\echo '✅ Transaction validée'
\echo ''

-- Vérifier
\echo 'Clients de test insérés:'
SELECT customer_id, first_name, last_name, email 
FROM customers 
WHERE email LIKE 'test.user%';

\echo ''


-- Exemple 6: SAVEPOINT multiples
-- ============================================================================
\echo '6️⃣ SAVEPOINT multiples (stack de points de sauvegarde):'

BEGIN;

\echo '🔄 Transaction démarrée'

-- Point initial
UPDATE products SET stock = stock + 10 WHERE product_id = 1;
\echo '  • Stock produit 1 augmenté de 10'
SAVEPOINT sp1;
\echo '  💾 SAVEPOINT sp1'

UPDATE products SET stock = stock + 10 WHERE product_id = 2;
\echo '  • Stock produit 2 augmenté de 10'
SAVEPOINT sp2;
\echo '  💾 SAVEPOINT sp2'

UPDATE products SET stock = stock + 10 WHERE product_id = 3;
\echo '  • Stock produit 3 augmenté de 10'
SAVEPOINT sp3;
\echo '  💾 SAVEPOINT sp3'

\echo ''

-- Annuler jusqu'à sp1 (annule sp2 et sp3)
\echo 'ROLLBACK TO sp1...'
ROLLBACK TO SAVEPOINT sp1;

\echo '↩️  Modifications des produits 2 et 3 annulées'
\echo '  ✓ Produit 1: +10 (conservé)'
\echo '  ✗ Produit 2: +10 (annulé)'
\echo '  ✗ Produit 3: +10 (annulé)'

-- Valider
COMMIT;

\echo ''
\echo '✅ Transaction validée'
\echo ''


-- ============================================================================
-- PARTIE 4: Gestion des erreurs avec transactions
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 4: Gestion des erreurs'
\echo '============================================================'
\echo ''

-- Exemple 7: Transaction avec vérifications
-- ============================================================================
\echo '7️⃣ Transaction sécurisée avec vérifications:'

DO $$
DECLARE
    v_stock INTEGER;
    v_product_id INTEGER := 1;
    v_quantity INTEGER := 5;
BEGIN
    -- Démarrer une transaction explicite
    BEGIN
        -- Vérifier le stock disponible
        SELECT stock INTO v_stock FROM products WHERE product_id = v_product_id;
        
        IF v_stock < v_quantity THEN
            RAISE EXCEPTION 'Stock insuffisant! Disponible: %, Demandé: %', v_stock, v_quantity;
        END IF;
        
        -- Décrémenter le stock
        UPDATE products SET stock = stock - v_quantity WHERE product_id = v_product_id;
        
        RAISE NOTICE 'Stock mis à jour avec succès: % unités retirées', v_quantity;
        
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'Erreur: %', SQLERRM;
            RAISE;
    END;
END $$;

\echo ''


-- ============================================================================
-- EXEMPLE PRATIQUE: Transfert d'argent (classique)
-- ============================================================================

\echo '============================================================'
\echo 'EXEMPLE PRATIQUE: Transfert entre comptes'
\echo '============================================================'
\echo ''

-- Créer une table de comptes bancaires pour la démo
CREATE TEMP TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_name VARCHAR(100),
    balance NUMERIC(10, 2) CHECK (balance >= 0)
);

-- Insérer des comptes
INSERT INTO accounts (account_name, balance) VALUES
    ('Compte Alice', 1000.00),
    ('Compte Bob', 500.00);

\echo 'Comptes créés:'
SELECT * FROM accounts;
\echo ''

-- Fonction de transfert
\echo '💸 Transfert de 200€ d Alice vers Bob:'
\echo ''

BEGIN;

-- Vérifier le solde suffisant
DO $$
DECLARE
    v_from_balance NUMERIC(10, 2);
    v_amount NUMERIC(10, 2) := 200.00;
BEGIN
    -- Vérifier le solde
    SELECT balance INTO v_from_balance FROM accounts WHERE account_id = 1 FOR UPDATE;
    
    IF v_from_balance < v_amount THEN
        RAISE EXCEPTION 'Solde insuffisant!';
    END IF;
    
    -- Débiter le compte source
    UPDATE accounts SET balance = balance - v_amount WHERE account_id = 1;
    
    -- Créditer le compte destination
    UPDATE accounts SET balance = balance + v_amount WHERE account_id = 2;
    
    RAISE NOTICE 'Transfert réussi: %.2f€', v_amount;
END $$;

COMMIT;

\echo ''
\echo '✅ Transfert validé!'
\echo 'Soldes APRÈS transfert:'
SELECT * FROM accounts;

\echo ''


-- ============================================================================
-- NETTOYAGE
-- ============================================================================

\echo '============================================================'
\echo 'NETTOYAGE'
\echo '============================================================'
\echo ''

-- Supprimer les clients de test
DELETE FROM customers WHERE email LIKE 'test.user%';

-- Restaurer les stocks modifiés
UPDATE products SET stock = 15 WHERE product_id = 1;
UPDATE products SET stock = 50 WHERE product_id = 2;
UPDATE products SET stock = 30 WHERE product_id = 3;

\echo '✅ Données de test nettoyées'
\echo ''


-- ============================================================================
-- RÉCAPITULATIF
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF TCL (Transaction Control Language)'
\echo '============================================================'
\echo ''
\echo '📌 Commandes de base:'
\echo '  ✓ BEGIN (ou START TRANSACTION) - Démarre une transaction'
\echo '  ✓ COMMIT - Valide les modifications'
\echo '  ✓ ROLLBACK - Annule les modifications'
\echo ''
\echo '📌 Points de sauvegarde:'
\echo '  ✓ SAVEPOINT nom - Crée un point de sauvegarde'
\echo '  ✓ ROLLBACK TO SAVEPOINT nom - Annule jusqu au point'
\echo '  ✓ RELEASE SAVEPOINT nom - Libère un point de sauvegarde'
\echo ''
\echo '📌 Propriétés ACID:'
\echo '  ✓ Atomicité: Tout ou rien'
\echo '  ✓ Cohérence: Respect des contraintes'
\echo '  ✓ Isolation: Transactions indépendantes'
\echo '  ✓ Durabilité: Données persistantes après COMMIT'
\echo ''
\echo '📌 Cas d usage:'
\echo '  ✓ Opérations multi-tables (commande + stock)'
\echo '  ✓ Transferts d argent'
\echo '  ✓ Imports/exports de données'
\echo '  ✓ Modifications critiques'
\echo ''
\echo '⚠️  Bonnes pratiques:'
\echo '  • Garder les transactions courtes (performances)'
\echo '  • Toujours inclure gestion d erreur (try/catch)'
\echo '  • Utiliser SAVEPOINT pour logique complexe'
\echo '  • COMMIT ou ROLLBACK explicitement'
\echo '  • Ne pas oublier de fermer les transactions'
\echo ''
\echo '💡 Note:'
\echo '  • En PostgreSQL, chaque requête est une transaction implicite'
\echo '  • BEGIN rend la transaction explicite'
\echo '  • Autocommit est activé par défaut'
\echo '============================================================'
