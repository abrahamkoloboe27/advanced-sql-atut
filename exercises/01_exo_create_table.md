# 📝 Exercice 1 : Créer une table order_items (DDL)

**Difficulté** : 🟢 Facile  
**Durée estimée** : 15 minutes  
**Objectif** : Maîtriser CREATE TABLE avec contraintes (PK, FK, CHECK)

---

## 🎯 Contexte

La base `shop_db` contient actuellement 3 tables :
- `customers` (clients)
- `products` (produits)
- `orders` (commandes)

Mais il manque une table pour stocker le **détail des commandes** (quels produits dans quelle commande).

---

## 📋 Votre mission

Créez une table `order_items` qui permettra de lier commandes et produits avec les quantités commandées.

### Spécifications de la table

**Colonnes requises** :
1. `order_item_id` : Clé primaire auto-incrémentée (SERIAL)
2. `order_id` : Référence vers `orders.order_id` (INTEGER, NOT NULL)
3. `product_id` : Référence vers `products.product_id` (INTEGER, NOT NULL)
4. `quantity` : Quantité commandée (INTEGER, NOT NULL)
5. `unit_price` : Prix unitaire au moment de la commande (NUMERIC(10,2), NOT NULL)

### Contraintes à implémenter

- ✅ **Clé primaire** sur `order_item_id`
- ✅ **Clé étrangère** `order_id` → `orders(order_id)` avec `ON DELETE CASCADE`
- ✅ **Clé étrangère** `product_id` → `products(product_id)` avec `ON DELETE CASCADE`
- ✅ **CHECK** : `quantity` doit être > 0
- ✅ **CHECK** : `unit_price` doit être >= 0

---

## 💾 Données de test

Après avoir créé la table, insérez ces lignes de commande :

```sql
-- Commande 1 (order_id=1) : Laptop (1×899.99)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 1, 899.99);

-- Commande 2 (order_id=2) : Souris (2×29.99)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (2, 2, 2, 29.99);

-- Commande 3 (order_id=3) : Clavier (1×79.99) + Écran (1×299.99)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
    (3, 3, 1, 79.99),
    (3, 4, 1, 299.99);
```

---

## ✅ Critères de validation

Votre table doit :
1. Être créée sans erreur
2. Accepter les insertions de test ci-dessus
3. Rejeter une insertion avec `quantity = 0` (violation CHECK)
4. Rejeter une insertion avec `quantity = -1` (violation CHECK)
5. Rejeter une insertion avec `order_id` inexistant (violation FK)
6. Supprimer automatiquement les lignes si la commande est supprimée (CASCADE)

---

## 🧪 Tests à réaliser

```sql
-- Test 1 : Vérifier création
\d order_items

-- Test 2 : Vérifier données insérées
SELECT * FROM order_items;

-- Test 3 : Tester contrainte CHECK (doit échouer)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 0, 100.00);
-- Erreur attendue : violates check constraint "check_quantity_positive"

-- Test 4 : Tester contrainte FK (doit échouer)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (999, 1, 1, 100.00);
-- Erreur attendue : violates foreign key constraint

-- Test 5 : Tester CASCADE (doit supprimer order_items)
BEGIN;
DELETE FROM orders WHERE order_id = 1;
SELECT * FROM order_items WHERE order_id = 1;  -- Doit être vide
ROLLBACK;
```

---

## 💡 Indices

<details>
<summary>Cliquer pour voir la syntaxe de base</summary>

```sql
CREATE TABLE nom_table (
    colonne1 SERIAL PRIMARY KEY,
    colonne2 TYPE CONSTRAINT,
    colonne3 TYPE REFERENCES autre_table(colonne) ON DELETE CASCADE,
    CONSTRAINT nom_check CHECK (condition)
);
```
</details>

<details>
<summary>Besoin d'aide sur les types de données ?</summary>

- `SERIAL` = INTEGER auto-incrémenté
- `INTEGER` = Nombre entier
- `NUMERIC(10,2)` = Nombre décimal (10 chiffres max, 2 après virgule)
- `NOT NULL` = Valeur obligatoire
</details>

---

## 📚 Ressources

- Slide 06 : DDL (CREATE TABLE)
- Documentation PostgreSQL : [CREATE TABLE](https://www.postgresql.org/docs/current/sql-createtable.html)
- Exemple dans : `sql/01_ddl/create_tables.sql`

---

## ✅ Solution

Voir `solutions/01_solution_order_items.md` et `solutions/sql/01_solution_order_items.sql`

---

**Bon courage ! 🚀**
