# 03 - C'est quoi un SGBDR ? 🗄️

## Objectif
Comprendre ce qu'est un Système de Gestion de Base de Données Relationnelle et son rôle dans les applications modernes.

## Contenu

### 📖 Définition
Un **SGBDR** (Système de Gestion de Base de Données Relationnelle) est un logiciel qui permet de :
- ✅ **Stocker** des données de manière structurée (tables avec lignes et colonnes)
- ✅ **Organiser** les données avec des relations (clés primaires, étrangères)
- ✅ **Gérer** l'accès concurrent et la sécurité
- ✅ **Garantir** l'intégrité et la cohérence des données (contraintes)

### 🔑 Principes clés
- **Modèle relationnel** : Données organisées en tables liées entre elles
- **Normalisation** : Éviter la redondance (1NF, 2NF, 3NF)
- **ACID** : Atomicité, Cohérence, Isolation, Durabilité
- **Langage SQL** : Interface standard pour interagir avec les données

### 🌟 Exemples de SGBDR populaires

| SGBDR | Type | Usage typique |
|-------|------|---------------|
| **PostgreSQL** | Open Source | Applications web, analytics, géospatial |
| **MySQL/MariaDB** | Open Source | Sites web, e-commerce |
| **Oracle** | Commercial | Entreprises, finance, ERP |
| **SQL Server** | Commercial | Écosystème Microsoft, .NET |
| **SQLite** | Embarqué | Mobile, desktop, prototypage |

### 🆚 SGBDR vs NoSQL
| Aspect | SGBDR | NoSQL |
|--------|-------|-------|
| Structure | Schéma fixe (tables) | Schéma flexible (documents, clés-valeurs) |
| Relations | Jointures natives | Relations manuelles |
| Transactions | ACID garanties | Éventuelle cohérence (BASE) |
| Cas d'usage | Données structurées, finance | Big Data, temps réel, scalabilité horizontale |

## Illustration suggérée
- Schéma d'une base de données relationnelle avec 3 tables liées
- Logos des principaux SGBDR
- Comparaison visuelle SGBDR vs NoSQL

## Exemple (entrée)

Schéma simple d'une base `shop_db` :

**Table customers**
| customer_id | first_name | email |
|-------------|------------|-------|
| 1 | Alice | alice@example.com |
| 2 | Bob | bob@example.com |

**Table orders**
| order_id | customer_id | total_amount |
|----------|-------------|--------------|
| 101 | 1 | 150.00 |
| 102 | 1 | 200.00 |
| 103 | 2 | 75.00 |

## Requête SQL
```sql
-- Exemple de relation entre tables avec une clé étrangère
SELECT 
    c.first_name,
    o.order_id,
    o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id = 1;
```

## Résultat (table)

| first_name | order_id | total_amount |
|------------|----------|--------------|
| Alice | 101 | 150.00 |
| Alice | 102 | 200.00 |

## Notes pour le présentateur
- 🎯 **Message clé** : Un SGBDR garantit la cohérence et l'intégrité des données grâce aux relations et contraintes
- Insister sur le fait que PostgreSQL est un SGBDR open source très puissant et conforme aux standards SQL
- ⚠️ Ne pas passer trop de temps sur la théorie SGBDR vs NoSQL (ce n'est pas le focus)
- Mentionner que PostgreSQL supporte aussi des fonctionnalités NoSQL (JSONB) pour la flexibilité
- **Anecdote** : PostgreSQL existe depuis 1996 et est utilisé par Instagram, Spotify, Apple
