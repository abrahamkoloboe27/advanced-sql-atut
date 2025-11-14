# 22 - Optimisation & Bonnes Pratiques Production ✅

## Objectif
Appliquer les bonnes pratiques d'optimisation et de développement SQL pour garantir performance et maintenabilité en production.

## Contenu

### 🏆 Checklist d'Optimisation

**1️⃣ Conception de schéma**
- ✅ Normalisation (éviter redondance)
- ✅ Clés primaires sur toutes les tables
- ✅ Clés étrangères pour intégrité référentielle
- ✅ Contraintes CHECK pour validation
- ✅ NOT NULL sur colonnes obligatoires
- ✅ Types de données appropriés (pas de TEXT pour tout)

**2️⃣ Indexes stratégiques**
- ✅ Index sur clés étrangères
- ✅ Index sur colonnes de WHERE fréquents
- ✅ Index sur colonnes de ORDER BY
- ✅ Index composés pour requêtes multi-colonnes
- ⚠️ Pas plus de 3-5 index par table (ralentit écritures)
- ⚠️ Surveiller utilisation : `pg_stat_user_indexes`

**3️⃣ Requêtes optimisées**
- ✅ SELECT colonnes spécifiques (pas `SELECT *`)
- ✅ WHERE avant JOIN quand possible
- ✅ LIMIT pour pagination (pas tout charger)
- ✅ EXISTS au lieu de IN pour sous-requêtes
- ✅ UNION ALL au lieu de UNION si doublons OK
- ⚠️ Éviter fonctions dans WHERE (désactive index)
  ```sql
  -- ❌ Lent
  WHERE UPPER(name) = 'ALICE'
  -- ✅ Rapide (avec index)
  WHERE name = 'Alice'
  ```

**4️⃣ Transactions & Locks**
- ✅ Transactions courtes (libérer locks vite)
- ✅ Read-committed par défaut (sauf besoin spécifique)
- ⚠️ Éviter longs traitements en transaction
- ⚠️ Éviter SELECT FOR UPDATE si pas nécessaire

**5️⃣ Maintenance régulière**
- ✅ VACUUM ANALYZE automatique (autovacuum)
- ✅ REINDEX périodique (tables volatiles)
- ✅ Surveiller taille base (`pg_database_size`)
- ✅ Archiver/supprimer vieilles données
- ✅ Sauvegardes quotidiennes (pg_dump, pg_basebackup)

**6️⃣ Monitoring & Alerting**
- ✅ pg_stat_statements : Top requêtes lentes
- ✅ Logs slow queries (log_min_duration_statement)
- ✅ Surveiller connexions (max_connections)
- ✅ Surveiller cache hit ratio (> 90%)
- ✅ Alertes disque plein, réplication lag

### 🚀 Optimisations avancées

**Partitioning** : Diviser grande table en sous-tables
```sql
CREATE TABLE orders (...)
PARTITION BY RANGE (order_date);
```

**Connection pooling** : PgBouncer, pgpool-II

**Read replicas** : Répartir charge lecture

**Caching applicatif** : Redis, Memcached pour queries répétitives

## Illustration suggérée
- Checklist visuelle avec ✅/⚠️
- Graphique : Impact index sur temps requête

## Exemple (entrée)

**❌ Requête non optimisée**
```sql
SELECT * FROM orders WHERE EXTRACT(YEAR FROM order_date) = 2024;
```

**✅ Requête optimisée**
```sql
SELECT order_id, customer_id, total_amount, order_date
FROM orders 
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01';
```

## Requête SQL
```sql
-- Exemple 1 : Optimisation avec EXISTS au lieu de IN
-- ❌ Lent (subquery exécutée pour chaque ligne)
SELECT * FROM customers 
WHERE customer_id IN (SELECT customer_id FROM orders);

-- ✅ Rapide (EXISTS arrête dès première correspondance)
SELECT * FROM customers c
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.customer_id = c.customer_id);

-- Exemple 2 : Pagination efficace
-- ❌ Lent (scan toutes les lignes puis skip)
SELECT * FROM orders ORDER BY order_id OFFSET 10000 LIMIT 10;

-- ✅ Rapide (WHERE sur dernière valeur vue)
SELECT * FROM orders 
WHERE order_id > 10000 
ORDER BY order_id 
LIMIT 10;

-- Exemple 3 : Monitoring - Requêtes lentes
SELECT 
    query,
    calls,
    total_time,
    mean_time,
    max_time
FROM pg_stat_statements
ORDER BY mean_time DESC
LIMIT 10;

-- Exemple 4 : Vérifier utilisation des index
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch
FROM pg_stat_user_indexes
WHERE idx_scan = 0  -- Index jamais utilisés
ORDER BY pg_relation_size(indexrelid) DESC;
```

## Résultat (table)

**Comparaison performance** :
| Optimisation | Avant | Après | Gain |
|--------------|-------|-------|------|
| SELECT colonnes vs * | 120ms | 45ms | 🚀 2.7x |
| EXISTS vs IN | 850ms | 12ms | 🚀 70x |
| Index sur WHERE | 2100ms | 8ms | 🚀 262x |
| LIMIT keyset pagination | 450ms | 3ms | 🚀 150x |

## Notes pour le présentateur
- 🎯 **Message clé** : L'optimisation est un processus itératif - mesurer, optimiser, valider
- **Règle d'or** : Ne jamais optimiser sans mesurer (EXPLAIN ANALYZE)
- **Démonstration live** :
  1. Requête SELECT * → remplacer par colonnes → gain marginal mais bonne pratique
  2. Fonction dans WHERE → désactive index → refactorer
  3. pg_stat_statements → identifier vraies requêtes lentes (pas suppositions)
  4. Index inutilisé → DROP → espace récupéré
- **Priorités d'optimisation** :
  1. **Impact élevé, effort faible** : Index manquant, SELECT *, LIMIT
  2. **Impact élevé, effort moyen** : Refactoring requêtes, dénormalisation ciblée
  3. **Impact moyen, effort élevé** : Partitioning, sharding, réplication
- **Erreurs fréquentes** :
  - Sur-optimisation prématurée (avant même d'avoir des données)
  - Créer trop d'index "au cas où"
  - Ignorer statistiques (pas d'ANALYZE)
  - Transactions trop longues
- **Bonnes pratiques développement** :
  - ✅ Requêtes SQL dans des fichiers dédiés (pas dans code)
  - ✅ Migrations versionnées (Flyway, Liquibase)
  - ✅ Tests de performance dans CI/CD
  - ✅ Code review des requêtes complexes
  - ✅ Documentation des décisions d'index
- **Outils recommandés** :
  - pgAdmin : EXPLAIN visuel
  - pg_stat_statements : Monitoring requêtes
  - explain.depesz.com : Analyser plans
  - pgBadger : Analyse de logs
  - New Relic, Datadog : Monitoring production
