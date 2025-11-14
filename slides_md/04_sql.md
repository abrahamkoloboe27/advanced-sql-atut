# 04 - C'est quoi SQL ? 💬

## Objectif
Comprendre ce qu'est SQL, son paradigme déclaratif et pourquoi c'est le langage universel des bases de données relationnelles.

## Contenu

### 📖 Définition
**SQL** (Structured Query Language) est un langage :
- ✅ **Déclaratif** : On dit "quoi" faire, pas "comment" le faire
- ✅ **Standardisé** : ANSI/ISO SQL depuis 1986
- ✅ **Universel** : Fonctionne sur presque tous les SGBDR
- ✅ **Puissant** : Manipulation, définition, contrôle des données

### 🔄 Déclaratif vs Impératif

**Approche impérative (Python, Java, C++)** :
```python
# On décrit COMMENT faire
results = []
for customer in customers:
    if customer.city == 'Paris':
        results.append(customer)
```

**Approche déclarative (SQL)** :
```sql
-- On décrit QUOI obtenir
SELECT * FROM customers WHERE city = 'Paris';
```

**Avantages du déclaratif** :
- 🚀 Le SGBDR optimise automatiquement l'exécution
- 📖 Code plus lisible et concis
- 🔧 Moins de bugs (pas de gestion de boucles/index)

### 🎯 Les 4 rôles de SQL
1. **DDL** (Data Definition Language) : Définir la structure
2. **DML** (Data Manipulation Language) : Manipuler les données
3. **DCL** (Data Control Language) : Gérer les permissions
4. **TCL** (Transaction Control Language) : Gérer les transactions

### 🌍 SQL dans l'écosystème tech
- **Backend** : ORM (Hibernate, Entity Framework, SQLAlchemy)
- **Data Engineering** : ETL, pipelines de données
- **Analytics** : BI tools (Tableau, Power BI, Looker)
- **Data Science** : Préparation de données, exploration
- **DevOps** : Gestion de configurations, audit logs

## Illustration suggérée
- Schéma comparant code impératif vs code déclaratif
- Timeline de l'évolution SQL (1970 → 2024)
- Logos d'outils utilisant SQL

## Exemple (entrée)

**Table products**
| product_id | name | price | category |
|------------|------|-------|----------|
| 1 | Laptop | 899.99 | Informatique |
| 2 | Souris | 29.99 | Informatique |
| 3 | Cahier | 5.99 | Papeterie |

## Requête SQL
```sql
-- Requête déclarative : filtrer et trier
SELECT name, price 
FROM products 
WHERE category = 'Informatique'
ORDER BY price DESC;
```

## Résultat (table)

| name | price |
|------|-------|
| Laptop | 899.99 |
| Souris | 29.99 |

## Notes pour le présentateur
- 🎯 **Message clé** : SQL est déclaratif = vous décrivez le résultat souhaité, le SGBDR trouve le meilleur chemin
- Comparer avec une commande au restaurant : vous dites "Je veux un steak" (déclaratif), pas "Prenez la viande, faites-la cuire..." (impératif)
- ⚠️ Préciser que chaque SGBDR a des extensions propriétaires (PL/pgSQL pour PostgreSQL) mais le SQL standard fonctionne partout
- **Fun fact** : SQL a été créé par IBM dans les années 1970, inspiré par les travaux d'Edgar Codd
- Mentionner que SQL est le langage n°3 le plus demandé dans les offres d'emploi tech (après Python et JavaScript)
