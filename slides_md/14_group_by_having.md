# 14 - GROUP BY, HAVING et Fonctions d'Agrégation 📊

## Objectif
Maîtriser les agrégations avec GROUP BY et HAVING pour analyser et résumer les données.

## Contenu

### 🎯 GROUP BY : Regrouper les données
Regroupe les lignes ayant les mêmes valeurs dans les colonnes spécifiées.

**Syntaxe** :
```sql
SELECT colonnes, fonction_agrégat(colonne)
FROM table
GROUP BY colonnes;
```

### 📈 Fonctions d'agrégation

| Fonction | Description | Exemple |
|----------|-------------|---------|
| `COUNT()` | Nombre de lignes | `COUNT(*)` ou `COUNT(column)` |
| `SUM()` | Somme | `SUM(price)` |
| `AVG()` | Moyenne | `AVG(price)` |
| `MIN()` | Minimum | `MIN(price)` |
| `MAX()` | Maximum | `MAX(price)` |
| `STRING_AGG()` | Concaténation (PostgreSQL) | `STRING_AGG(name, ', ')` |
| `ARRAY_AGG()` | Tableau (PostgreSQL) | `ARRAY_AGG(name)` |

### 🔍 HAVING : Filtrer les groupes
Filtre les résultats APRÈS agrégation (contrairement à WHERE qui filtre AVANT).

**Syntaxe** :
```sql
SELECT colonnes, fonction_agrégat(colonne)
FROM table
GROUP BY colonnes
HAVING condition_sur_agrégat;
```

### 🆚 WHERE vs HAVING

| WHERE | HAVING |
|-------|--------|
| Filtre les **lignes** | Filtre les **groupes** |
| Avant GROUP BY | Après GROUP BY |
| Pas de fonctions d'agrégation | Fonctions d'agrégation OK |
| Plus rapide (filtre tôt) | Plus lent (filtre tard) |

### ⚠️ Règles importantes
- Toute colonne dans SELECT (hors agrégats) doit être dans GROUP BY
- HAVING utilise les alias définis dans SELECT
- NULL forme son propre groupe

## Illustration suggérée
- Schéma visuel : données → GROUP BY → agrégation → HAVING
- Tableau comparatif WHERE vs HAVING

## Exemple (entrée)

**Table orders**
| order_id | customer_id | total_amount | status |
|----------|-------------|--------------|--------|
| 1 | 1 | 150.00 | COMPLETED |
| 2 | 1 | 200.00 | COMPLETED |
| 3 | 2 | 75.00 | COMPLETED |
| 4 | 2 | 100.00 | CANCELLED |
| 5 | 3 | 300.00 | COMPLETED |

## Requête SQL
```sql
-- Exemple 1 : Agrégation simple
SELECT 
    customer_id,
    COUNT(*) AS num_orders,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order,
    MIN(total_amount) AS min_order,
    MAX(total_amount) AS max_order
FROM orders
GROUP BY customer_id
ORDER BY total_spent DESC;

-- Exemple 2 : GROUP BY avec WHERE
SELECT 
    customer_id,
    COUNT(*) AS num_completed_orders,
    SUM(total_amount) AS total_completed
FROM orders
WHERE status = 'COMPLETED'  -- Filtre AVANT agrégation
GROUP BY customer_id;

-- Exemple 3 : GROUP BY avec HAVING
SELECT 
    customer_id,
    COUNT(*) AS num_orders,
    SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 2  -- Filtre APRÈS agrégation
ORDER BY total_spent DESC;

-- Exemple 4 : WHERE + HAVING combinés
SELECT 
    customer_id,
    COUNT(*) AS num_completed_orders,
    SUM(total_amount) AS total_completed
FROM orders
WHERE status = 'COMPLETED'        -- Filtre lignes
GROUP BY customer_id
HAVING SUM(total_amount) > 200    -- Filtre groupes
ORDER BY total_completed DESC;
```

## Résultat (table)

**Exemple 1** :
| customer_id | num_orders | total_spent | avg_order | min_order | max_order |
|-------------|------------|-------------|-----------|-----------|-----------|
| 1 | 2 | 350.00 | 175.00 | 150.00 | 200.00 |
| 2 | 2 | 175.00 | 87.50 | 75.00 | 100.00 |
| 3 | 1 | 300.00 | 300.00 | 300.00 | 300.00 |

**Exemple 3** :
| customer_id | num_orders | total_spent |
|-------------|------------|-------------|
| 1 | 2 | 350.00 |
| 2 | 2 | 175.00 |

**Exemple 4** :
| customer_id | num_completed_orders | total_completed |
|-------------|----------------------|-----------------|
| 1 | 2 | 350.00 |
| 3 | 1 | 300.00 |

## Notes pour le présentateur
- 🎯 **Message clé** : GROUP BY transforme plusieurs lignes en une seule ligne par groupe avec statistiques
- **Analogie** : GROUP BY c'est comme créer des sous-totaux dans Excel (par catégorie, par client, etc.)
- **Démonstration live** :
  1. Montrer erreur si colonne non-agrégée pas dans GROUP BY
  2. Comparer WHERE vs HAVING avec EXPLAIN (WHERE filtre avant = plus rapide)
  3. COUNT(*) vs COUNT(colonne) : NULL n'est pas compté dans COUNT(colonne)
- **Erreur fréquente** :
  ```sql
  -- ❌ ERREUR : name pas dans GROUP BY ni fonction d'agrégation
  SELECT customer_id, name, COUNT(*) 
  FROM customers 
  GROUP BY customer_id;
  
  -- ✅ CORRECT :
  SELECT customer_id, COUNT(*) 
  FROM customers 
  GROUP BY customer_id;
  ```
- **Bonnes pratiques** :
  - ✅ Filtrer avec WHERE avant GROUP BY quand possible (performance)
  - ✅ Utiliser HAVING pour conditions sur agrégats (SUM, COUNT, etc.)
  - ✅ Nommer les colonnes agrégées avec AS (lisibilité)
- **Cas réel** : Dashboard e-commerce - ventes par client, par catégorie, par mois
