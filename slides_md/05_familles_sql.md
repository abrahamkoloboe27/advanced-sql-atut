# 05 - Les 4 Familles SQL : DDL / DML / DCL / TCL 📊

## Objectif
Comprendre les 4 catégories de commandes SQL et leur rôle respectif dans la gestion d'une base de données.

## Contenu

### 🗂️ Vue d'ensemble

SQL est divisé en **4 familles** de commandes, chacune ayant un rôle distinct :

### 1️⃣ DDL - Data Definition Language
**Rôle** : Définir la structure de la base (schéma)

| Commande | Action |
|----------|--------|
| CREATE | Créer une table, vue, index, base |
| ALTER | Modifier la structure d'une table |
| DROP | Supprimer une table, vue, index |
| TRUNCATE | Vider une table (rapide, pas de rollback) |

**Exemple** : `CREATE TABLE customers (...);`

### 2️⃣ DML - Data Manipulation Language
**Rôle** : Manipuler les données dans les tables

| Commande | Action |
|----------|--------|
| SELECT | Lire des données |
| INSERT | Ajouter de nouvelles lignes |
| UPDATE | Modifier des lignes existantes |
| DELETE | Supprimer des lignes |
| MERGE* | Insérer ou mettre à jour (Upsert) |

**Exemple** : `SELECT * FROM customers WHERE city = 'Paris';`

*PostgreSQL utilise `INSERT ... ON CONFLICT` pour l'upsert

### 3️⃣ DCL - Data Control Language
**Rôle** : Gérer les permissions et la sécurité

| Commande | Action |
|----------|--------|
| GRANT | Accorder des permissions |
| REVOKE | Retirer des permissions |
| CREATE ROLE | Créer un rôle/utilisateur |
| ALTER ROLE | Modifier un rôle |

**Exemple** : `GRANT SELECT ON customers TO analyst_role;`

### 4️⃣ TCL - Transaction Control Language
**Rôle** : Gérer les transactions (atomicité)

| Commande | Action |
|----------|--------|
| BEGIN | Démarrer une transaction |
| COMMIT | Valider les modifications |
| ROLLBACK | Annuler les modifications |
| SAVEPOINT | Créer un point de sauvegarde |

**Exemple** : `BEGIN; UPDATE ...; COMMIT;`

## Illustration suggérée
- Tableau synthétique des 4 familles avec icônes
- Diagramme montrant le cycle de vie d'une base (DDL → DML → DCL → TCL)

## Exemple (entrée)

**Scénario complet utilisant les 4 familles** :

```sql
-- DDL : Créer la table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

-- DML : Insérer des données
INSERT INTO customers (name) VALUES ('Alice');

-- DCL : Donner accès en lecture
GRANT SELECT ON customers TO analyst_role;

-- TCL : Transaction sécurisée
BEGIN;
UPDATE customers SET name = 'Alice Dupont' WHERE customer_id = 1;
COMMIT;
```

## Requête SQL
```sql
-- Exemple combinant DDL et DML
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    price NUMERIC(10,2) CHECK (price > 0)
);

INSERT INTO products (name, price) VALUES 
    ('Laptop', 899.99),
    ('Souris', 29.99);

SELECT * FROM products;
```

## Résultat (table)

| product_id | name | price |
|------------|------|-------|
| 1 | Laptop | 899.99 |
| 2 | Souris | 29.99 |

## Notes pour le présentateur
- 🎯 **Message clé** : Chaque famille SQL a un rôle précis - structure (DDL), données (DML), sécurité (DCL), cohérence (TCL)
- **Mnémonique** : 
  - **D**DL = **D**éfinir
  - **D**ML = **D**onnées
  - **D**CL = **D**roits
  - **T**CL = **T**ransactions
- ⚠️ TRUNCATE est DDL (pas DML) car il ne peut pas être annulé par ROLLBACK dans certains SGBDR
- En pratique, 80% du temps on utilise DML (surtout SELECT), 15% DDL, 5% DCL/TCL
- Les développeurs utilisent surtout DML, les DBAs utilisent beaucoup DDL et DCL
