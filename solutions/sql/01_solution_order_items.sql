-- ===================================================================
-- Solution Exercice 1 : Créer table order_items
-- Fichier exécutable : solutions/sql/01_solution_order_items.sql
-- ===================================================================

-- Créer la table avec toutes les contraintes
CREATE TABLE order_items (
    -- Clé primaire auto-incrémentée
    order_item_id SERIAL PRIMARY KEY,
    
    -- Clés étrangères
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    
    -- Données de la ligne de commande
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    
    -- Contraintes de clés étrangères avec CASCADE
    CONSTRAINT fk_order_items_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(order_id) 
        ON DELETE CASCADE,
    
    CONSTRAINT fk_order_items_product 
        FOREIGN KEY (product_id) 
        REFERENCES products(product_id) 
        ON DELETE CASCADE,
    
    -- Contraintes de validation métier
    CONSTRAINT check_quantity_positive 
        CHECK (quantity > 0),
    
    CONSTRAINT check_unit_price_non_negative 
        CHECK (unit_price >= 0)
);

-- Créer des index sur les clés étrangères pour performance
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Insertion des données de test
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
    (1, 1, 1, 899.99),
    (2, 2, 2, 29.99),
    (3, 3, 1, 79.99),
    (3, 4, 1, 299.99);

-- Vérification
SELECT * FROM order_items;

-- Vérification avec jointures
SELECT 
    oi.order_item_id,
    o.order_id,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_item_id;
