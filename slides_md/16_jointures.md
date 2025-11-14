# 16 - Jointures : INNER, LEFT, RIGHT, FULL, CROSS 🔗

## Objectif
Maîtriser les différents types de jointures pour combiner des données de plusieurs tables.

## Contenu

### 🎯 Pourquoi les jointures ?
Les jointures permettent de combiner des lignes de plusieurs tables basées sur une relation (clé primaire ↔ clé étrangère).

### 📊 Types de jointures

**1️⃣ INNER JOIN** : Intersection (lignes présentes dans TOUTES les tables)
```sql
SELECT * FROM table1
INNER JOIN table2 ON table1.id = table2.table1_id;
```

**2️⃣ LEFT JOIN** : Toutes les lignes de gauche + correspondances de droite
```sql
SELECT * FROM table1
LEFT JOIN table2 ON table1.id = table2.table1_id;
```
→ Si pas de correspondance : colonnes de table2 = NULL

**3️⃣ RIGHT JOIN** : Toutes les lignes de droite + correspondances de gauche
```sql
SELECT * FROM table1
RIGHT JOIN table2 ON table1.id = table2.table1_id;
```
→ Équivaut à `LEFT JOIN` avec tables inversées

**4️⃣ FULL OUTER JOIN** : Union (toutes les lignes des 2 tables)
```sql
SELECT * FROM table1
FULL OUTER JOIN table2 ON table1.id = table2.table1_id;
```
→ NULL des deux côtés si pas de correspondance

**5️⃣ CROSS JOIN** : Produit cartésien (toutes les combinaisons)
```sql
SELECT * FROM table1 CROSS JOIN table2;
```
→ Rarement utilisé (explosion de lignes)

### 🔍 Trouver les non-correspondances
```sql
-- Lignes de table1 SANS correspondance dans table2
SELECT * FROM table1
LEFT JOIN table2 ON table1.id = table2.table1_id
WHERE table2.id IS NULL;
```

## Illustration suggérée
- Diagrammes de Venn pour chaque type de jointure
- Tableau visuel montrant résultats de chaque jointure

## Exemple (entrée)

**Table customers**
| customer_id | name |
|-------------|------|
| 1 | Alice |
| 2 | Bob |
| 3 | Charlie |

**Table orders**
| order_id | customer_id | amount |
|----------|-------------|--------|
| 101 | 1 | 150.00 |
| 102 | 1 | 200.00 |
| 103 | 2 | 75.00 |

## Requête SQL
```sql
-- 1. INNER JOIN : Clients ayant passé commande
SELECT 
    c.name,
    o.order_id,
    o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- 2. LEFT JOIN : Tous les clients (+ commandes si existantes)
SELECT 
    c.name,
    o.order_id,
    COALESCE(o.amount, 0) AS amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 3. Clients SANS commande (LEFT JOIN + WHERE NULL)
SELECT 
    c.customer_id,
    c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 4. Jointure multiple (3 tables)
-- Supposons une table products
SELECT 
    c.name AS customer_name,
    o.order_id,
    p.name AS product_name
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;
```

## Résultat (table)

**INNER JOIN** :
| name | order_id | amount |
|------|----------|--------|
| Alice | 101 | 150.00 |
| Alice | 102 | 200.00 |
| Bob | 103 | 75.00 |

**LEFT JOIN** :
| name | order_id | amount |
|------|----------|--------|
| Alice | 101 | 150.00 |
| Alice | 102 | 200.00 |
| Bob | 103 | 75.00 |
| Charlie | NULL | 0 |

**Clients sans commande** :
| customer_id | name |
|-------------|------|
| 3 | Charlie |

## Notes pour le présentateur
- 🎯 **Message clé** : INNER JOIN = intersection, LEFT JOIN = tout à gauche + correspondances, FULL JOIN = union complète
- **Analogie** : 
  - INNER JOIN = Amis communs sur Facebook
  - LEFT JOIN = Tous vos amis + leurs posts (s'ils en ont)
  - FULL JOIN = Tous les utilisateurs + toutes les publications
- **Démonstration live** :
  1. Comparer visually INNER vs LEFT JOIN avec mêmes tables
  2. Montrer explosion de lignes avec CROSS JOIN (éviter !)
  3. Trouver produits jamais commandés (LEFT JOIN + WHERE NULL)
- **Erreurs fréquentes** :
  - Oublier ON (→ CROSS JOIN implicite)
  - Confondre WHERE et ON dans LEFT JOIN
  ```sql
  -- ❌ ERREUR : WHERE élimine les NULL → équivaut à INNER JOIN
  LEFT JOIN orders o ON c.customer_id = o.customer_id
  WHERE o.status = 'COMPLETED'
  
  -- ✅ CORRECT :
  LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.status = 'COMPLETED'
  ```
- **Bonnes pratiques** :
  - ✅ Toujours utiliser des alias de tables (c, o, p) pour lisibilité
  - ✅ Préférer INNER JOIN par défaut (plus performant)
  - ✅ Utiliser LEFT JOIN pour trouver données manquantes
  - ⚠️ Éviter RIGHT JOIN (confusing, utiliser LEFT avec tables inversées)
- **Cas réel** : Dashboard client - nom, nombre de commandes, total dépensé (JOIN customers + orders + agrégations)
