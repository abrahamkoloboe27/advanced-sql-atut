-- ============================================================================
-- Script: grant_revoke.sql
-- Description: Exemples de gestion des permissions (DCL - Data Control Language)
-- Mots-clés: GRANT, REVOKE, CREATE ROLE, CREATE USER
-- ============================================================================

\echo '============================================================'
\echo 'DCL - GESTION DES PERMISSIONS ET RÔLES'
\echo '============================================================'
\echo ''

-- ============================================================================
-- DCL (Data Control Language)
-- Description: Langage de contrôle des données (permissions, sécurité)
-- Commandes principales: GRANT, REVOKE, CREATE ROLE, ALTER ROLE
-- ============================================================================

\echo '💡 DCL permet de:'
\echo '  • Créer des utilisateurs et rôles'
\echo '  • Accorder des permissions (GRANT)'
\echo '  • Révoquer des permissions (REVOKE)'
\echo '  • Contrôler l accès aux données'
\echo ''


-- ============================================================================
-- PARTIE 1: Création de rôles et utilisateurs
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 1: Création de rôles et utilisateurs'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: CREATE ROLE
-- Description: Crée un rôle (groupe de permissions)
-- Un rôle peut être assigné à plusieurs utilisateurs
-- ============================================================================

\echo '1️⃣ Création de rôles:'

-- Créer un rôle pour les analystes (lecture seule)
CREATE ROLE analyst;

\echo '✅ Rôle analyst créé (lecture seule)'

-- Créer un rôle pour les gestionnaires (lecture + écriture)
CREATE ROLE manager;

\echo '✅ Rôle manager créé (lecture + écriture)'

-- Créer un rôle pour les administrateurs (tous les droits)
CREATE ROLE administrator;

\echo '✅ Rôle administrator créé'
\echo ''


-- ============================================================================
-- Mot-clé: CREATE USER
-- Description: Crée un utilisateur avec mot de passe
-- Un utilisateur est un rôle avec permission de connexion (LOGIN)
-- ============================================================================

\echo '2️⃣ Création d utilisateurs:'

-- Créer un utilisateur analyst avec mot de passe
CREATE USER alice WITH PASSWORD 'alice123' IN ROLE analyst;

\echo '✅ Utilisateur alice créé (rôle analyst)'

-- Créer un utilisateur manager
CREATE USER bob WITH PASSWORD 'bob123' IN ROLE manager;

\echo '✅ Utilisateur bob créé (rôle manager)'

-- Créer un utilisateur admin
CREATE USER charlie WITH PASSWORD 'charlie123' IN ROLE administrator;

\echo '✅ Utilisateur charlie créé (rôle administrator)'
\echo ''


-- ============================================================================
-- PARTIE 2: GRANT - Accorder des permissions
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 2: GRANT - Accorder des permissions'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: GRANT
-- Description: Accorde des permissions sur des objets de la base
-- Syntaxe: GRANT permission ON objet TO rôle/utilisateur
-- Permissions: SELECT, INSERT, UPDATE, DELETE, ALL
-- ============================================================================

-- Exemple 1: GRANT SELECT (lecture seule)
-- ============================================================================
\echo '1️⃣ GRANT SELECT - Permission de lecture:'

-- Accorder lecture sur la table customers au rôle analyst
GRANT SELECT ON customers TO analyst;

\echo '✅ analyst peut lire la table customers'

-- Accorder lecture sur toutes les tables à analyst
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;

\echo '✅ analyst peut lire toutes les tables du schéma public'
\echo ''


-- Exemple 2: GRANT INSERT, UPDATE, DELETE
-- ============================================================================
\echo '2️⃣ GRANT INSERT, UPDATE, DELETE:'

-- Accorder permissions d'écriture au rôle manager
GRANT SELECT, INSERT, UPDATE, DELETE ON customers TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON products TO manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON orders TO manager;

\echo '✅ manager peut lire et modifier les tables'
\echo ''


-- Exemple 3: GRANT ALL PRIVILEGES
-- ============================================================================
\echo '3️⃣ GRANT ALL - Toutes les permissions:'

-- Accorder tous les droits au rôle administrator
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrator;

\echo '✅ administrator a tous les droits sur toutes les tables'
\echo ''


-- Exemple 4: GRANT sur une vue
-- ============================================================================
\echo '4️⃣ GRANT sur une vue:'

-- Créer une vue pour l'exemple
CREATE OR REPLACE VIEW customer_summary AS
SELECT customer_id, first_name, last_name, email
FROM customers;

-- Accorder lecture sur la vue
GRANT SELECT ON customer_summary TO analyst;

\echo '✅ analyst peut lire la vue customer_summary'
\echo ''


-- Exemple 5: GRANT sur des séquences (pour INSERT)
-- ============================================================================
\echo '5️⃣ GRANT USAGE sur les séquences:'

-- Pour pouvoir insérer, il faut aussi USAGE sur les séquences (auto-increment)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO manager;

\echo '✅ manager peut utiliser les séquences (auto-increment)'
\echo ''


-- Exemple 6: GRANT sur un schéma
-- ============================================================================
\echo '6️⃣ GRANT sur un schéma:'

-- Accorder accès au schéma analytics
GRANT USAGE ON SCHEMA analytics TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA analytics TO analyst;

\echo '✅ analyst peut accéder au schéma analytics'
\echo ''


-- Exemple 7: GRANT avec WITH GRANT OPTION
-- ============================================================================
\echo '7️⃣ GRANT avec WITH GRANT OPTION:'

-- Permettre à bob de donner ses permissions à d'autres
GRANT SELECT ON customers TO bob WITH GRANT OPTION;

\echo '✅ bob peut donner ses permissions SELECT sur customers à d autres'
\echo ''


-- ============================================================================
-- PARTIE 3: REVOKE - Révoquer des permissions
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 3: REVOKE - Révoquer des permissions'
\echo '============================================================'
\echo ''

-- ============================================================================
-- Mot-clé: REVOKE
-- Description: Retire des permissions précédemment accordées
-- Syntaxe: REVOKE permission ON objet FROM rôle/utilisateur
-- ============================================================================

-- Exemple 8: REVOKE simple
-- ============================================================================
\echo '8️⃣ REVOKE - Retirer des permissions:'

-- Retirer la permission INSERT au manager sur products
REVOKE INSERT ON products FROM manager;

\echo '✅ manager ne peut plus insérer dans products'
\echo ''


-- Exemple 9: REVOKE ALL
-- ============================================================================
\echo '9️⃣ REVOKE ALL - Retirer toutes les permissions:'

-- Retirer toutes les permissions de bob sur customers
REVOKE ALL PRIVILEGES ON customers FROM bob;

\echo '✅ Toutes les permissions de bob sur customers révoquées'
\echo ''


-- Exemple 10: REVOKE CASCADE
-- ============================================================================
\echo '🔟 REVOKE CASCADE - Retirer en cascade:'

-- Si bob a donné ses permissions à d'autres, CASCADE les révoque aussi
REVOKE SELECT ON customers FROM bob CASCADE;

\echo '✅ Permissions révoquées en cascade'
\echo ''


-- ============================================================================
-- PARTIE 4: Modification de rôles
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 4: Modification de rôles et utilisateurs'
\echo '============================================================'
\echo ''

-- Exemple 11: ALTER ROLE
-- ============================================================================
\echo '1️⃣1️⃣ ALTER ROLE - Modifier les propriétés d un rôle:'

-- Permettre au rôle analyst de créer des bases de données
ALTER ROLE analyst CREATEDB;

\echo '✅ analyst peut créer des bases de données'

-- Retirer ce privilège
ALTER ROLE analyst NOCREATEDB;

\echo '✅ Privilège retiré'
\echo ''


-- Exemple 12: Changer le mot de passe
-- ============================================================================
\echo '1️⃣2️⃣ Changer le mot de passe d un utilisateur:'

-- Changer le mot de passe d'alice
ALTER USER alice WITH PASSWORD 'nouveau_mot_de_passe';

\echo '✅ Mot de passe d alice modifié'
\echo ''


-- Exemple 13: Ajouter/retirer un rôle à un utilisateur
-- ============================================================================
\echo '1️⃣3️⃣ Ajouter un rôle à un utilisateur:'

-- Promouvoir alice au rôle manager
GRANT manager TO alice;

\echo '✅ alice a maintenant aussi le rôle manager'

-- Retirer le rôle manager à alice
REVOKE manager FROM alice;

\echo '✅ Rôle manager retiré à alice'
\echo ''


-- ============================================================================
-- PARTIE 5: Vérification des permissions
-- ============================================================================

\echo '============================================================'
\echo 'PARTIE 5: Vérification des permissions'
\echo '============================================================'
\echo ''

-- Exemple 14: Lister les permissions d'une table
-- ============================================================================
\echo '1️⃣4️⃣ Lister les permissions sur customers:'

\z customers

\echo ''


-- Exemple 15: Lister tous les rôles
-- ============================================================================
\echo '1️⃣5️⃣ Lister tous les rôles et utilisateurs:'

\du

\echo ''


-- Exemple 16: Vérifier les permissions d'un utilisateur
-- ============================================================================
\echo '1️⃣6️⃣ Permissions de alice:'

SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analyst'
ORDER BY table_name, privilege_type;

\echo ''


-- ============================================================================
-- EXEMPLE PRATIQUE: Politique de sécurité complète
-- ============================================================================

\echo '============================================================'
\echo 'EXEMPLE PRATIQUE: Politique de sécurité'
\echo '============================================================'
\echo ''

-- Scénario: Application web avec 3 niveaux d'accès

-- 1. app_readonly: Application en lecture seule (rapports, dashboards)
CREATE ROLE app_readonly;
GRANT CONNECT ON DATABASE shop_db TO app_readonly;
GRANT USAGE ON SCHEMA public TO app_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO app_readonly;
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO app_readonly;

\echo '✅ Rôle app_readonly créé (lecture seule)'

-- 2. app_write: Application avec accès écriture (API backend)
CREATE ROLE app_write;
GRANT CONNECT ON DATABASE shop_db TO app_write;
GRANT USAGE ON SCHEMA public TO app_write;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO app_write;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO app_write;

\echo '✅ Rôle app_write créé (lecture + écriture)'

-- 3. app_admin: Admin de l'application (migrations, maintenance)
CREATE ROLE app_admin;
GRANT CONNECT ON DATABASE shop_db TO app_admin;
GRANT ALL PRIVILEGES ON SCHEMA public TO app_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO app_admin;

\echo '✅ Rôle app_admin créé (tous les droits)'
\echo ''


-- Créer des utilisateurs pour chaque rôle
CREATE USER readonly_user WITH PASSWORD 'readonly123' IN ROLE app_readonly;
CREATE USER api_user WITH PASSWORD 'api123' IN ROLE app_write;
CREATE USER admin_user WITH PASSWORD 'admin123' IN ROLE app_admin;

\echo '✅ Utilisateurs créés pour chaque rôle'
\echo ''


-- ============================================================================
-- NETTOYAGE (optionnel)
-- ============================================================================

\echo '============================================================'
\echo 'NETTOYAGE'
\echo '============================================================'
\echo ''

-- Supprimer les utilisateurs et rôles de test
DROP USER IF EXISTS alice;
DROP USER IF EXISTS bob;
DROP USER IF EXISTS charlie;
DROP USER IF EXISTS readonly_user;
DROP USER IF EXISTS api_user;
DROP USER IF EXISTS admin_user;

DROP ROLE IF EXISTS analyst;
DROP ROLE IF EXISTS manager;
DROP ROLE IF EXISTS administrator;
DROP ROLE IF EXISTS app_readonly;
DROP ROLE IF EXISTS app_write;
DROP ROLE IF EXISTS app_admin;

DROP VIEW IF EXISTS customer_summary;

\echo '✅ Utilisateurs et rôles de test supprimés'
\echo ''


-- ============================================================================
-- RÉCAPITULATIF
-- ============================================================================

\echo '============================================================'
\echo 'RÉCAPITULATIF DCL (Data Control Language)'
\echo '============================================================'
\echo ''
\echo '📌 Création:'
\echo '  ✓ CREATE ROLE - Créer un rôle (groupe de permissions)'
\echo '  ✓ CREATE USER - Créer un utilisateur (rôle avec LOGIN)'
\echo ''
\echo '📌 Permissions:'
\echo '  ✓ GRANT - Accorder des permissions'
\echo '    • SELECT (lecture)'
\echo '    • INSERT, UPDATE, DELETE (écriture)'
\echo '    • ALL PRIVILEGES (tous les droits)'
\echo '    • WITH GRANT OPTION (délégation)'
\echo '  ✓ REVOKE - Révoquer des permissions'
\echo '    • CASCADE (révocation en cascade)'
\echo ''
\echo '📌 Objets concernés:'
\echo '  ✓ Tables, vues, séquences'
\echo '  ✓ Schémas (USAGE)'
\echo '  ✓ Base de données (CONNECT)'
\echo ''
\echo '📌 Bonnes pratiques:'
\echo '  ✓ Principe du moindre privilège'
\echo '  ✓ Utiliser des rôles (pas des permissions individuelles)'
\echo '  ✓ Séparer lecture/écriture/admin'
\echo '  ✓ Mots de passe forts'
\echo '  ✓ Auditer régulièrement les permissions'
\echo ''
\echo '⚠️  Sécurité:'
\echo '  • Ne jamais utiliser le superuser en production'
\echo '  • Limiter les connexions par IP (pg_hba.conf)'
\echo '  • Utiliser SSL/TLS pour les connexions'
\echo '  • Chiffrer les mots de passe (SCRAM-SHA-256)'
\echo '============================================================'
