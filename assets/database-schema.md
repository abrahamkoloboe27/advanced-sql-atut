# 📊 Schéma de la base de données shop_db

## Vue d'ensemble

```
┌────────────────────────────────────────────────────────────────────────┐
│                          shop_db (PostgreSQL)                          │
└────────────────────────────────────────────────────────────────────────┘
```

## Diagramme Entité-Association

```
┌─────────────────────┐
│     CUSTOMERS       │
├─────────────────────┤
│ PK  customer_id     │──┐
│     first_name      │  │
│     last_name       │  │
│ U   email           │  │
│     created_at      │  │
└─────────────────────┘  │
                         │
                         │ 1
                         │
                         │
                         │ N
                         │
┌─────────────────────┐  │
│       ORDERS        │  │
├─────────────────────┤  │
│ PK  order_id        │  │
│ FK  customer_id     │──┘
│     order_date      │
│     total_amount    │
│     status          │
└─────────────────────┘


┌─────────────────────┐
│      PRODUCTS       │
├─────────────────────┤
│ PK  product_id      │
│     name            │
│     price           │
│     category        │
│     stock           │
└─────────────────────┘
```

**Légende :**
- `PK` = Clé primaire (Primary Key)
- `FK` = Clé étrangère (Foreign Key)
- `U` = Unique
- `──` = Relation (1:N = un à plusieurs)

---

## Tables détaillées

### 1. CUSTOMERS (Clients)

| Colonne       | Type           | Contraintes               | Description                    |
|---------------|----------------|---------------------------|--------------------------------|
| customer_id   | SERIAL         | PRIMARY KEY               | Identifiant unique du client   |
| first_name    | VARCHAR(50)    | NOT NULL                  | Prénom                         |
| last_name     | VARCHAR(50)    | NOT NULL                  | Nom                            |
| email         | VARCHAR(100)   | NOT NULL, UNIQUE          | Email (unique)                 |
| created_at    | TIMESTAMP      | DEFAULT CURRENT_TIMESTAMP | Date de création               |

**Index :**
- `customers_pkey` sur `customer_id` (PK)
- `customers_email_key` sur `email` (UNIQUE)

---

### 2. PRODUCTS (Produits)

| Colonne       | Type           | Contraintes                  | Description                    |
|---------------|----------------|------------------------------|--------------------------------|
| product_id    | SERIAL         | PRIMARY KEY                  | Identifiant unique du produit  |
| name          | VARCHAR(100)   | NOT NULL                     | Nom du produit                 |
| price         | NUMERIC(10,2)  | NOT NULL, CHECK (price > 0)  | Prix unitaire (> 0)            |
| category      | VARCHAR(50)    |                              | Catégorie                      |
| stock         | INTEGER        | DEFAULT 0, CHECK (stock >= 0)| Quantité en stock (>= 0)       |

**Index :**
- `products_pkey` sur `product_id` (PK)

**Contraintes CHECK :**
- `products_price_check` : `price > 0`
- `products_stock_check` : `stock >= 0`

---

### 3. ORDERS (Commandes)

| Colonne       | Type           | Contraintes                          | Description                    |
|---------------|----------------|--------------------------------------|--------------------------------|
| order_id      | SERIAL         | PRIMARY KEY                          | Identifiant unique commande    |
| customer_id   | INTEGER        | NOT NULL, FK → customers             | Référence au client            |
| order_date    | TIMESTAMP      | DEFAULT CURRENT_TIMESTAMP            | Date de commande               |
| total_amount  | NUMERIC(10,2)  | NOT NULL, CHECK (total_amount >= 0)  | Montant total                  |
| status        | VARCHAR(20)    | DEFAULT 'PENDING', CHECK (...)       | Statut de la commande          |

**Index :**
- `orders_pkey` sur `order_id` (PK)

**Clés étrangères :**
- `fk_orders_customer` : `customer_id` → `customers(customer_id)` ON DELETE CASCADE

**Contraintes CHECK :**
- `orders_total_amount_check` : `total_amount >= 0`
- `orders_status_check` : `status IN ('PENDING', 'COMPLETED', 'CANCELLED')`

---

## Relations

### customers → orders (1:N)

- Un client peut avoir plusieurs commandes
- Une commande appartient à un seul client
- `ON DELETE CASCADE` : Si un client est supprimé, ses commandes le sont aussi

---

## Données de seed

### CUSTOMERS (5 lignes)

| customer_id | first_name | last_name | email                      | created_at          |
|-------------|------------|-----------|----------------------------|---------------------|
| 1           | Jean       | Dupont    | jean.dupont@email.fr       | 2024-01-15 10:30:00 |
| 2           | Marie      | Martin    | marie.martin@email.fr      | 2024-02-20 14:15:00 |
| 3           | Pierre     | Durand    | pierre.durand@email.fr     | 2024-03-10 09:45:00 |
| 4           | Sophie     | Leclerc   | sophie.leclerc@email.fr    | 2024-04-05 16:20:00 |
| 5           | Lucas      | Moreau    | lucas.moreau@email.fr      | 2024-05-12 11:00:00 |

### PRODUCTS (6 lignes)

| product_id | name                  | price  | category      | stock |
|------------|-----------------------|--------|---------------|-------|
| 1          | Ordinateur Portable   | 899.99 | Informatique  | 15    |
| 2          | Souris Sans Fil       | 29.99  | Informatique  | 50    |
| 3          | Clavier Mécanique     | 79.99  | Informatique  | 30    |
| 4          | Écran 24 pouces       | 199.99 | Informatique  | 20    |
| 5          | Webcam HD             | 49.99  | Informatique  | 25    |
| 6          | Casque Audio          | 59.99  | Audio         | 40    |

### ORDERS (6 lignes)

| order_id | customer_id | order_date          | total_amount | status     |
|----------|-------------|---------------------|--------------|------------|
| 1        | 1           | 2024-06-01 10:00:00 | 929.98       | COMPLETED  |
| 2        | 2           | 2024-06-05 14:30:00 | 79.99        | COMPLETED  |
| 3        | 3           | 2024-06-10 09:15:00 | 249.98       | COMPLETED  |
| 4        | 1           | 2024-06-15 16:45:00 | 109.98       | COMPLETED  |
| 5        | 4           | 2024-06-20 11:20:00 | 899.99       | PENDING    |
| 6        | 5           | 2024-06-25 13:00:00 | 139.98       | CANCELLED  |

---

## Extension possible : ORDER_ITEMS

Pour une modélisation complète d'un système e-commerce, on peut ajouter une table de jonction :

```
┌─────────────────────┐       ┌─────────────────────┐       ┌─────────────────────┐
│     CUSTOMERS       │       │    ORDER_ITEMS      │       │      PRODUCTS       │
├─────────────────────┤       ├─────────────────────┤       ├─────────────────────┤
│ PK  customer_id     │──┐    │ PK  order_item_id   │    ┌──│ PK  product_id      │
│     first_name      │  │    │ FK  order_id        │    │  │     name            │
│     last_name       │  │    │ FK  product_id      │────┘  │     price           │
│ U   email           │  │    │     quantity        │       │     category        │
│     created_at      │  │    │     unit_price      │       │     stock           │
└─────────────────────┘  │    └─────────────────────┘       └─────────────────────┘
                         │               │
                         │               │
                         │    ┌─────────────────────┐
                         │    │       ORDERS        │
                         │    ├─────────────────────┤
                         └────│ FK  customer_id     │
                              │ PK  order_id        │
                              │     order_date      │
                              │     total_amount    │
                              │     status          │
                              └─────────────────────┘
```

Cette table est créée dans **Exercice 1**.

---

## Statistiques

```sql
-- Nombre de clients
SELECT COUNT(*) FROM customers;  -- 5

-- Nombre de produits
SELECT COUNT(*) FROM products;   -- 6

-- Nombre de commandes
SELECT COUNT(*) FROM orders;     -- 6

-- Chiffre d'affaires (commandes complétées)
SELECT SUM(total_amount) FROM orders WHERE status = 'COMPLETED';  -- 1369.91

-- Valeur du stock
SELECT SUM(price * stock) FROM products;
```

---

## Requêtes utiles

### Top clients
```sql
SELECT 
    c.first_name || ' ' || c.last_name AS client,
    COUNT(o.order_id) AS nb_commandes,
    COALESCE(SUM(o.total_amount), 0) AS total_depense
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_depense DESC;
```

### Produits en rupture
```sql
SELECT name, category, price
FROM products
WHERE stock = 0;
```

### Commandes en attente
```sql
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS client,
    o.order_date,
    o.total_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'PENDING'
ORDER BY o.order_date;
```

---

## Scripts SQL disponibles

- **DDL** : `sql/01_ddl/create_tables.sql`
- **Seed** : `sql/02_dml/insert_seed.sql`
- **Exemples SELECT** : `sql/02_dml/select_queries.sql`
- **Index et vues** : `sql/01_ddl/indexes_views.sql`
