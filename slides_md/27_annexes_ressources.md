# 27 - Annexes, Cheatsheet & Ressources 📚

## Objectif
Fournir un récapitulatif des commandes essentielles et des ressources pour approfondir SQL et PostgreSQL.

## Contenu

### 📋 SQL Cheatsheet

**DDL - Structure**
```sql
CREATE TABLE nom (col TYPE CONSTRAINT);
ALTER TABLE nom ADD COLUMN col TYPE;
ALTER TABLE nom DROP COLUMN col;
DROP TABLE nom [CASCADE];
TRUNCATE TABLE nom;
CREATE INDEX nom ON table(col);
CREATE VIEW nom AS SELECT ...;
```

**DML - Données**
```sql
SELECT col FROM table WHERE condition;
INSERT INTO table (cols) VALUES (vals);
UPDATE table SET col = val WHERE condition;
DELETE FROM table WHERE condition;
INSERT ... ON CONFLICT (col) DO UPDATE SET ...;
```

**DCL - Permissions**
```sql
CREATE ROLE nom;
GRANT privilege ON object TO role;
REVOKE privilege ON object FROM role;
```

**TCL - Transactions**
```sql
BEGIN;
COMMIT;
ROLLBACK;
SAVEPOINT nom;
ROLLBACK TO SAVEPOINT nom;
```

**Agrégations**
```sql
COUNT(*), SUM(col), AVG(col), MIN(col), MAX(col)
GROUP BY cols HAVING condition
```

**Jointures**
```sql
INNER JOIN table ON condition
LEFT JOIN table ON condition
RIGHT JOIN table ON condition
FULL OUTER JOIN table ON condition
CROSS JOIN table
```

**Window Functions**
```sql
ROW_NUMBER() OVER (PARTITION BY col ORDER BY col)
RANK() OVER (ORDER BY col)
LAG(col) OVER (ORDER BY col)
SUM(col) OVER (PARTITION BY col ORDER BY col)
```

**Opérateurs ensemblistes**
```sql
SELECT ... UNION [ALL] SELECT ...
SELECT ... EXCEPT SELECT ...
SELECT ... INTERSECT SELECT ...
```

**Fonctions utiles**
```sql
COALESCE(val1, val2, default)
CASE WHEN condition THEN result ELSE default END
DATE_TRUNC('unit', date)
EXTRACT(unit FROM date)
UPPER(text), LOWER(text), LENGTH(text)
ROUND(number, decimals)
```

### 🔧 Commandes psql utiles

```bash
\l                    # Lister bases de données
\c database           # Se connecter à une base
\dt                   # Lister tables
\d table              # Décrire structure table
\du                   # Lister utilisateurs/rôles
\dp table             # Voir permissions table
\timing               # Activer/désactiver chronométrage
\x                    # Affichage étendu (vertical)
\i fichier.sql        # Exécuter script SQL
\o fichier.txt        # Rediriger sortie vers fichier
\q                    # Quitter psql
```

### 📚 Ressources recommandées

**Documentation officielle**
- 📖 PostgreSQL Docs : https://www.postgresql.org/docs/
- 📖 SQL Standard : https://www.iso.org/standard/63555.html

**Tutoriels interactifs**
- 🎮 pgexercises.com : Exercices SQL pratiques
- 🎮 SQLZoo : Tutoriels interactifs
- 🎮 LeetCode Database : Problèmes SQL de type interview
- 🎮 HackerRank SQL : Challenges progressifs

**Outils**
- 🔧 pgAdmin : Interface graphique PostgreSQL
- 🔧 DBeaver : Client multi-DB gratuit
- 🔧 DataGrip (JetBrains) : IDE SQL payant mais puissant
- 🔧 explain.depesz.com : Visualiser plans EXPLAIN
- 🔧 pgFormatter : Formatter SQL
- 🔧 sqlfluff : Linter SQL

**Livres**
- 📚 "PostgreSQL: Up and Running" - Regina Obe & Leo Hsu
- 📚 "SQL Performance Explained" - Markus Winand
- 📚 "Designing Data-Intensive Applications" - Martin Kleppmann

**Blogs & Articles**
- 📝 Use The Index, Luke : https://use-the-index-luke.com/
- 📝 Postgres Weekly : Newsletter hebdomadaire
- 📝 CrunchyData Blog : Trucs et astuces PostgreSQL
- 📝 2ndQuadrant Blog : PostgreSQL avancé

**Communautés**
- 💬 PostgreSQL Slack : https://postgres-slack.herokuapp.com/
- 💬 Reddit r/PostgreSQL
- 💬 Stack Overflow tag [postgresql]
- 💬 PostgreSQL IRC : #postgresql sur Freenode

**Extensions PostgreSQL utiles**
- 🧩 pg_stat_statements : Monitoring requêtes
- 🧩 pgcrypto : Cryptographie
- 🧩 pg_trgm : Recherche floue (fuzzy search)
- 🧩 PostGIS : Données géospatiales
- 🧩 TimescaleDB : Time-series
- 🧩 pgvector : Vecteurs (ML/AI embeddings)

**Migrations & CI/CD**
- 🔄 Flyway : https://flywaydb.org/
- 🔄 Liquibase : https://www.liquibase.org/
- 🔄 Alembic (Python) : https://alembic.sqlalchemy.org/
- 🔄 Sqitch : https://sqitch.org/

### 🎓 Continuer à apprendre

**Sujets avancés à explorer** :
- 🔹 CTE récursives (arbres hiérarchiques)
- 🔹 PL/pgSQL (procédures stockées)
- 🔹 Triggers et Event Triggers
- 🔹 Partitioning (tables partitionnées)
- 🔹 Foreign Data Wrappers (FDW)
- 🔹 Réplication et High Availability
- 🔹 Full-text search (tsvector, tsquery)
- 🔹 JSONB (données semi-structurées)
- 🔹 Row-Level Security (RLS)
- 🔹 Performance tuning avancé

**Certifications**
- 🎖️ PostgreSQL Associate Certification (EDB)
- 🎖️ PostgreSQL Professional Certification (EDB)

## Illustration suggérée
- Infographie des ressources par catégorie
- QR codes vers ressources clés

## Exemple (entrée)

**Mémo rapide : Requête type**

## Requête SQL
```sql
-- Template requête complète
WITH aggregated_data AS (
    SELECT 
        category,
        COUNT(*) AS num_products,
        AVG(price) AS avg_price,
        SUM(stock) AS total_stock
    FROM products
    WHERE stock > 0
    GROUP BY category
    HAVING COUNT(*) > 2
)
SELECT 
    a.category,
    a.num_products,
    ROUND(a.avg_price, 2) AS avg_price,
    a.total_stock,
    CASE 
        WHEN a.total_stock > 100 THEN 'Bien stocké'
        WHEN a.total_stock > 50 THEN 'Stock moyen'
        ELSE 'Stock faible'
    END AS stock_status
FROM aggregated_data a
ORDER BY a.avg_price DESC;
```

## Résultat (table)

**Exemple de sortie** :
| category | num_products | avg_price | total_stock | stock_status |
|----------|--------------|-----------|-------------|--------------|
| Informatique | 4 | 320.50 | 85 | Stock moyen |
| Papeterie | 3 | 12.99 | 150 | Bien stocké |

## Notes pour le présentateur
- 🎯 **Message clé** : SQL est un voyage continu - cette formation est le début, pas la fin
- **Message de clôture** :
  - Féliciter participants pour avoir complété la formation
  - Rappeler que maîtrise SQL = pratique régulière
  - Encourager à continuer avec exercices, projets perso, contributions open source
- **Partage final** :
  - Distribuer lien vers ce repo GitHub (⭐ star apprécié !)
  - Partager slides PDF si demandé
  - Contact formateur pour questions post-formation
- **Call to action** :
  - ✅ Mettre en pratique dans vos projets dès cette semaine
  - ✅ Rejoindre communauté PostgreSQL (Slack, Reddit)
  - ✅ Faire au moins 1 exercice pgexercises.com par semaine
  - ✅ Lire 1 article Use The Index Luke par mois
  - ✅ Partager vos apprentissages avec votre équipe
- **Feedback** :
  - Demander retours sur la formation (formulaire, oral)
  - Quels sujets approfondir ?
  - Quels outils manquent ?
  - Format préféré (slides, live coding, exercices) ?
- **Suivi** :
  - Session Q&A dans 1 mois (optionnel)
  - Canal Slack/Discord pour questions continues
  - Partage d'articles intéressants
- **Remerciements** :
  - Merci pour votre participation active
  - Merci pour vos questions pertinentes
  - N'hésitez pas à rester en contact
- **Citation finale** :
  > "SQL is the most valuable skill in data. Master it, and doors open."  
  > — Data Engineering Community

**Bon courage dans votre parcours SQL ! 🚀**
