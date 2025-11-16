# 17 - CTE vs Subqueries : WITH vs Nested Queries 📦

## Objectif
Comprendre les Common Table Expressions (CTE) et les comparer aux sous-requêtes pour écrire des requêtes complexes lisibles.

## Contenu

### 🎯 CTE - Common Table Expression
Une **CTE** est une requête temporaire nommée, définie avec `WITH`.

**Syntaxe** :
```sql
WITH nom_cte AS (
    SELECT ...
)
SELECT * FROM nom_cte;
```

**Avantages** :
- ✅ **Lisibilité** : Code séquentiel, facile à comprendre
- ✅ **Réutilisation** : Référencer plusieurs fois la même CTE
- ✅ **Debugging** : Tester chaque CTE séparément
- ✅ **CTE récursives** : Possibles (arbres, graphes)

### 🔄 Subqueries (sous-requêtes)
Une **subquery** est une requête imbriquée dans une autre.

**Types** :
1. **Scalaire** : Retourne une seule valeur
2. **Ligne** : Retourne une ligne
3. **Table** : Retourne plusieurs lignes (utilisée avec IN, EXISTS)

**Syntaxe** :
```sql
-- Subquery dans FROM
SELECT * FROM (SELECT ...) AS alias;

-- Subquery dans WHERE
SELECT * FROM table1 WHERE col IN (SELECT col FROM table2);
```

### 🆚 CTE vs Subqueries

| Aspect | CTE | Subquery |
|--------|-----|----------|
| Lisibilité | ⭐⭐⭐ Excellent | ⭐⭐ Moyen |
| Réutilisation | ✅ Oui (multiple fois) | ❌ Non (copier-coller) |
| Performance | ≈ Équivalente (optimiseur décide) | ≈ Équivalente |
| Récursion | ✅ Possible | ❌ Impossible |
| Debugging | ⭐⭐⭐ Facile à isoler | ⭐ Difficile |

**Recommandation** : Préférer CTE pour requêtes complexes (lisibilité).

### 🔁 CTE multiples
```sql
WITH 
    cte1 AS (SELECT ...),
    cte2 AS (SELECT ... FROM cte1)
SELECT * FROM cte2;
```

## Illustration suggérée
- Comparaison visuelle : CTE (verticale, étapes) vs Subquery (imbriquée)
- Diagramme de flux CTE → CTE → SELECT final

## Exemple (entrée)

**Table orders**
| order_id | customer_id | total_amount | status |
|----------|-------------|--------------|--------|
| 1 | 1 | 150.00 | COMPLETED |
| 2 | 1 | 200.00 | COMPLETED |
| 3 | 2 | 75.00 | COMPLETED |
| 4 | 3 | 300.00 | CANCELLED |

## Requête SQL
```sql
-- Approche 1 : SUBQUERY (imbriquée)
SELECT 
    customer_id,
    total_spent
FROM (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY customer_id
) AS customer_totals
WHERE total_spent > 200;

-- Approche 2 : CTE (plus lisible)
WITH customer_totals AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spent
    FROM orders
    WHERE status = 'COMPLETED'
    GROUP BY customer_id
)
SELECT 
    customer_id,
    total_spent
FROM customer_totals
WHERE total_spent > 200;

-- Approche 3 : CTE multiples (pipeline de transformations)
WITH 
    -- Étape 1 : Commandes complétées
    completed_orders AS (
        SELECT * FROM orders WHERE status = 'COMPLETED'
    ),
    -- Étape 2 : Totaux par client
    customer_totals AS (
        SELECT 
            customer_id,
            COUNT(*) AS num_orders,
            SUM(total_amount) AS total_spent,
            AVG(total_amount) AS avg_order
        FROM completed_orders
        GROUP BY customer_id
    ),
    -- Étape 3 : Clients VIP
    vip_customers AS (
        SELECT * FROM customer_totals WHERE total_spent > 200
    )
SELECT * FROM vip_customers;

-- Exemple 4 : CTE réutilisée (impossible avec subquery)
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', order_date) AS month,
        SUM(total_amount) AS sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT 
    a.month,
    a.sales AS current_sales,
    b.sales AS previous_sales,
    a.sales - b.sales AS growth
FROM monthly_sales a
LEFT JOIN monthly_sales b ON a.month = b.month + INTERVAL '1 month';
```

## Résultat (table)

**Approches 1 et 2 (résultat identique)** :
| customer_id | total_spent |
|-------------|-------------|
| 1 | 350.00 |

**Approche 3 (CTE multiples)** :
| customer_id | num_orders | total_spent | avg_order |
|-------------|------------|-------------|-----------|
| 1 | 2 | 350.00 | 175.00 |

## Notes pour le présentateur
- 🎯 **Message clé** : CTE = requêtes complexes rendues lisibles et maintenables (comme des variables temporaires)
- **Analogie** : CTE = Décomposer un calcul complexe en étapes intermédiaires nommées
  ```python
  # Python avec variables
  completed = filter_completed(orders)
  totals = group_by_customer(completed)
  vips = filter_vips(totals)
  
  # SQL avec CTE
  WITH completed AS (...), totals AS (...), vips AS (...)
  ```
- **Démonstration live** :
  1. Montrer requête complexe avec subqueries imbriquées (difficile à lire)
  2. Refactorer en CTE (étapes claires)
  3. Tester chaque CTE séparément (`SELECT * FROM customer_totals;`)
  4. Exemple de CTE récursive (hiérarchie de catégories)
- **Bonnes pratiques** :
  - ✅ Utiliser CTE pour requêtes > 2 niveaux de complexité
  - ✅ Nommer les CTE de façon descriptive (pas "cte1", "temp")
  - ✅ Commenter chaque CTE pour expliquer sa logique
  - ⚠️ Éviter trop de CTE (> 5-6) → envisager vues ou fonctions
- **Performance** : PostgreSQL peut matérialiser ou non la CTE (optimiseur décide). Forcer avec `MATERIALIZED` ou `NOT MATERIALIZED`
- **Cas réel** : Analyses complexes (churn, RFM scoring, cohort analysis)
