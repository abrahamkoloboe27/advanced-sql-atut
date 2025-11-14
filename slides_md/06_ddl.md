# 06 - DDL : CREATE / ALTER / DROP / TRUNCATE 🏗️

## Objectif
Maîtriser les commandes DDL pour définir et modifier la structure d'une base de données PostgreSQL.

## Contenu

### 🔨 CREATE TABLE
Créer une nouvelle table avec colonnes et contraintes.

**Syntaxe de base** :
```sql
CREATE TABLE nom_table (
    colonne1 TYPE CONTRAINTES,
    colonne2 TYPE CONTRAINTES,
    ...
);
```

**Contraintes courantes** :
- `PRIMARY KEY` : Clé primaire (unique, not null)
- `FOREIGN KEY` : Clé étrangère (relation)
- `UNIQUE` : Valeurs uniques
- `NOT NULL` : Obligatoire
- `CHECK` : Validation personnalisée
- `DEFAULT` : Valeur par défaut

### 🔧 ALTER TABLE
Modifier la structure d'une table existante.

**Opérations courantes** :
- `ADD COLUMN` : Ajouter une colonne
- `DROP COLUMN` : Supprimer une colonne
- `ALTER COLUMN` : Modifier type/contraintes
- `ADD CONSTRAINT` : Ajouter une contrainte
- `RENAME` : Renommer table/colonne

### 🗑️ DROP TABLE
Supprimer une table et toutes ses données (⚠️ irréversible).

**Options** :
- `CASCADE` : Supprime aussi les objets dépendants
- `RESTRICT` : Échoue si des dépendances existent

### 🧹 TRUNCATE TABLE
Vider une table rapidement (plus rapide que DELETE).

**Différences avec DELETE** :
- TRUNCATE : Réinitialise auto-increment, pas de WHERE, pas de triggers
- DELETE : Ligne par ligne, WHERE possible, déclenche triggers

## Illustration suggérée
- Schéma montrant évolution d'une table (CREATE → ALTER → DROP)
- Tableau comparatif TRUNCATE vs DELETE

## Exemple (entrée)

Créons la table `customers` :

## Requête SQL
```sql
-- CREATE : Créer la table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INSERT quelques données
INSERT INTO customers (first_name, last_name, email) VALUES
    ('Alice', 'Martin', 'alice@example.com'),
    ('Bob', 'Dupont', 'bob@example.com');

-- ALTER : Ajouter une colonne
ALTER TABLE customers ADD COLUMN phone VARCHAR(20);

-- ALTER : Ajouter une contrainte
ALTER TABLE customers 
ADD CONSTRAINT check_phone_format 
CHECK (phone ~ '^\+?[0-9]{10,15}$' OR phone IS NULL);

-- Voir la structure
SELECT customer_id, first_name, email, phone FROM customers;
```

## Résultat (table)

| customer_id | first_name | email | phone |
|-------------|------------|-------|-------|
| 1 | Alice | alice@example.com | NULL |
| 2 | Bob | bob@example.com | NULL |

## Notes pour le présentateur
- 🎯 **Message clé** : DDL définit le "squelette" de la base - réfléchir avant de créer, modifier est plus coûteux
- **Bonnes pratiques** :
  - ✅ Toujours définir PRIMARY KEY
  - ✅ Utiliser FOREIGN KEY pour maintenir l'intégrité référentielle
  - ✅ Ajouter des CHECK pour validation métier
  - ✅ Créer des index APRÈS insertion de données (plus rapide)
- ⚠️ **Danger DROP** : Toujours sauvegarder avant ! Pas de confirmation par défaut
- ⚠️ **ALTER en production** : Peut bloquer la table, prévoir une fenêtre de maintenance
- **Démo live** : Créer customers, ajouter une colonne, montrer l'erreur si on tente d'insérer un email dupliqué
- SERIAL = auto-increment PostgreSQL (équivalent AUTO_INCREMENT MySQL)
