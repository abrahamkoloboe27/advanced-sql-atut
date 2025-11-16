# 20 - EXPLAIN & EXPLAIN ANALYZE : Lire un Plan d'Exécution 📊

## Objectif
Apprendre à utiliser EXPLAIN et EXPLAIN ANALYZE pour comprendre et optimiser les performances des requêtes SQL.

## Contenu

### 🎯 EXPLAIN : Plan d'exécution prévu
Affiche le plan que PostgreSQL prévoit d'utiliser SANS exécuter la requête.

**Syntaxe** :
```sql
EXPLAIN SELECT ...;
```

**Informations fournies** :
- Type de scan (Seq Scan, Index Scan, Bitmap Scan...)
- Coût estimé (startup cost, total cost)
- Lignes estimées
- Largeur estimée (bytes par ligne)

### 🚀 EXPLAIN ANALYZE : Exécution réelle
Exécute la requête ET affiche les statistiques réelles.

**Syntaxe** :
```sql
EXPLAIN ANALYZE SELECT ...;
```

**⚠️ ATTENTION** : La requête est vraiment exécutée !
- INSERT/UPDATE/DELETE modifient les données
- Utiliser dans une transaction avec ROLLBACK pour tester

### 📊 Types de scans

| Type | Description | Quand l'utiliser |
|------|-------------|------------------|
| **Seq Scan** | Lecture séquentielle complète | Petite table ou pas d'index |
| **Index Scan** | Lecture via index | WHERE sur colonne indexée |
| **Index Only Scan** | Données dans l'index | SELECT colonnes de l'index |
| **Bitmap Scan** | Scan bitmap puis heap | Conditions multiples |
| **Nested Loop** | Boucle imbriquée (join) | Petites tables |
| **Hash Join** | Jointure par hachage | Grandes tables |
| **Merge Join** | Jointure par tri | Données triées |

### 🔍 Interpréter le plan

**Coûts** :
- Format : `cost=startup..total`
- Unité : Arbitraire (page I/O ≈ 1.0)
- Plus bas = mieux

**Temps** (ANALYZE only) :
- `actual time=first..last`
- En millisecondes
- Comparer à coût estimé

**Rows** :
- `rows=N` (estimé) vs `actual rows=N`
- Grosse différence → statistiques obsolètes (ANALYZE table)

## Illustration suggérée
- Exemple de plan annoté avec explications
- Comparaison Seq Scan vs Index Scan visuellement

## Exemple (entrée)

**Table products (100 000 lignes)**
| product_id | name | category | price |
|------------|------|----------|-------|
| 1 | Laptop | Informatique | 899.99 |
| ... | ... | ... | ... |

## Requête SQL
```sql
-- Exemple 1 : EXPLAIN simple
EXPLAIN 
SELECT * FROM products WHERE category = 'Informatique';

-- Résultat :
-- Seq Scan on products  (cost=0.00..2500.00 rows=1000 width=50)
--   Filter: (category = 'Informatique'::text)

-- Exemple 2 : EXPLAIN ANALYZE
EXPLAIN ANALYZE
SELECT * FROM products WHERE category = 'Informatique';

-- Résultat :
-- Seq Scan on products  (cost=0.00..2500.00 rows=1000 width=50)
--                        (actual time=0.015..45.230 rows=1024 loops=1)
--   Filter: (category = 'Informatique'::text)
--   Rows Removed by Filter: 98976
-- Planning Time: 0.123 ms
-- Execution Time: 45.567 ms

-- Exemple 3 : Après création d'index
CREATE INDEX idx_category ON products(category);

EXPLAIN ANALYZE
SELECT * FROM products WHERE category = 'Informatique';

-- Résultat :
-- Index Scan using idx_category on products
--   (cost=0.42..150.00 rows=1000 width=50)
--   (actual time=0.025..2.156 rows=1024 loops=1)
--   Index Cond: (category = 'Informatique'::text)
-- Planning Time: 0.234 ms
-- Execution Time: 2.345 ms  ← 20x plus rapide !

-- Exemple 4 : EXPLAIN avec jointure
EXPLAIN ANALYZE
SELECT c.name, COUNT(*) 
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.name;

-- Exemple 5 : Format JSON (pour outils)
EXPLAIN (ANALYZE, FORMAT JSON)
SELECT * FROM products WHERE price > 100;
```

## Résultat (table)

**Comparaison performance** :
| Méthode | Type Scan | Temps (ms) | Amélioration |
|---------|-----------|------------|--------------|
| Sans index | Seq Scan | 45.567 | - |
| Avec index | Index Scan | 2.345 | 🚀 19x |

**Indicateurs clés** :
- **rows estimé ≈ actual rows** → bonnes stats ✅
- **rows estimé << actual rows** → ANALYZE table ⚠️
- **Seq Scan sur grosse table** → créer index ⚠️
- **Index Scan mais lent** → index non sélectif ⚠️

## Notes pour le présentateur
- 🎯 **Message clé** : EXPLAIN ANALYZE révèle les goulots d'étranglement - toujours l'utiliser avant d'optimiser
- **Analogie** : EXPLAIN c'est comme le GPS qui calcule l'itinéraire (estimé), EXPLAIN ANALYZE c'est le temps réel de trajet
- **Démonstration live** :
  1. Requête lente sans index → EXPLAIN ANALYZE → Seq Scan
  2. Créer index → EXPLAIN ANALYZE → Index Scan + temps divisé par 10+
  3. Jointure : montrer Nested Loop vs Hash Join selon taille tables
  4. Stats obsolètes : UPDATE masse de données → EXPLAIN → mauvais plan → ANALYZE table → meilleur plan
- **Outils visuels** :
  - explain.depesz.com : Visualiser plan PostgreSQL
  - pgAdmin : EXPLAIN graphique intégré
  - Extension pg_stat_statements : Top requêtes lentes
- **Bonnes pratiques** :
  - ✅ EXPLAIN ANALYZE sur requêtes critiques
  - ✅ Comparer avant/après optimisation
  - ✅ Wrapper EXPLAIN ANALYZE dans transaction pour UPDATE/DELETE
  ```sql
  BEGIN;
  EXPLAIN ANALYZE DELETE FROM ...;
  ROLLBACK;
  ```
  - ✅ Exécuter ANALYZE régulièrement (maintenance)
  - ⚠️ Ne pas optimiser sans mesurer d'abord
- **Signaux d'alerte** :
  - Seq Scan sur table > 10 000 lignes
  - actual rows >> estimated rows (statistiques obsolètes)
  - Nested Loop Join sur grosses tables
  - Temps > 100ms pour requête simple
