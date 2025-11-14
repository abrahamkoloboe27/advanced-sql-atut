-- ============================================================================
-- SOLUTION EXERCICE 4 : Transaction avec gestion d'erreur (TCL)
-- ============================================================================

\echo '========================================';
\echo 'SOLUTION EXERCICE 4';
\echo '========================================';
\echo '';

-- ============================================================================
-- Transaction de commande avec gestion d'erreur et SAVEPOINT
-- ============================================================================

\echo 'Scénario : Passer une commande avec gestion de stock';
\echo '';

-- Paramètres
DO $$
DECLARE
    v_customer_id INTEGER := 1;
    v_product_id INTEGER := 1;
    v_quantity INTEGER := 2;
    v_unit_price NUMERIC(10, 2);
    v_total_amount NUMERIC(10, 2);
    v_stock_disponible INTEGER;
    v_order_id INTEGER;
BEGIN
    -- Démarrer la transaction
    BEGIN
        \echo 'Transaction démarrée...';
        
        -- Vérifier que le client existe
        IF NOT EXISTS (SELECT 1 FROM customers WHERE customer_id = v_customer_id) THEN
            RAISE EXCEPTION 'Client % inexistant!', v_customer_id;
        END IF;
        
        RAISE NOTICE '✓ Client vérifié (ID: %)', v_customer_id;
        
        -- Récupérer le prix et le stock du produit
        SELECT price, stock 
        INTO v_unit_price, v_stock_disponible
        FROM products 
        WHERE product_id = v_product_id;
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Produit % inexistant!', v_product_id;
        END IF;
        
        RAISE NOTICE '✓ Produit trouvé - Prix: %, Stock: %', v_unit_price, v_stock_disponible;
        
        -- Calculer le montant total
        v_total_amount := v_unit_price * v_quantity;
        
        -- Insérer la commande
        INSERT INTO orders (customer_id, order_date, total_amount, status)
        VALUES (v_customer_id, NOW(), v_total_amount, 'PENDING')
        RETURNING order_id INTO v_order_id;
        
        RAISE NOTICE '✓ Commande créée (ID: %, Montant: %)', v_order_id, v_total_amount;
        
        -- Créer un SAVEPOINT après la commande
        -- Note: Les SAVEPOINT dans DO block doivent être gérés différemment
        -- On utilise plutôt des sous-blocs BEGIN/EXCEPTION
        
        -- Vérifier le stock suffisant
        IF v_stock_disponible < v_quantity THEN
            RAISE EXCEPTION 'Stock insuffisant! Disponible: %, Demandé: %', 
                v_stock_disponible, v_quantity;
        END IF;
        
        -- Décrémenter le stock
        UPDATE products 
        SET stock = stock - v_quantity
        WHERE product_id = v_product_id;
        
        RAISE NOTICE '✓ Stock décrémenté (produit %, quantité: %)', v_product_id, v_quantity;
        
        -- Marquer la commande comme complétée
        UPDATE orders 
        SET status = 'COMPLETED'
        WHERE order_id = v_order_id;
        
        RAISE NOTICE '✓ Commande validée!';
        RAISE NOTICE '';
        RAISE NOTICE '========================================';
        RAISE NOTICE 'SUCCÈS - Transaction validée!';
        RAISE NOTICE 'Order ID: %', v_order_id;
        RAISE NOTICE 'Montant: %', v_total_amount;
        RAISE NOTICE '========================================';
        
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '';
            RAISE NOTICE '========================================';
            RAISE NOTICE 'ERREUR - Transaction annulée!';
            RAISE NOTICE 'Message: %', SQLERRM;
            RAISE NOTICE '========================================';
            RAISE;
    END;
END $$;

\echo '';

-- ============================================================================
-- Version avec transaction manuelle (script interactif)
-- ============================================================================

\echo 'Version alternative avec transaction manuelle:';
\echo '';

-- Afficher état initial
\echo 'État AVANT transaction:';
SELECT product_id, name, stock FROM products WHERE product_id = 1;
SELECT COUNT(*) AS nb_commandes FROM orders;

\echo '';

-- Démarrer transaction
BEGIN;

\echo 'Transaction démarrée...';

-- Variables simulées
\set customer_id 2
\set product_id 2
\set quantity 1

-- Insérer commande
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES (:customer_id, NOW(), 
        (SELECT price FROM products WHERE product_id = :product_id), 
        'PENDING')
RETURNING order_id, total_amount;

\echo '';

-- SAVEPOINT après création commande
SAVEPOINT after_order_creation;

\echo 'SAVEPOINT créé après création commande';
\echo '';

-- Vérifier et décrémenter stock
DO $$
DECLARE
    v_stock INTEGER;
    v_product_id INTEGER := 2;
    v_quantity INTEGER := 1;
BEGIN
    SELECT stock INTO v_stock FROM products WHERE product_id = v_product_id;
    
    IF v_stock < v_quantity THEN
        RAISE EXCEPTION 'Stock insuffisant!';
    END IF;
    
    UPDATE products SET stock = stock - v_quantity WHERE product_id = v_product_id;
    
    RAISE NOTICE 'Stock décrémenté avec succès';
END $$;

\echo '';

-- Valider la transaction
COMMIT;

\echo 'Transaction validée (COMMIT)!';
\echo '';

-- Afficher état final
\echo 'État APRÈS transaction:';
SELECT product_id, name, stock FROM products WHERE product_id = 2;
SELECT order_id, customer_id, total_amount, status 
FROM orders 
ORDER BY order_id DESC 
LIMIT 1;

\echo '';

-- ============================================================================
-- Test avec stock insuffisant (doit échouer et ROLLBACK)
-- ============================================================================

\echo '========================================';
\echo 'Test avec stock insuffisant:';
\echo '';

BEGIN;

\echo 'Tentative de commande avec quantité excessive...';

-- Essayer de commander plus que le stock disponible
DO $$
DECLARE
    v_stock INTEGER;
BEGIN
    SELECT stock INTO v_stock FROM products WHERE product_id = 1;
    
    RAISE NOTICE 'Stock actuel produit 1: %', v_stock;
    
    -- Tenter de commander tout le stock + 100 (doit échouer)
    IF v_stock < 1000 THEN
        RAISE EXCEPTION 'Stock insuffisant! Disponible: %, Demandé: 1000', v_stock;
    END IF;
END $$;

-- Cette ligne ne sera jamais atteinte
COMMIT;

-- Le ROLLBACK est automatique en cas d'erreur dans DO block

\echo '';
\echo '✅ Transaction correctement annulée (ROLLBACK automatique)';
\echo '';
\echo '========================================';
