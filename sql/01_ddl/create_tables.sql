-- ============================================================================
-- Script: create_tables.sql
-- Description: Création des tables principales de la base shop_db
-- Tables: customers, products, orders
-- ============================================================================

-- ============================================================================
-- Mot-clé: CREATE TABLE
-- Description: Crée une nouvelle table dans la base de données
-- Syntaxe: CREATE TABLE nom_table (colonne1 type [contrainte], ...)
-- ============================================================================

-- Table 1: CUSTOMERS (Clients)
-- ============================================================================
-- Stocke les informations des clients de la boutique
-- Contraintes: 
--   - customer_id: Clé primaire auto-incrémentée (SERIAL = INTEGER + AUTO_INCREMENT)
--   - email: Unique pour éviter les doublons
--   - created_at: Valeur par défaut = date actuelle

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,           -- SERIAL = INTEGER AUTO-INCREMENT
    first_name VARCHAR(50) NOT NULL,          -- Prénom (obligatoire)
    last_name VARCHAR(50) NOT NULL,           -- Nom (obligatoire)
    email VARCHAR(100) NOT NULL UNIQUE,       -- Email unique
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- Date de création
);

-- Ajout de commentaires sur la table et les colonnes (bonne pratique!)
COMMENT ON TABLE customers IS 'Table des clients de la boutique';
COMMENT ON COLUMN customers.customer_id IS 'Identifiant unique du client (clé primaire)';
COMMENT ON COLUMN customers.email IS 'Adresse email du client (unique)';
COMMENT ON COLUMN customers.created_at IS 'Date et heure de création du compte client';


-- Table 2: PRODUCTS (Produits)
-- ============================================================================
-- Stocke le catalogue des produits disponibles
-- Contraintes:
--   - product_id: Clé primaire auto-incrémentée
--   - price: Doit être positif (CHECK constraint)
--   - stock: Doit être >= 0

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,            -- ID unique du produit
    name VARCHAR(100) NOT NULL,               -- Nom du produit
    price NUMERIC(10, 2) NOT NULL CHECK (price > 0),  -- Prix (positif uniquement)
    category VARCHAR(50),                     -- Catégorie du produit
    stock INTEGER DEFAULT 0 CHECK (stock >= 0)  -- Quantité en stock (>= 0)
);

COMMENT ON TABLE products IS 'Catalogue des produits disponibles';
COMMENT ON COLUMN products.price IS 'Prix unitaire du produit (doit être > 0)';
COMMENT ON COLUMN products.stock IS 'Quantité disponible en stock';


-- Table 3: ORDERS (Commandes)
-- ============================================================================
-- Stocke les commandes passées par les clients
-- Contraintes:
--   - order_id: Clé primaire auto-incrémentée
--   - customer_id: Clé étrangère vers customers (ON DELETE CASCADE)
--   - total_amount: Montant total de la commande
--   - status: Statut de la commande (PENDING, COMPLETED, CANCELLED)

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,              -- ID unique de la commande
    customer_id INTEGER NOT NULL,             -- Référence au client
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Date de la commande
    total_amount NUMERIC(10, 2) NOT NULL CHECK (total_amount >= 0),  -- Montant total
    status VARCHAR(20) DEFAULT 'PENDING'      -- Statut de la commande
        CHECK (status IN ('PENDING', 'COMPLETED', 'CANCELLED'))
);

COMMENT ON TABLE orders IS 'Commandes passées par les clients';
COMMENT ON COLUMN orders.customer_id IS 'Référence au client (clé étrangère)';
COMMENT ON COLUMN orders.status IS 'Statut: PENDING, COMPLETED ou CANCELLED';


-- ============================================================================
-- Ajout des CONTRAINTES de clés étrangères (FOREIGN KEY)
-- ============================================================================
-- Mot-clé: ALTER TABLE ... ADD CONSTRAINT
-- Description: Ajoute une contrainte à une table existante
-- ON DELETE CASCADE: Si le client est supprimé, ses commandes sont aussi supprimées

ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customer 
FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id) 
ON DELETE CASCADE;

COMMENT ON CONSTRAINT fk_orders_customer ON orders IS 
'Clé étrangère vers customers avec suppression en cascade';


-- ============================================================================
-- Vérification de la création des tables
-- ============================================================================

\echo '✅ Tables créées avec succès!'
\echo '📋 Tables disponibles: customers, products, orders'
\echo ''

-- Lister les tables créées
\dt

-- Afficher la structure de chaque table
\echo ''
\echo '=== Structure de la table CUSTOMERS ==='
\d customers

\echo ''
\echo '=== Structure de la table PRODUCTS ==='
\d products

\echo ''
\echo '=== Structure de la table ORDERS ==='
\d orders
