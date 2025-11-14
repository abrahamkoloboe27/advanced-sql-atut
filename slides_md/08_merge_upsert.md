# 08 - MERGE / Upsert PostgreSQL 🔄

## Objectif
Comprendre comment gérer les insertions avec gestion de conflits (upsert) en PostgreSQL avec INSERT ... ON CONFLICT.

## Contenu

### 🎯 C'est quoi un Upsert ?
**Upsert** = UPDATE + INSERT  
→ Insérer si la ligne n'existe pas, sinon mettre à jour.

**Cas d'usage** :
- Synchronisation de données
- Import de fichiers CSV
- Cache de données
- Compteurs (vues, likes)

### 📊 MERGE (SQL standard)
La commande `MERGE` existe dans le standard SQL et PostgreSQL 15+.

**Syntaxe** :
```sql
MERGE INTO target USING source ON condition
WHEN MATCHED THEN UPDATE SET ...
WHEN NOT MATCHED THEN INSERT ...;
```

⚠️ **PostgreSQL < 15** : MERGE n'existe pas, utiliser `INSERT ... ON CONFLICT`

### 🔧 INSERT ... ON CONFLICT (PostgreSQL)
Alternative PostgreSQL pour l'upsert (disponible depuis PostgreSQL 9.5).

**Syntaxe** :
```sql
INSERT INTO table (col1, col2, ...) 
VALUES (val1, val2, ...)
ON CONFLICT (colonne_unique) 
DO UPDATE SET col1 = EXCLUDED.col1, ...;
```

**Options** :
- `DO NOTHING` : Ignorer le conflit silencieusement
- `DO UPDATE` : Mettre à jour avec nouvelles valeurs
- `EXCLUDED` : Référence aux valeurs tentées d'insertion

### 🔑 Prérequis
La colonne du conflit doit avoir une contrainte `UNIQUE` ou être `PRIMARY KEY`.

## Illustration suggérée
- Diagramme de décision : Existe déjà ? → UPDATE : INSERT
- Comparaison MERGE vs INSERT ON CONFLICT

## Exemple (entrée)

**Table products (état initial)**
| product_id | name | price | stock |
|------------|------|-------|-------|
| 1 | Laptop | 899.99 | 10 |
| 2 | Souris | 29.99 | 50 |

## Requête SQL
```sql
-- Créer table avec contrainte unique sur name
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    price NUMERIC(10,2),
    stock INTEGER DEFAULT 0
);

-- Données initiales
INSERT INTO products (name, price, stock) VALUES
    ('Laptop', 899.99, 10),
    ('Souris', 29.99, 50);

-- UPSERT : Insérer ou mettre à jour
INSERT INTO products (name, price, stock) 
VALUES 
    ('Laptop', 849.99, 15),  -- Existe → UPDATE
    ('Clavier', 79.99, 20)    -- N'existe pas → INSERT
ON CONFLICT (name) 
DO UPDATE SET 
    price = EXCLUDED.price,
    stock = products.stock + EXCLUDED.stock;

-- Voir le résultat
SELECT * FROM products ORDER BY product_id;
```

## Résultat (table)

**Après UPSERT** :
| product_id | name | price | stock |
|------------|------|-------|-------|
| 1 | Laptop | 849.99 | 25 |
| 2 | Souris | 29.99 | 50 |
| 3 | Clavier | 79.99 | 20 |

**Explications** :
- Laptop existait → prix mis à jour + stock additionné (10 + 15)
- Clavier n'existait pas → nouvelle ligne insérée

## Notes pour le présentateur
- 🎯 **Message clé** : INSERT ON CONFLICT évite les erreurs de doublon et réduit le code (pas besoin de SELECT puis IF)
- **Bonnes pratiques** :
  - ✅ Utiliser `DO UPDATE` pour mettre à jour avec logique métier
  - ✅ Utiliser `DO NOTHING` pour ignorer silencieusement les doublons
  - ✅ Combiner avec RETURNING pour voir les lignes affectées
- **Démo live** :
  1. Tentative INSERT sans ON CONFLICT → erreur de duplication
  2. Même INSERT avec ON CONFLICT DO NOTHING → pas d'erreur
  3. Même INSERT avec ON CONFLICT DO UPDATE → mise à jour
- ⚠️ **Version PostgreSQL** : Vérifier version avec `SELECT version();` - MERGE disponible à partir de PostgreSQL 15
- **Cas réel** : Importer un fichier CSV de produits quotidiennement (nouveaux produits + prix mis à jour)
