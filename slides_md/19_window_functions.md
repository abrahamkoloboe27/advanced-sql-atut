# 19 - Window Functions : ROW_NUMBER, RANK, LAG, LEAD 🪟

## Objectif
Maîtriser les fonctions fenêtres (window functions) pour effectuer des calculs sur des ensembles de lignes sans regroupement.

## Contenu

### 🎯 C'est quoi une Window Function ?
Fonction qui opère sur un **ensemble de lignes** (fenêtre) liées à la ligne courante, SANS regrouper les résultats.

**Différence avec GROUP BY** :
- GROUP BY : Réduit N lignes → 1 ligne par groupe
- Window Function : Garde N lignes, ajoute colonnes calculées

**Syntaxe** :
```sql
fonction_fenetre() OVER (
    [PARTITION BY colonnes]
    [ORDER BY colonnes]
    [ROWS ou RANGE ...]
)
```

### 📊 Fonctions de classement

| Fonction | Description | Gestion ex-aequo |
|----------|-------------|------------------|
| `ROW_NUMBER()` | Numéro séquentiel unique | 1, 2, 3, 4 |
| `RANK()` | Rang avec gaps | 1, 2, 2, 4 |
| `DENSE_RANK()` | Rang sans gaps | 1, 2, 2, 3 |
| `NTILE(n)` | Diviser en n groupes | Quartiles, déciles |

### 🔄 Fonctions de navigation

| Fonction | Description |
|----------|-------------|
| `LAG(col, n)` | Valeur n lignes avant |
| `LEAD(col, n)` | Valeur n lignes après |
| `FIRST_VALUE(col)` | Première valeur de la fenêtre |
| `LAST_VALUE(col)` | Dernière valeur de la fenêtre |

### 📈 Fonctions d'agrégation fenêtrées
Toutes les agrégations (SUM, AVG, COUNT, etc.) peuvent être fenêtrées.

```sql
SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date)
-- Cumul par client, dans l'ordre chronologique
```

## Illustration suggérée
- Tableau visuel montrant différence ROW_NUMBER / RANK / DENSE_RANK
- Timeline avec LAG/LEAD

## Exemple (entrée)

**Table sales**
| sale_id | product | amount | sale_date |
|---------|---------|--------|-----------|
| 1 | Laptop | 899.99 | 2024-01-15 |
| 2 | Souris | 29.99 | 2024-01-16 |
| 3 | Laptop | 899.99 | 2024-01-20 |
| 4 | Clavier | 79.99 | 2024-02-01 |

## Requête SQL
```sql
-- Exemple 1 : ROW_NUMBER, RANK, DENSE_RANK
WITH product_sales AS (
    SELECT 
        product,
        amount,
        ROW_NUMBER() OVER (ORDER BY amount DESC) AS row_num,
        RANK() OVER (ORDER BY amount DESC) AS rank,
        DENSE_RANK() OVER (ORDER BY amount DESC) AS dense_rank
    FROM sales
)
SELECT * FROM product_sales;

-- Exemple 2 : Top 3 ventes par produit (avec PARTITION BY)
WITH ranked_sales AS (
    SELECT 
        product,
        amount,
        sale_date,
        ROW_NUMBER() OVER (
            PARTITION BY product 
            ORDER BY amount DESC
        ) AS rank_in_product
    FROM sales
)
SELECT * FROM ranked_sales WHERE rank_in_product <= 3;

-- Exemple 3 : LAG et LEAD (évolution des ventes)
SELECT 
    sale_date,
    amount,
    LAG(amount, 1) OVER (ORDER BY sale_date) AS prev_sale,
    LEAD(amount, 1) OVER (ORDER BY sale_date) AS next_sale,
    amount - LAG(amount, 1) OVER (ORDER BY sale_date) AS diff_vs_prev
FROM sales;

-- Exemple 4 : Cumul (running total)
SELECT 
    sale_date,
    amount,
    SUM(amount) OVER (ORDER BY sale_date) AS running_total,
    AVG(amount) OVER (ORDER BY sale_date) AS running_avg
FROM sales;

-- Exemple 5 : Top-N par catégorie
WITH ranked_products AS (
    SELECT 
        category,
        name,
        price,
        RANK() OVER (PARTITION BY category ORDER BY price DESC) AS price_rank
    FROM products
)
SELECT category, name, price
FROM ranked_products
WHERE price_rank <= 3;
```

## Résultat (table)

**Exemple 1** :
| product | amount | row_num | rank | dense_rank |
|---------|--------|---------|------|------------|
| Laptop | 899.99 | 1 | 1 | 1 |
| Laptop | 899.99 | 2 | 1 | 1 |
| Clavier | 79.99 | 3 | 3 | 2 |
| Souris | 29.99 | 4 | 4 | 3 |

**Exemple 3** :
| sale_date | amount | prev_sale | next_sale | diff_vs_prev |
|-----------|--------|-----------|-----------|--------------|
| 2024-01-15 | 899.99 | NULL | 29.99 | NULL |
| 2024-01-16 | 29.99 | 899.99 | 899.99 | -870.00 |
| 2024-01-20 | 899.99 | 29.99 | 79.99 | 870.00 |
| 2024-02-01 | 79.99 | 899.99 | NULL | -820.00 |

**Exemple 4** :
| sale_date | amount | running_total | running_avg |
|-----------|--------|---------------|-------------|
| 2024-01-15 | 899.99 | 899.99 | 899.99 |
| 2024-01-16 | 29.99 | 929.98 | 464.99 |
| 2024-01-20 | 899.99 | 1829.97 | 609.99 |
| 2024-02-01 | 79.99 | 1909.96 | 477.49 |

## Notes pour le présentateur
- 🎯 **Message clé** : Window functions = puissance des agrégations SANS perdre le détail des lignes
- **Analogie** : Comme Excel avec références relatives (ligne précédente, cumul, rang)
- **Démonstration live** :
  1. Comparer GROUP BY (perd détail) vs Window (garde détail)
  2. Top-N par catégorie (impossible avec GROUP BY seul)
  3. Running total pour graphique cumulatif
  4. LAG pour calculer croissance MoM (month-over-month)
- **Cas d'usage** :
  - 🎯 Top-N par catégorie/région/période
  - 📈 Calcul de tendances (croissance, moving average)
  - 🏆 Classements (leaderboards)
  - 💰 Cumuls (ventes cumulées, budget restant)
  - 🔄 Comparaisons temporelles (vs mois précédent)
- **Performance** :
  - Window functions peuvent être coûteuses (tri, partitionnement)
  - Utiliser index sur colonnes de PARTITION BY et ORDER BY
  - MATERIALIZED VIEW pour résultats pré-calculés
- **Piège fréquent** :
  - Oublier ORDER BY dans la fenêtre → résultats imprévisibles
  - Confondre RANK et DENSE_RANK
- **Bonnes pratiques** :
  - ✅ Utiliser CTE pour isoler la window function (lisibilité)
  - ✅ Nommer clairement les colonnes calculées
  - ✅ Tester avec petits datasets d'abord
