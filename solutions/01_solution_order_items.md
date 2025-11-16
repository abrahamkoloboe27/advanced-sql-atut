# ✅ Solution Exercice 1 : Créer table order_items

## 📋 Rappel de l'énoncé

Créer une table `order_items` avec :
- Clé primaire `order_item_id`
- Clés étrangères vers `orders` et `products`
- Contraintes CHECK sur `quantity` et `unit_price`
- ON DELETE CASCADE

---

## 💻 Solution complète

```sql
-- ===================================================================
-- Solution Exercice 1 : Créer table order_items
-- ===================================================================

-- Créer la table avec toutes les contraintes
CREATE TABLE order_items (
    -- Clé primaire auto-incrémentée
    order_item_id SERIAL PRIMARY KEY,
    
    -- Clés étrangères (NOT NULL obligatoire pour cohérence)
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

-- Créer des index sur les clés étrangères (performance)
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- ===================================================================
-- Insertion des données de test
-- ===================================================================

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
    -- Commande 1 : Laptop
    (1, 1, 1, 899.99),
    
    -- Commande 2 : Souris x2
    (2, 2, 2, 29.99),
    
    -- Commande 3 : Clavier + Écran
    (3, 3, 1, 79.99),
    (3, 4, 1, 299.99);

-- ===================================================================
-- Vérification
-- ===================================================================

-- Afficher structure de la table
\d order_items

-- Afficher les données
SELECT * FROM order_items;

-- Vérifier les contraintes avec une jointure
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
```

---

## 🧪 Tests de validation

```sql
-- ===================================================================
-- Test 1 : Contrainte CHECK sur quantity (doit échouer)
-- ===================================================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 0, 100.00);
-- Erreur attendue : new row for relation "order_items" violates check constraint "check_quantity_positive"

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 1, -5, 100.00);
-- Erreur attendue : violates check constraint

-- ===================================================================
-- Test 2 : Contrainte CHECK sur unit_price (doit échouer)
-- ===================================================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 1, -10.00);
-- Erreur attendue : violates check constraint "check_unit_price_non_negative"

-- ===================================================================
-- Test 3 : Contrainte FK order_id (doit échouer)
-- ===================================================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (9999, 1, 1, 100.00);
-- Erreur attendue : insert or update on table "order_items" violates foreign key constraint

-- ===================================================================
-- Test 4 : Contrainte FK product_id (doit échouer)
-- ===================================================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 9999, 1, 100.00);
-- Erreur attendue : violates foreign key constraint

-- ===================================================================
-- Test 5 : ON DELETE CASCADE (doit fonctionner)
-- ===================================================================
BEGIN;

-- Vérifier état initial
SELECT COUNT(*) FROM order_items WHERE order_id = 1;  -- 1 ligne

-- Supprimer la commande
DELETE FROM orders WHERE order_id = 1;

-- Vérifier suppression en cascade
SELECT COUNT(*) FROM order_items WHERE order_id = 1;  -- 0 ligne (supprimé !)

ROLLBACK;  -- Annuler pour garder les données

-- ===================================================================
-- Test 6 : Requête métier (total commande)
-- ===================================================================
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(oi.order_item_id) AS num_items,
    SUM(oi.quantity * oi.unit_price) AS calculated_total,
    o.total_amount AS stored_total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.first_name, c.last_name, o.total_amount
ORDER BY o.order_id;
```

---

## 📝 Explications

### Pourquoi SERIAL PRIMARY KEY ?

`SERIAL` est un raccourci PostgreSQL pour :
```sql
order_item_id INTEGER PRIMARY KEY DEFAULT nextval('order_items_order_item_id_seq')
```

C'est plus simple et idiomatique.

### Pourquoi nommer les contraintes ?

```sql
CONSTRAINT fk_order_items_order ...
```

Avantages :
- Nom explicite dans les erreurs
- Facile à supprimer/modifier : `ALTER TABLE DROP CONSTRAINT fk_order_items_order`
- Meilleure documentation

### Pourquoi ON DELETE CASCADE ?

Si une commande est supprimée, ses lignes de commande n'ont plus de sens → suppression automatique.

**Alternative** : `ON DELETE RESTRICT` (empêche suppression si lignes existent)

### Pourquoi les index sur FK ?

PostgreSQL ne crée PAS automatiquement d'index sur les clés étrangères (contrairement à MySQL).

Les index accélèrent :
- JOIN entre tables
- DELETE avec CASCADE (chercher lignes à supprimer)

### Pourquoi quantity > 0 et non >= 0 ?

Commander 0 produit n'a pas de sens métier → contrainte `> 0`.

Pour `unit_price`, 0 est acceptable (produit gratuit, promo) → contrainte `>= 0`.

---

## 🎯 Points clés à retenir

1. ✅ **SERIAL** pour auto-increment
2. ✅ **NOT NULL** sur colonnes obligatoires
3. ✅ **FOREIGN KEY** avec ON DELETE CASCADE pour intégrité
4. ✅ **CHECK** pour validations métier
5. ✅ **Nommer les contraintes** pour lisibilité
6. ✅ **Index sur FK** pour performance
7. ✅ **Tester toutes les contraintes** après création

---

## 🚀 Pour aller plus loin

- Ajouter colonne `created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP`
- Ajouter contrainte UNIQUE sur `(order_id, product_id)` pour éviter doublons
- Créer une vue `order_details` avec toutes les infos (client, produits, totaux)
- Ajouter trigger pour vérifier que `unit_price` correspond au prix produit actuel

---

**Bravo ! 🎉**
