-- ============================================================================
-- SOLUTION EXERCICE 6 : Vue et permissions (DDL + DCL)
-- ============================================================================

\echo '========================================';
\echo 'SOLUTION EXERCICE 6';
\echo '========================================';
\echo '';

-- ============================================================================
-- 6.1 - Créer une vue analytique
-- ============================================================================

\echo '6.1 - Création de la vue customer_analytics:';
\echo '';

CREATE OR REPLACE VIEW customer_analytics AS
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.total_amount), 0) AS total_spent,
    CASE 
        WHEN COUNT(o.order_id) > 0 THEN 
            ROUND(AVG(o.total_amount), 2)
        ELSE 0
    END AS avg_order_amount,
    MAX(o.order_date) AS last_order_date,
    CASE 
        WHEN COALESCE(SUM(o.total_amount), 0) > 1000 THEN 'VIP'
        ELSE 'Regular'
    END AS customer_status
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

COMMENT ON VIEW customer_analytics IS 
'Vue analytique des clients avec statistiques de commandes';

\echo '✅ Vue customer_analytics créée!';
\echo '';

-- Tester la vue
\echo 'Aperçu de la vue:';
SELECT * FROM customer_analytics ORDER BY total_spent DESC;

\echo '';

-- ============================================================================
-- 6.2 - Créer des rôles avec permissions
-- ============================================================================

\echo '6.2 - Création des rôles avec permissions:';
\echo '';

-- Nettoyer les rôles existants (si déjà créés)
DROP ROLE IF EXISTS sales_analyst;
DROP ROLE IF EXISTS sales_manager;
DROP ROLE IF EXISTS data_admin;

-- a) Rôle sales_analyst (lecture seule)
\echo 'a) Création du rôle sales_analyst (lecture seule)...';

CREATE ROLE sales_analyst;

-- Permissions de connexion
GRANT CONNECT ON DATABASE shop_db TO sales_analyst;

-- Accès au schéma
GRANT USAGE ON SCHEMA public TO sales_analyst;

-- Lecture sur toutes les tables
GRANT SELECT ON ALL TABLES IN SCHEMA public TO sales_analyst;

-- Lecture sur les séquences (pour les vues avec SERIAL)
GRANT SELECT ON ALL SEQUENCES IN SCHEMA public TO sales_analyst;

-- Permissions par défaut pour futures tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT SELECT ON TABLES TO sales_analyst;

\echo '✅ Rôle sales_analyst créé (lecture seule)';
\echo '';

-- b) Rôle sales_manager (lecture + écriture limitée)
\echo 'b) Création du rôle sales_manager (lecture + écriture)...';

CREATE ROLE sales_manager;

-- Hériter des permissions de sales_analyst
GRANT sales_analyst TO sales_manager;

-- Permissions supplémentaires sur orders
GRANT INSERT, UPDATE, DELETE ON orders TO sales_manager;

-- Permission UPDATE sur products (gestion stock)
GRANT UPDATE (stock, price) ON products TO sales_manager;

-- Accès aux séquences pour INSERT
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO sales_manager;

\echo '✅ Rôle sales_manager créé (lecture + écriture limitée)';
\echo '';

-- c) Rôle data_admin (tous les droits)
\echo 'c) Création du rôle data_admin (administrateur)...';

CREATE ROLE data_admin WITH CREATEROLE;

-- Tous les privilèges sur le schéma
GRANT ALL PRIVILEGES ON SCHEMA public TO data_admin;

-- Tous les privilèges sur toutes les tables
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO data_admin;

-- Tous les privilèges sur les séquences
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO data_admin;

-- Capacité de donner des permissions
ALTER ROLE data_admin WITH CREATEROLE;

\echo '✅ Rôle data_admin créé (tous les droits)';
\echo '';

-- ============================================================================
-- 6.3 - Créer des utilisateurs
-- ============================================================================

\echo '6.3 - Création des utilisateurs:';
\echo '';

-- Nettoyer les utilisateurs existants
DROP USER IF EXISTS alice_analyst;
DROP USER IF EXISTS bob_manager;
DROP USER IF EXISTS charlie_admin;

-- Créer alice_analyst
CREATE USER alice_analyst WITH PASSWORD 'analyst123' IN ROLE sales_analyst;

\echo '✅ Utilisateur alice_analyst créé (rôle: sales_analyst)';

-- Créer bob_manager
CREATE USER bob_manager WITH PASSWORD 'manager123' IN ROLE sales_manager;

\echo '✅ Utilisateur bob_manager créé (rôle: sales_manager)';

-- Créer charlie_admin
CREATE USER charlie_admin WITH PASSWORD 'admin123' IN ROLE data_admin CREATEDB;

\echo '✅ Utilisateur charlie_admin créé (rôle: data_admin)';
\echo '';

-- ============================================================================
-- 6.4 - Tester les permissions
-- ============================================================================

\echo '6.4 - Tests de permissions:';
\echo '';

-- Vérifier les rôles créés
\echo 'Rôles et utilisateurs créés:';
\du

\echo '';

-- Afficher les permissions sur customers
\echo 'Permissions sur la table customers:';
\z customers

\echo '';

-- Afficher les permissions sur orders
\echo 'Permissions sur la table orders:';
\z orders

\echo '';

-- Test 1: alice (lecture seule)
\echo 'Test 1 - alice_analyst peut-elle SELECT ?';
-- Note: Dans un vrai test, il faudrait se connecter en tant qu'alice
-- Ici on simule en vérifiant les permissions

SELECT 
    grantee,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'sales_analyst' 
  AND table_name = 'customers';

\echo '';
\echo '✅ alice_analyst peut SELECT (lecture seule)';
\echo '❌ alice_analyst ne peut PAS INSERT/UPDATE/DELETE';
\echo '';

-- Test 2: bob (lecture + écriture limitée)
\echo 'Test 2 - bob_manager peut-il modifier orders ?';

SELECT 
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'sales_manager' 
  AND table_name = 'orders'
ORDER BY privilege_type;

\echo '';
\echo '✅ bob_manager peut SELECT, INSERT, UPDATE, DELETE sur orders';
\echo '✅ bob_manager peut UPDATE sur products (colonnes stock, price)';
\echo '❌ bob_manager ne peut PAS DROP TABLE';
\echo '';

-- Test 3: charlie (tous les droits)
\echo 'Test 3 - charlie_admin a-t-il tous les droits ?';

SELECT 
    grantee,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'data_admin'
  AND table_name = 'customers'
ORDER BY privilege_type;

\echo '';
\echo '✅ charlie_admin a TOUS les droits (y compris CREATE, DROP)';
\echo '';

-- ============================================================================
-- Simulation de tests de connexion
-- ============================================================================

\echo '========================================';
\echo 'SIMULATION DE TESTS';
\echo '========================================';
\echo '';

\echo 'Pour tester réellement les permissions, connectez-vous avec:';
\echo '';
\echo '1. Alice (lecture seule):';
\echo '   psql -U alice_analyst -d shop_db -h localhost';
\echo '   Mot de passe: analyst123';
\echo '';
\echo '   Test SELECT (devrait réussir):';
\echo '   SELECT * FROM customers;';
\echo '';
\echo '   Test INSERT (devrait échouer):';
\echo '   INSERT INTO customers (first_name, last_name, email)';
\echo '   VALUES (''Test'', ''User'', ''test@email.fr'');';
\echo '';
\echo '2. Bob (lecture + écriture limitée):';
\echo '   psql -U bob_manager -d shop_db -h localhost';
\echo '   Mot de passe: manager123';
\echo '';
\echo '   Test UPDATE orders (devrait réussir):';
\echo '   UPDATE orders SET status = ''COMPLETED'' WHERE order_id = 1;';
\echo '';
\echo '   Test DROP TABLE (devrait échouer):';
\echo '   DROP TABLE customers;';
\echo '';
\echo '3. Charlie (admin):';
\echo '   psql -U charlie_admin -d shop_db -h localhost';
\echo '   Mot de passe: admin123';
\echo '';
\echo '   Test CREATE TABLE (devrait réussir):';
\echo '   CREATE TABLE test_table (id SERIAL);';
\echo '';

-- ============================================================================
-- Statistiques finales
-- ============================================================================

\echo '========================================';
\echo 'RÉCAPITULATIF';
\echo '========================================';
\echo '';

\echo '📊 Vue créée:';
SELECT 
    table_name AS view_name,
    view_definition
FROM information_schema.views
WHERE table_name = 'customer_analytics';

\echo '';

\echo '👥 Rôles créés:';
SELECT rolname, rolcanlogin, rolcreaterole, rolcreatedb
FROM pg_roles
WHERE rolname IN ('sales_analyst', 'sales_manager', 'data_admin',
                  'alice_analyst', 'bob_manager', 'charlie_admin')
ORDER BY rolname;

\echo '';

\echo '🔐 Matrice des permissions:';
\echo '';
\echo 'Objet          | sales_analyst | sales_manager | data_admin';
\echo '---------------|---------------|---------------|------------';
\echo 'SELECT tables  |      ✅       |      ✅       |     ✅';
\echo 'INSERT orders  |      ❌       |      ✅       |     ✅';
\echo 'UPDATE orders  |      ❌       |      ✅       |     ✅';
\echo 'DELETE orders  |      ❌       |      ✅       |     ✅';
\echo 'UPDATE products|      ❌       |   ✅ (limité) |     ✅';
\echo 'CREATE TABLE   |      ❌       |      ❌       |     ✅';
\echo 'DROP TABLE     |      ❌       |      ❌       |     ✅';
\echo 'GRANT perms    |      ❌       |      ❌       |     ✅';
\echo '';

\echo '========================================';
\echo '✅ Exercice 6 terminé!';
\echo '========================================';
\echo '';

-- Note: Les utilisateurs et rôles persistent après cette session
-- Pour les supprimer:
-- DROP USER alice_analyst;
-- DROP USER bob_manager;
-- DROP USER charlie_admin;
-- DROP ROLE sales_analyst;
-- DROP ROLE sales_manager;
-- DROP ROLE data_admin;
