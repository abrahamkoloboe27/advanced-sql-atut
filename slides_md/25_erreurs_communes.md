# 25 - Erreurs Communes & Conseils pour les Éviter ⚠️

## Objectif
Identifier les erreurs SQL les plus fréquentes et apprendre à les éviter pour écrire du code robuste et maintenable.

## Contenu

### 🚨 Top 10 des Erreurs SQL

**1️⃣ UPDATE/DELETE sans WHERE**
```sql
-- ❌ CATASTROPHIQUE : Modifie TOUTES les lignes
UPDATE products SET price = 0;
DELETE FROM customers;

-- ✅ CORRECT : Toujours spécifier WHERE
UPDATE products SET price = 0 WHERE category = 'Clearance';
DELETE FROM customers WHERE inactive_since < '2020-01-01';

-- 🛡️ PROTECTION : Tester avec SELECT d'abord
SELECT * FROM products WHERE category = 'Clearance';  -- Vérifier
BEGIN;
UPDATE products SET price = 0 WHERE category = 'Clearance';
-- Vérifier le nombre de lignes affectées
ROLLBACK;  -- ou COMMIT si OK
```

**2️⃣ NULL mal géré**
```sql
-- ❌ FAUX : NULL n'est jamais = NULL
WHERE price = NULL;

-- ✅ CORRECT
WHERE price IS NULL;

-- ❌ FAUX : COUNT(*) compte NULL
SELECT COUNT(phone) FROM customers;  -- Ne compte pas les NULL

-- ✅ CORRECT : Être explicite
SELECT COUNT(*) AS total, COUNT(phone) AS with_phone FROM customers;
```

**3️⃣ N+1 queries (ORM)**
```python
# ❌ N+1 : 1 query + N queries (un par customer)
customers = Customer.query.all()
for customer in customers:
    print(customer.orders)  # Query pour chaque customer !

# ✅ CORRECT : Eager loading
customers = Customer.query.options(joinedload('orders')).all()
```

**4️⃣ SELECT * en production**
```sql
-- ❌ MAUVAIS : Charge colonnes inutiles
SELECT * FROM products;

-- ✅ CORRECT : Colonnes explicites
SELECT product_id, name, price FROM products;
```

**5️⃣ Pas d'index sur clés étrangères**
```sql
-- ❌ LENT : JOIN sans index
SELECT * FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- ✅ CORRECT : Index sur FK
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
```

**6️⃣ LIKE '%pattern%' sur grosse table**
```sql
-- ❌ TRÈS LENT : Full scan (index inutilisable)
WHERE name LIKE '%laptop%';

-- ✅ MIEUX : LIKE 'pattern%' (peut utiliser index)
WHERE name LIKE 'Laptop%';

-- ✅ OPTIMAL : Full-text search
CREATE INDEX idx_products_name_gin ON products 
USING GIN (to_tsvector('english', name));

WHERE to_tsvector('english', name) @@ to_tsquery('laptop');
```

**7️⃣ Fonction dans WHERE (désactive index)**
```sql
-- ❌ LENT : Index non utilisé
WHERE UPPER(email) = 'ALICE@EXAMPLE.COM';
WHERE EXTRACT(YEAR FROM order_date) = 2024;

-- ✅ RAPIDE : Condition compatible index
WHERE email = 'alice@example.com';  -- Ou index fonctionnel
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01';
```

**8️⃣ Transactions trop longues**
```sql
-- ❌ BLOQUE table pendant 10 minutes
BEGIN;
-- Long traitement...
UPDATE orders SET status = 'PROCESSED' WHERE ...;
-- Attente humaine ou traitement long
COMMIT;

-- ✅ Transactions courtes
BEGIN;
UPDATE orders SET status = 'PROCESSED' WHERE order_id = 123;
COMMIT;
```

**9️⃣ Injection SQL**
```python
-- ❌ DANGEREUX : Injection SQL
query = f"SELECT * FROM users WHERE name = '{user_input}'"
# Si user_input = "'; DROP TABLE users; --"

-- ✅ SÉCURISÉ : Paramètres bindés
cursor.execute("SELECT * FROM users WHERE name = %s", (user_input,))
```

**🔟 Pas de sauvegarde / Pas de test de restore**
```sql
-- ❌ Suppression accidentelle sans backup récent
DROP TABLE important_data;  -- Oups !

-- ✅ Backup quotidien + test restore
pg_dump -U user -d shop_db > backup_$(date +%Y%m%d).sql
# Tester régulièrement : pg_restore ou psql < backup.sql
```

### 💡 Conseils généraux

**Design** :
- ✅ Normaliser (éviter redondance)
- ✅ Contraintes FK, CHECK, NOT NULL
- ✅ Types appropriés (pas de TEXT pour tout)

**Développement** :
- ✅ Code review requêtes SQL
- ✅ Tests automatisés (données, schéma)
- ✅ Paramètres bindés (jamais concaténation)

**Performance** :
- ✅ EXPLAIN ANALYZE avant optimisation
- ✅ Index stratégiques (pas de sur-indexation)
- ✅ Monitoring (pg_stat_statements)

**Sécurité** :
- ✅ Moindre privilège
- ✅ Jamais superuser pour app
- ✅ Audit trail activé

## Illustration suggérée
- Liste ❌ vs ✅ visuellement impactante
- Graphique impact performance des erreurs

## Exemple (entrée)

**Cas réel : Debug requête lente**

## Requête SQL
```sql
-- Requête lente identifiée
SELECT * FROM orders 
WHERE EXTRACT(YEAR FROM order_date) = 2024
ORDER BY order_date DESC;

-- Analyse
EXPLAIN ANALYZE
SELECT * FROM orders 
WHERE EXTRACT(YEAR FROM order_date) = 2024
ORDER BY order_date DESC;
-- → Seq Scan (lent)

-- Correction 1 : Enlever fonction dans WHERE
EXPLAIN ANALYZE
SELECT * FROM orders 
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
ORDER BY order_date DESC;
-- → Index Scan si index existe (rapide)

-- Correction 2 : SELECT colonnes nécessaires
SELECT order_id, customer_id, total_amount, order_date
FROM orders 
WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
ORDER BY order_date DESC
LIMIT 100;  -- Pagination

-- Correction 3 : Index si manquant
CREATE INDEX idx_orders_date ON orders(order_date);
```

## Résultat (table)

**Impact corrections** :
| Optimisation | Temps (ms) | Gain |
|--------------|------------|------|
| Requête initiale | 2850 | - |
| Sans fonction WHERE | 450 | 🚀 6.3x |
| SELECT colonnes | 380 | 🚀 7.5x |
| + Index | 12 | 🚀 237x |
| + LIMIT | 3 | 🚀 950x |

## Notes pour le présentateur
- 🎯 **Message clé** : La plupart des bugs SQL sont évitables avec discipline et bonnes pratiques
- **Top 3 erreurs critiques** :
  1. UPDATE/DELETE sans WHERE → perte de données
  2. Injection SQL → faille sécurité
  3. Pas de backup → disaster
- **Démonstration live** :
  1. UPDATE sans WHERE en transaction → ROLLBACK → ouf !
  2. Requête avec fonction WHERE → EXPLAIN → Seq Scan → refactor → Index Scan
  3. Injection SQL : Montrer comment `'; DROP TABLE` fonctionne
  4. N+1 queries : Activer query logging, montrer explosion de queries
- **Checklist avant production** :
  - [ ] Toutes les FK ont un index
  - [ ] Pas de SELECT * en production
  - [ ] Pas de fonctions dans WHERE sur colonnes indexées
  - [ ] Transactions courtes (< 1 seconde)
  - [ ] Paramètres bindés (pas de concaténation)
  - [ ] Tests de performance (EXPLAIN ANALYZE)
  - [ ] Backup quotidien + test restore
  - [ ] Monitoring actif (slow queries)
- **Outils de prévention** :
  - Linters SQL (sqlfluff, pg_format)
  - Pre-commit hooks (bloquer UPDATE sans WHERE)
  - Code review systématique
  - Tests automatisés
  - Environnement staging identique à prod
- **Culture de prévention** :
  - ⚠️ Toujours tester en dev/staging d'abord
  - ⚠️ Peer review pour requêtes complexes
  - ⚠️ Documentation des décisions de design
  - ⚠️ Post-mortems après incidents (apprendre)
