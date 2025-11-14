# 12 - Anatomie d'un SELECT 🔍

## Objectif
Comprendre l'ordre logique vs l'ordre d'exécution d'une requête SELECT pour mieux optimiser vos requêtes.

## Contenu

### 📝 Syntaxe complète d'un SELECT
```sql
SELECT [DISTINCT] colonnes
FROM table1
[JOIN table2 ON condition]
[WHERE condition]
[GROUP BY colonnes]
[HAVING condition]
[ORDER BY colonnes]
[LIMIT n] [OFFSET m];
```

### 🔄 Ordre d'écriture vs Ordre d'exécution

**Ordre dans lequel vous écrivez** :
1. SELECT
2. FROM
3. JOIN
4. WHERE
5. GROUP BY
6. HAVING
7. ORDER BY
8. LIMIT

**Ordre d'exécution réel par PostgreSQL** :
1. **FROM** : Récupère les tables source
2. **JOIN** : Effectue les jointures
3. **WHERE** : Filtre les lignes
4. **GROUP BY** : Groupe les lignes
5. **HAVING** : Filtre les groupes
6. **SELECT** : Projette les colonnes
7. **DISTINCT** : Élimine les doublons
8. **ORDER BY** : Trie les résultats
9. **LIMIT/OFFSET** : Limite le nombre de résultats

### 🎯 Conséquences pratiques

**WHERE vs HAVING** :
- `WHERE` filtre AVANT GROUP BY (lignes individuelles)
- `HAVING` filtre APRÈS GROUP BY (groupes)

**Alias** :
- Utilisables dans ORDER BY, HAVING
- Non utilisables dans WHERE (pas encore calculés)

**Performance** :
- Filtrer tôt (WHERE) = moins de données à traiter
- LIMIT réduit le coût du ORDER BY

## Illustration suggérée
- Diagramme en flux montrant l'ordre d'exécution
- Tableau comparatif ordre d'écriture vs exécution

## Exemple (entrée)

**Table orders**
| order_id | customer_id | total_amount | order_date |
|----------|-------------|--------------|------------|
| 1 | 1 | 150.00 | 2024-01-15 |
| 2 | 1 | 200.00 | 2024-01-20 |
| 3 | 2 | 75.00 | 2024-01-18 |
| 4 | 3 | 300.00 | 2024-02-01 |

## Requête SQL
```sql
-- Requête complète montrant toutes les clauses
SELECT 
    customer_id,
    COUNT(*) AS num_orders,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order
FROM orders
WHERE order_date >= '2024-01-01'          -- 1. Filtre d'abord
GROUP BY customer_id                       -- 2. Puis groupe
HAVING COUNT(*) > 1                        -- 3. Filtre les groupes
ORDER BY total_spent DESC                  -- 4. Trie
LIMIT 2;                                   -- 5. Limite les résultats

-- Ordre d'exécution :
-- FROM orders
-- WHERE order_date >= '2024-01-01' → garde lignes 1,2,3
-- GROUP BY customer_id → crée 2 groupes (customer 1 et 2)
-- HAVING COUNT(*) > 1 → garde seulement customer 1
-- SELECT calcule les agrégats
-- ORDER BY total_spent DESC
-- LIMIT 2
```

## Résultat (table)

| customer_id | num_orders | total_spent | avg_order |
|-------------|------------|-------------|-----------|
| 1 | 2 | 350.00 | 175.00 |

**Explication** :
- WHERE élimine order_id=4 (date postérieure)
- GROUP BY crée 2 groupes (customer 1: 2 commandes, customer 2: 1 commande)
- HAVING élimine customer 2 (< 2 commandes)
- ORDER BY trie (inutile ici, 1 seul résultat)
- LIMIT 2 conserve max 2 lignes

## Notes pour le présentateur
- 🎯 **Message clé** : Comprendre l'ordre d'exécution aide à écrire des requêtes plus efficaces et éviter les erreurs
- **Erreur fréquente** :
  ```sql
  SELECT name, price * 1.2 AS price_with_tax
  FROM products
  WHERE price_with_tax > 100; -- ❌ ERREUR : alias pas encore défini
  
  -- ✅ CORRECT :
  WHERE price * 1.2 > 100;
  ```
- **Optimisation** :
  - Filtrer le plus tôt possible (WHERE avant JOIN si possible)
  - LIMIT avec ORDER BY = PostgreSQL peut optimiser (pas besoin de tout trier)
  - DISTINCT coûte cher → éviter si possible
- **Démo live** :
  1. Montrer erreur d'utilisation d'alias dans WHERE
  2. Comparer EXPLAIN pour WHERE vs HAVING (WHERE filtre avant agrégation)
  3. Montrer que ORDER BY + LIMIT est optimisé (top-N heapsort)
- 💡 **Astuce mnémotechnique** : "From Where, we Group and Have Selection Ordered with Limits"
