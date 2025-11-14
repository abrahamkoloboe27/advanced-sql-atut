-- ============================================================================
-- SOLUTION EXERCICE 1 : Créer une nouvelle table (DDL)
-- ============================================================================

\echo '========================================';
\echo 'SOLUTION EXERCICE 1';
\echo '========================================';
\echo '';

-- Créer la table order_items
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    
    -- Contraintes de clés étrangères avec CASCADE
    CONSTRAINT fk_order_items_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) 
        ON DELETE CASCADE,
    
    CONSTRAINT fk_order_items_product 
        FOREIGN KEY (product_id) 
        REFERENCES products(product_id) 
        ON DELETE CASCADE
);

-- Ajouter des commentaires
COMMENT ON TABLE order_items IS 'Détail des produits dans chaque commande';
COMMENT ON COLUMN order_items.quantity IS 'Quantité commandée (doit être > 0)';
COMMENT ON COLUMN order_items.unit_price IS 'Prix unitaire au moment de la commande';

\echo '✅ Table order_items créée avec succès!';
\echo '';

-- Afficher la structure
\d order_items

\echo '';

-- Insérer les données de test
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 899.99),  -- Commande 1 : Laptop
    (1, 2, 1, 29.99),   -- Commande 1 : Souris
    (2, 3, 1, 79.99);   -- Commande 2 : Clavier

\echo '✅ Données de test insérées!';
\echo '';

-- Vérifier
SELECT * FROM order_items;

\echo '';
\echo '========================================';
