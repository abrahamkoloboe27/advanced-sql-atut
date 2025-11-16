# 23 - Sécurité & Permissions : GRANT / REVOKE 🔐

## Objectif
Maîtriser la gestion des permissions avec DCL pour sécuriser l'accès aux données selon le principe du moindre privilège.

## Contenu

### 🔒 Principe du Moindre Privilège
Chaque utilisateur/application doit avoir UNIQUEMENT les permissions nécessaires à son rôle.

**Hiérarchie PostgreSQL** :
1. **Superuser** : Tous les droits (postgres)
2. **Rôles personnalisés** : Ensemble de permissions
3. **Utilisateurs** : Personnes/applications avec login

### 👥 Gestion des Rôles

**Créer un rôle** :
```sql
CREATE ROLE nom_role;
CREATE USER nom_user WITH PASSWORD 'password';  -- Rôle avec LOGIN
```

**Attributs de rôle** :
- `LOGIN` : Peut se connecter
- `SUPERUSER` : Tous les droits
- `CREATEDB` : Peut créer bases
- `CREATEROLE` : Peut créer rôles
- `REPLICATION` : Réplication streaming

### 🔑 Commandes DCL

**GRANT** : Accorder permissions
```sql
GRANT privilège ON objet TO rôle;
```

**REVOKE** : Retirer permissions
```sql
REVOKE privilège ON objet FROM rôle;
```

**Privilèges sur tables** :
- `SELECT` : Lire données
- `INSERT` : Insérer données
- `UPDATE` : Modifier données
- `DELETE` : Supprimer données
- `TRUNCATE` : Vider table
- `REFERENCES` : Créer clés étrangères
- `TRIGGER` : Créer triggers
- `ALL` : Tous les privilèges

**Privilèges sur base** :
- `CONNECT` : Se connecter à la base
- `CREATE` : Créer objets (tables, vues)
- `TEMP` : Créer tables temporaires

### 🎭 Scénarios typiques

**1. Analyste (lecture seule)** :
```sql
GRANT CONNECT ON DATABASE shop_db TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
```

**2. Développeur (lecture + écriture)** :
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES TO developer;
```

**3. Application (permissions ciblées)** :
```sql
GRANT SELECT, INSERT ON orders TO app_user;
GRANT UPDATE (status) ON orders TO app_user;  -- Seulement colonne status
```

## Illustration suggérée
- Pyramide des privilèges (superuser → rôles → users)
- Tableau des privilèges par type d'utilisateur

## Exemple (entrée)

**Scénario** : E-commerce avec 3 types d'utilisateurs
- **Analystes** : Lecture seule
- **Managers** : Lecture + mise à jour commandes
- **Admin** : Tous droits

## Requête SQL
```sql
-- 1. Créer les rôles
CREATE ROLE analyst_role;
CREATE ROLE manager_role;
CREATE ROLE admin_role;

-- 2. Permissions ANALYST (lecture seule)
GRANT CONNECT ON DATABASE shop_db TO analyst_role;
GRANT USAGE ON SCHEMA public TO analyst_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst_role;
-- Auto-grant pour futures tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT SELECT ON TABLES TO analyst_role;

-- 3. Permissions MANAGER (lecture + modif commandes)
GRANT analyst_role TO manager_role;  -- Hérite de analyst
GRANT INSERT, UPDATE, DELETE ON orders TO manager_role;
GRANT UPDATE (stock) ON products TO manager_role;

-- 4. Permissions ADMIN (tous droits sauf superuser)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT ALL PRIVILEGES ON DATABASE shop_db TO admin_role;

-- 5. Créer utilisateurs et assigner rôles
CREATE USER alice_analyst WITH PASSWORD 'analyst123';
GRANT analyst_role TO alice_analyst;

CREATE USER bob_manager WITH PASSWORD 'manager123';
GRANT manager_role TO bob_manager;

CREATE USER charlie_admin WITH PASSWORD 'admin123';
GRANT admin_role TO charlie_admin;

-- 6. Vérifier permissions d'un utilisateur
\du alice_analyst  -- Dans psql
SELECT * FROM information_schema.table_privileges 
WHERE grantee = 'analyst_role';

-- 7. Révoquer permission
REVOKE UPDATE ON products FROM manager_role;

-- 8. Permissions spécifiques par colonne
GRANT SELECT (customer_id, name, city) ON customers TO analyst_role;
-- Pas accès à email, phone (données sensibles)

-- 9. Row-Level Security (RLS)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY manager_own_orders ON orders
FOR SELECT TO manager_role
USING (manager_id = current_user::TEXT);
-- Manager voit seulement ses commandes
```

## Résultat (table)

**Vérification permissions** :
| Rôle | Tables | SELECT | INSERT | UPDATE | DELETE |
|------|--------|--------|--------|--------|--------|
| analyst_role | ALL | ✅ | ❌ | ❌ | ❌ |
| manager_role | orders | ✅ | ✅ | ✅ | ✅ |
| manager_role | products | ✅ | ❌ | ✅ (stock) | ❌ |
| admin_role | ALL | ✅ | ✅ | ✅ | ✅ |

## Notes pour le présentateur
- 🎯 **Message clé** : Sécurité = principe du moindre privilège + audit régulier des permissions
- **Analogie** : Permissions SQL = badges d'accès dans un immeuble (certains accèdent partout, d'autres à certains étages)
- **Démonstration live** :
  1. Créer utilisateur avec permissions minimales
  2. Tenter UPDATE sans permission → erreur
  3. GRANT UPDATE → réessayer → succès
  4. Montrer Row-Level Security (RLS) : user voit seulement ses données
- **Erreurs fréquentes** :
  - Donner trop de droits "pour simplifier"
  - Oublier ALTER DEFAULT PRIVILEGES (nouvelles tables non couvertes)
  - Utiliser superuser pour l'application (danger !)
  - Partager credentials entre utilisateurs
- **Bonnes pratiques** :
  - ✅ Un utilisateur dédié par application
  - ✅ Jamais de superuser en prod pour applications
  - ✅ Passwords forts + rotation régulière
  - ✅ Audit trail : activer `log_statement = 'ddl'`
  - ✅ Row-Level Security pour multi-tenant
  - ✅ Chiffrement en transit (SSL/TLS)
  - ✅ Chiffrement au repos (PostgreSQL 10+)
- **Hiérarchie recommandée** :
  ```
  postgres (superuser)
    ├── admin_role (DDL + DML complet)
    ├── app_role (DML ciblé)
    ├── readonly_role (SELECT only)
    └── backup_role (pg_dump)
  ```
- **Outils d'audit** :
  - pgaudit extension : Audit détaillé
  - pg_stat_activity : Connexions actives
  - pg_roles : Lister tous les rôles
- **Cas réel** : 
  - Application web : SELECT + INSERT + UPDATE ciblés
  - ETL : SELECT source + INSERT destination
  - BI Tools : SELECT only sur vues matérialisées
