# 21 - Indexes, Views, Materialized Views 🗂️

## Objectif
Comprendre les indexes, vues et vues matérialisées pour optimiser les performances et simplifier les requêtes.

## Contenu

### 📇 Indexes : Accélérer les recherches

**Définition** : Structure de données auxiliaire pour accélérer les recherches.

**Types d'index PostgreSQL** :
- **B-tree** (défaut) : Comparaisons (=, <, >, BETWEEN, ORDER BY)
- **Hash** : Égalité uniquement (=)
- **GIN** : Texte full-text, JSONB, arrays
- **GiST** : Géospatial, full-text
- **BRIN** : Très grandes tables séquentielles

**Syntaxe** :
```sql
CREATE INDEX nom_index ON table (colonne);
CREATE INDEX nom_index ON table (col1, col2);  -- Index composé
CREATE UNIQUE INDEX nom_index ON table (colonne);
```

**Quand créer un index ?**
- ✅ Colonnes dans WHERE fréquemment
- ✅ Colonnes dans JOIN (clés étrangères)
- ✅ Colonnes dans ORDER BY
- ❌ Petites tables (< 1000 lignes)
- ❌ Colonnes modifiées souvent (INSERT/UPDATE ralentis)

### 👁️ Views : Requêtes réutilisables

**Définition** : Requête nommée et stockée, recalculée à chaque appel.

**Syntaxe** :
```sql
CREATE VIEW nom_vue AS
SELECT ...;

-- Utilisation
SELECT * FROM nom_vue;
```

**Avantages** :
- ✅ Simplifier requêtes complexes
- ✅ Encapsuler logique métier
- ✅ Sécurité (masquer colonnes sensibles)
- ✅ Abstraction (changer structure sans casser code)

### 📦 Materialized Views : Vues pré-calculées

**Définition** : Résultat de requête stocké physiquement, comme une table.

**Syntaxe** :
```sql
CREATE MATERIALIZED VIEW nom_mv AS
SELECT ...;

-- Rafraîchir les données
REFRESH MATERIALIZED VIEW nom_mv;
```

**Différences View vs Materialized View** :

| Aspect | View | Materialized View |
|--------|------|-------------------|
| Stockage | Rien (juste requête) | Résultat stocké |
| Performance | Recalcul à chaque fois | Lecture rapide |
| Fraîcheur | Toujours à jour | Obsolète jusqu'au REFRESH |
| Espace disque | 0 | Taille du résultat |

**Quand utiliser Materialized View ?**
- ✅ Requêtes lourdes (agrégations, joins multiples)
- ✅ Données changent peu (refresh périodique OK)
- ✅ Dashboards, rapports
- ❌ Données temps réel

## Illustration suggérée
- Schéma B-tree index
- Tableau comparatif View / Materialized View / Table

## Exemple (entrée)

**Table orders (1 000 000 lignes)**
| order_id | customer_id | total_amount | order_date |
|----------|-------------|--------------|------------|
| ... | ... | ... | ... |

## Requête SQL
```sql
-- 1. Créer un index sur customer_id (clé étrangère)
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- 2. Index composé (WHERE multi-colonnes)
CREATE INDEX idx_orders_status_date 
ON orders(status, order_date);

-- 3. Créer une vue simple
CREATE VIEW customer_orders AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(*) AS num_orders,
    SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Utiliser la vue
SELECT * FROM customer_orders WHERE total_spent > 1000;

-- 4. Créer une vue matérialisée (calculs lourds)
CREATE MATERIALIZED VIEW monthly_sales AS
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS num_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS avg_order
FROM orders
GROUP BY DATE_TRUNC('month', order_date);

-- Créer index sur la vue matérialisée
CREATE INDEX idx_monthly_sales_month ON monthly_sales(month);

-- Utiliser la vue matérialisée
SELECT * FROM monthly_sales WHERE month >= '2024-01-01';

-- Rafraîchir quotidiennement (cron, Airflow, etc.)
REFRESH MATERIALIZED VIEW monthly_sales;

-- 5. View pour sécurité (masquer colonnes sensibles)
CREATE VIEW public_customers AS
SELECT customer_id, name, city  -- Pas d'email, phone
FROM customers;

GRANT SELECT ON public_customers TO analyst_role;
```

## Résultat (table)

**Performance avec index** :
| Requête | Sans index | Avec index | Gain |
|---------|------------|------------|------|
| WHERE customer_id = 123 | 450ms | 2ms | 🚀 225x |
| JOIN customers-orders | 8500ms | 120ms | 🚀 70x |

**customer_orders view** :
| customer_id | name | num_orders | total_spent |
|-------------|------|------------|-------------|
| 1 | Alice | 15 | 2500.00 |
| 2 | Bob | 8 | 1200.00 |

**monthly_sales materialized view** :
| month | num_orders | total_sales | avg_order |
|-------|------------|-------------|-----------|
| 2024-01-01 | 1250 | 125000.00 | 100.00 |
| 2024-02-01 | 1100 | 115000.00 | 104.55 |

## Notes pour le présentateur
- 🎯 **Message clé** : Index = compromis vitesse lecture vs écriture ; Views = réutilisabilité ; MV = performance calculs lourds
- **Analogie** :
  - Index = Index d'un livre (trouver page rapidement)
  - View = Raccourci/lien symbolique (toujours à jour)
  - Materialized View = Photocopie (rapide mais peut être obsolète)
- **Démonstration live** :
  1. EXPLAIN ANALYZE avant/après index → Seq Scan → Index Scan
  2. Créer view complexe → SELECT simple sur la view
  3. Materialized View avec REFRESH → données figées jusqu'au refresh
  4. Montrer taille de MV : `\d+ monthly_sales`
- **Pièges à éviter** :
  - ⚠️ Sur-indexation : Chaque index ralentit INSERT/UPDATE
  - ⚠️ Index non utilisés : Vérifier avec pg_stat_user_indexes
  - ⚠️ MV obsolètes : Scheduler refresh (cron, pg_cron)
  - ⚠️ View lente : PostgreSQL peut inliner ou pas (dépend)
- **Bonnes pratiques** :
  - ✅ Créer index APRÈS import de données (bulk insert plus rapide)
  - ✅ Index composé : colonnes plus sélectives en premier
  - ✅ MV avec index pour performance maximale
  - ✅ Nommer views/MV avec préfixe (v_, mv_)
  - ✅ CONCURRENT refresh pour MV (évite lock)
  ```sql
  REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_sales;
  ```
- **Maintenance** :
  - REINDEX pour reconstruire index corrompus
  - DROP INDEX si non utilisé (analyser pg_stat_user_indexes)
- **Cas réel** : Dashboard e-commerce avec MV rafraîchie toutes les heures
