# 24 - Migrations & Gestion SQL en CI/CD 🔄

## Objectif
Comprendre les bonnes pratiques de gestion des migrations de schéma et d'intégration SQL dans les pipelines CI/CD.

## Contenu

### 🎯 Pourquoi versionner le schéma ?
Les évolutions de schéma doivent être :
- ✅ **Versionnées** : Traçabilité des changements
- ✅ **Reproductibles** : Même résultat dev → staging → prod
- ✅ **Réversibles** : Rollback si problème
- ✅ **Testées** : Validation avant déploiement

### 🛠️ Outils de migration populaires

**1️⃣ Flyway** (Java, multi-DB)
```sql
-- V001__create_customers.sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- V002__add_email_to_customers.sql
ALTER TABLE customers ADD COLUMN email TEXT;
```

**2️⃣ Liquibase** (Java, XML/YAML/SQL)
```xml
<changeSet id="1" author="alice">
  <createTable tableName="customers">
    <column name="id" type="int" autoIncrement="true"/>
    <column name="name" type="varchar(100)"/>
  </createTable>
</changeSet>
```

**3️⃣ Alembic** (Python, SQLAlchemy)
```python
def upgrade():
    op.create_table('customers',
        sa.Column('id', sa.Integer(), primary_key=True),
        sa.Column('name', sa.String(100))
    )
```

**4️⃣ Rails Migrations** (Ruby on Rails)
```ruby
class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.timestamps
    end
  end
end
```

**5️⃣ Sqitch** (SQL natif, multi-DB)

### 📋 Conventions de nommage

**Format recommandé** :
- `V{version}__{description}.sql` (Flyway)
- `{timestamp}_{description}.sql` (Alembic)

**Exemples** :
- `V001__initial_schema.sql`
- `V002__add_orders_table.sql`
- `V003__add_index_on_customer_email.sql`
- `R__view_customer_analytics.sql` (R = repeatable)

### 🔄 Stratégies de migration

**1️⃣ Expand-Contract (zero-downtime)**
```sql
-- Phase 1 (Expand) : Ajouter nouvelle colonne
ALTER TABLE customers ADD COLUMN full_name TEXT;

-- Phase 2 (Migrate) : Copier données
UPDATE customers SET full_name = first_name || ' ' || last_name;

-- Phase 3 (Contract) : Supprimer anciennes colonnes
ALTER TABLE customers DROP COLUMN first_name, DROP COLUMN last_name;
```

**2️⃣ Blue-Green deployment**
- Base v1 (blue) : En production
- Base v2 (green) : Migration appliquée, testée
- Switch : Basculer app vers v2
- Rollback facile : Revenir à v1 si problème

**3️⃣ Feature flags**
```sql
-- Migration progressive avec flag
ALTER TABLE products ADD COLUMN new_pricing NUMERIC;
-- Application lit old_price OU new_pricing selon feature flag
```

### 🚀 Intégration CI/CD

**Pipeline type** :
1. **Commit** : Dev commit migration SQL
2. **CI** : Tests automatisés
   - Linter SQL (sqlfluff, pgFormatter)
   - Migration en DB de test
   - Tests unitaires
   - EXPLAIN ANALYZE sur requêtes critiques
3. **CD Staging** : Déploiement auto en staging
4. **Tests E2E** : Validation complète
5. **CD Prod** : Déploiement manuel ou auto (avec approbation)

## Illustration suggérée
- Timeline de migration Expand-Contract
- Diagramme pipeline CI/CD avec étapes SQL

## Exemple (entrée)

**Migration 1 : Créer table**
```sql
-- migrations/V001__create_products.sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL
);
```

**Migration 2 : Ajouter colonne**
```sql
-- migrations/V002__add_category_to_products.sql
ALTER TABLE products ADD COLUMN category TEXT;
CREATE INDEX idx_products_category ON products(category);
```

## Requête SQL
```sql
-- Migration 3 : Renommer colonne (expand-contract)

-- Step 1 (V003__expand_price_column.sql)
BEGIN;
ALTER TABLE products ADD COLUMN unit_price NUMERIC(10,2);
UPDATE products SET unit_price = price;
ALTER TABLE products ALTER COLUMN unit_price SET NOT NULL;
COMMIT;

-- Step 2 (application code)
-- Code lit price OU unit_price (compatibilité)

-- Step 3 (V004__contract_price_column.sql)
BEGIN;
ALTER TABLE products DROP COLUMN price;
COMMIT;

-- Migration avec rollback
-- migrations/V005__add_stock_tracking.sql
BEGIN;

ALTER TABLE products ADD COLUMN stock INTEGER DEFAULT 0;
ALTER TABLE products ADD CONSTRAINT check_stock_positive 
    CHECK (stock >= 0);

-- Vérifier que la migration est réversible
SAVEPOINT before_data_migration;

-- Migration de données
UPDATE products SET stock = 10 WHERE category = 'Informatique';

-- Test
SELECT COUNT(*) FROM products WHERE stock < 0;
-- Si 0 → OK, sinon ROLLBACK

COMMIT;

-- Rollback script (si nécessaire)
-- migrations/R005__rollback_stock_tracking.sql
ALTER TABLE products DROP COLUMN stock;
```

## Résultat (table)

**Historique migrations (flyway_schema_history)** :
| version | description | script | installed_on | success |
|---------|-------------|--------|--------------|---------|
| 1 | create products | V001__create_products.sql | 2024-01-10 | ✅ |
| 2 | add category | V002__add_category_to_products.sql | 2024-01-15 | ✅ |
| 3 | expand price | V003__expand_price_column.sql | 2024-01-20 | ✅ |
| 4 | contract price | V004__contract_price_column.sql | 2024-01-25 | ✅ |

## Notes pour le présentateur
- 🎯 **Message clé** : Les migrations SQL doivent être traitées comme du code : versionnées, testées, déployées via CI/CD
- **Analogie** : Migrations = Git pour le schéma de base de données
- **Démonstration live** :
  1. Flyway : Montrer structure dossier migrations + commande `flyway migrate`
  2. Historique : Table flyway_schema_history avec versions appliquées
  3. Rollback : Tenter migration erronée → échoue → database reste intacte
  4. CI/CD : Exemple GitHub Actions déployant migration en staging puis prod
- **Erreurs fréquentes** :
  - Modifier migration déjà appliquée (créer nouvelle migration à la place)
  - Pas de rollback script
  - Migration non testée en staging
  - DROP COLUMN sans période de transition
  - Migrations lourdes en heures pleines (bloquer table)
- **Bonnes pratiques** :
  - ✅ Toujours tester migration sur copie de prod d'abord
  - ✅ Mesurer temps de migration (EXPLAIN, dry-run)
  - ✅ Migrations lourdes hors heures de pointe
  - ✅ Backup avant migration prod
  - ✅ Rollback plan prêt
  - ✅ Monitoring pendant/après migration
  - ✅ Communication équipe (maintenance window si nécessaire)
- **Stratégies avancées** :
  - **Online schema change** : gh-ost, pt-online-schema-change
  - **Shadow tables** : Créer nouvelle table, migrer données, swap
  - **Partitioning** : Migrer partition par partition
- **Outils complémentaires** :
  - sqlfluff : Linter SQL
  - pgTAP : Tests unitaires SQL
  - GitHub Actions / GitLab CI : Automation
  - Terraform / Ansible : Infrastructure as Code
- **Exemple pipeline CI** :
  ```yaml
  # .github/workflows/database.yml
  - name: Lint SQL
    run: sqlfluff lint migrations/
  - name: Run migrations (test DB)
    run: flyway migrate -url=jdbc:postgresql://test-db
  - name: Run tests
    run: pytest tests/
  ```
