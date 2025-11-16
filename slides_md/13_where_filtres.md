# 13 - WHERE : Filtres, Opérateurs et NULL 🔎

## Objectif
Maîtriser la clause WHERE et ses opérateurs pour filtrer efficacement les données, y compris le traitement des valeurs NULL.

## Contenu

### 🎯 Clause WHERE
Filtre les lignes selon une ou plusieurs conditions.

**Syntaxe** :
```sql
SELECT colonnes FROM table WHERE condition;
```

### 🔧 Opérateurs de comparaison
| Opérateur | Signification | Exemple |
|-----------|---------------|---------|
| `=` | Égal | `price = 100` |
| `<>` ou `!=` | Différent | `status <> 'CANCELLED'` |
| `>` | Supérieur | `stock > 0` |
| `>=` | Supérieur ou égal | `age >= 18` |
| `<` | Inférieur | `price < 50` |
| `<=` | Inférieur ou égal | `quantity <= 10` |

### 🔗 Opérateurs logiques
- `AND` : Toutes les conditions doivent être vraies
- `OR` : Au moins une condition doit être vraie
- `NOT` : Inverse la condition

**Priorité** : NOT > AND > OR (utiliser parenthèses pour clarifier)

### 📋 Opérateurs spéciaux

**BETWEEN** : Plage de valeurs (inclusif)
```sql
WHERE price BETWEEN 10 AND 100  -- Équivaut à: price >= 10 AND price <= 100
```

**IN** : Liste de valeurs
```sql
WHERE category IN ('Informatique', 'Électronique')
```

**LIKE** : Correspondance de motif (texte)
- `%` : N'importe quelle séquence de caractères
- `_` : Un seul caractère
```sql
WHERE email LIKE '%@gmail.com'  -- Emails Gmail
WHERE name LIKE 'A%'            -- Noms commençant par A
```

**IS NULL / IS NOT NULL** : Vérifier les valeurs nulles
```sql
WHERE phone IS NULL      -- Pas de téléphone
WHERE phone IS NOT NULL  -- A un téléphone
```

### ⚠️ Piège avec NULL
```sql
WHERE price = NULL   -- ❌ Toujours faux (NULL n'est jamais égal à NULL)
WHERE price IS NULL  -- ✅ Correct
```

**NULL dans les comparaisons** :
- `NULL = NULL` → NULL (pas TRUE)
- `NULL AND TRUE` → NULL
- `NULL OR TRUE` → TRUE

## Illustration suggérée
- Tableau des opérateurs avec exemples
- Diagramme de Venn pour AND/OR
- Warning visuel sur NULL

## Exemple (entrée)

**Table products**
| product_id | name | price | category | stock |
|------------|------|-------|----------|-------|
| 1 | Laptop | 899.99 | Informatique | 10 |
| 2 | Souris | 29.99 | Informatique | 0 |
| 3 | Cahier | NULL | Papeterie | 50 |
| 4 | Clavier | 79.99 | Informatique | 25 |

## Requête SQL
```sql
-- Exemple 1 : Opérateurs simples
SELECT name, price FROM products
WHERE category = 'Informatique' AND stock > 0;

-- Exemple 2 : BETWEEN et IN
SELECT name, price FROM products
WHERE price BETWEEN 20 AND 100
  AND category IN ('Informatique', 'Électronique');

-- Exemple 3 : LIKE (recherche textuelle)
SELECT name FROM products
WHERE name LIKE '%ier%';  -- Contient "ier"

-- Exemple 4 : NULL handling
SELECT name, price FROM products
WHERE price IS NULL;

-- Exemple 5 : COALESCE (remplacer NULL)
SELECT name, COALESCE(price, 0) AS price FROM products;

-- Exemple 6 : Combinaison complexe
SELECT name, price, stock FROM products
WHERE (category = 'Informatique' OR category = 'Électronique')
  AND (stock = 0 OR price > 50)
  AND price IS NOT NULL;
```

## Résultat (table)

**Exemple 1** :
| name | price |
|------|-------|
| Laptop | 899.99 |
| Clavier | 79.99 |

**Exemple 3** :
| name |
|------|
| Cahier |
| Clavier |

**Exemple 4** :
| name | price |
|------|-------|
| Cahier | NULL |

**Exemple 5** :
| name | price |
|------|-------|
| Laptop | 899.99 |
| Souris | 29.99 |
| Cahier | 0 |
| Clavier | 79.99 |

## Notes pour le présentateur
- 🎯 **Message clé** : WHERE filtre les données AVANT traitement → crucial pour performance
- **Erreurs fréquentes** :
  - Oublier IS NULL (utiliser `= NULL`)
  - Oublier parenthèses avec AND/OR mixtes
  - Utiliser LIKE sans index (lent sur grosses tables)
- **Démonstration live** :
  1. Montrer que `WHERE price = NULL` ne retourne rien
  2. Comparer temps d'exécution avec/sans WHERE (EXPLAIN ANALYZE)
  3. Montrer LIKE 'A%' (rapide avec index) vs LIKE '%A%' (lent, full scan)
- **Bonnes pratiques** :
  - ✅ Toujours utiliser IS NULL / IS NOT NULL pour tester NULL
  - ✅ Filtrer sur colonnes indexées quand possible
  - ✅ Utiliser BETWEEN au lieu de `>= AND <=` (plus lisible)
  - ⚠️ LIKE '%pattern%' ne peut pas utiliser index B-tree (besoin de GIN)
- **Cas réel** : Recherche produits disponibles (stock > 0) dans une catégorie avec prix dans une fourchette
