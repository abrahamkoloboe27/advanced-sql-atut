# 07 - DML : SELECT / INSERT / UPDATE / DELETE 📝

## Objectif
Maîtriser les commandes DML pour manipuler les données dans les tables PostgreSQL.

## Contenu

### 🔍 SELECT - Lire des données
La commande la plus utilisée en SQL.

**Syntaxe de base** :
```sql
SELECT colonnes FROM table WHERE conditions;
```

### ➕ INSERT - Ajouter des données
Insérer de nouvelles lignes dans une table.

**Syntaxes** :
```sql
-- Une ligne
INSERT INTO table (col1, col2) VALUES (val1, val2);

-- Plusieurs lignes
INSERT INTO table (col1, col2) VALUES 
    (val1, val2),
    (val3, val4);
```

### ✏️ UPDATE - Modifier des données
Modifier des lignes existantes.

**Syntaxe** :
```sql
UPDATE table 
SET col1 = val1, col2 = val2 
WHERE condition;
```

**⚠️ DANGER** : Sans WHERE, toutes les lignes sont modifiées !

### 🗑️ DELETE - Supprimer des données
Supprimer des lignes spécifiques.

**Syntaxe** :
```sql
DELETE FROM table WHERE condition;
```

**⚠️ DANGER** : Sans WHERE, toutes les lignes sont supprimées !

### 💡 Clause RETURNING (PostgreSQL)
Retourne les lignes affectées par INSERT/UPDATE/DELETE.

```sql
UPDATE products SET price = price * 1.1 
WHERE category = 'Informatique'
RETURNING name, price;
```

## Illustration suggérée
- Cycle CRUD (Create, Read, Update, Delete)
- Warning visuel pour UPDATE/DELETE sans WHERE

## Exemple (entrée)

**Table products (avant modifications)**
| product_id | name | price | stock |
|------------|------|-------|-------|
| 1 | Laptop | 899.99 | 10 |
| 2 | Souris | 29.99 | 50 |
| 3 | Clavier | 79.99 | 0 |

## Requête SQL
```sql
-- INSERT : Ajouter un nouveau produit
INSERT INTO products (name, price, stock) 
VALUES ('Écran', 299.99, 15)
RETURNING product_id, name, price;

-- SELECT : Lire des données
SELECT name, price FROM products WHERE price > 50;

-- UPDATE : Augmenter le stock de la souris
UPDATE products 
SET stock = stock + 20 
WHERE name = 'Souris'
RETURNING name, stock;

-- DELETE : Supprimer produits en rupture
DELETE FROM products 
WHERE stock = 0
RETURNING name;
```

## Résultat (table)

**Après INSERT** :
| product_id | name | price |
|------------|------|-------|
| 4 | Écran | 299.99 |

**Après SELECT** :
| name | price |
|------|-------|
| Laptop | 899.99 |
| Clavier | 79.99 |
| Écran | 299.99 |

**Après UPDATE** :
| name | stock |
|------|-------|
| Souris | 70 |

**Après DELETE** :
| name |
|------|
| Clavier |

## Notes pour le présentateur
- 🎯 **Message clé** : DML = 80% de votre utilisation quotidienne de SQL
- **Bonnes pratiques** :
  - ✅ Toujours tester UPDATE/DELETE avec SELECT avant
  - ✅ Utiliser transactions pour modifications critiques
  - ✅ Spécifier les colonnes dans INSERT (pas `INSERT INTO table VALUES (...)`)
  - ✅ Utiliser RETURNING pour vérifier les modifications
- **Démo live** :
  1. Montrer UPDATE sans WHERE (en transaction avec ROLLBACK)
  2. Comparer temps INSERT (1 ligne) vs INSERT (100 lignes en un coup)
  3. Utiliser RETURNING pour voir immédiatement le résultat
- ⚠️ **Sécurité** : Toujours valider les WHERE (ne jamais construire SQL avec concaténation de strings - risque d'injection SQL)
- **Fun fact** : SELECT représente 70-90% des requêtes en production
