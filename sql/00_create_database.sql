-- ============================================================================
-- Script: 00_create_database.sql
-- Description: Création de la base de données shop_db et du schéma principal
-- Cible: PostgreSQL 15+
-- ============================================================================

-- ⚠️ Note: Ce script peut être exécuté manuellement si nécessaire
-- La base de données est normalement créée automatiquement par Docker

-- CREATE DATABASE ne peut pas être exécuté dans une transaction
-- et doit être lancé par un super-utilisateur

-- CREATE DATABASE shop_db
--     WITH 
--     OWNER = pguser
--     ENCODING = 'UTF8'
--     LC_COLLATE = 'en_US.utf8'
--     LC_CTYPE = 'en_US.utf8'
--     TABLESPACE = pg_default
--     CONNECTION LIMIT = -1;

-- COMMENT ON DATABASE shop_db IS 'Base de données fictive pour séance pratique SQL';

-- Connexion à la base shop_db

-- ============================================================================
-- Création du schéma public (existe par défaut dans PostgreSQL)
-- ============================================================================

-- Le schéma public est créé automatiquement
-- On peut créer des schémas additionnels pour organiser les objets

-- Exemple: Création d'un schéma pour les vues analytiques
CREATE SCHEMA IF NOT EXISTS analytics;

COMMENT ON SCHEMA analytics IS 'Schéma pour les vues et tables analytiques';

-- ============================================================================
-- Configuration du search_path (chemins de recherche des schémas)
-- ============================================================================

-- Définir le search_path par défaut pour trouver les objets dans public puis analytics
ALTER DATABASE shop_db SET search_path TO public, analytics;

-- ============================================================================
-- Messages de confirmation
-- ============================================================================

\echo '✅ Base de données shop_db configurée avec succès!'
\echo '📋 Schémas disponibles: public, analytics'
