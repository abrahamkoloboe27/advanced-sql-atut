# 11 - Pourquoi SQL est Important Aujourd'hui ? 🚀

## Objectif
Comprendre la pertinence de SQL dans l'écosystème technologique moderne (Big Data, Data Engineering, Analytics).

## Contenu

### 📊 SQL : Plus pertinent que jamais en 2024

**Faits marquants** :
- ✅ **50+ ans** d'existence (créé en 1974)
- ✅ **#1** langage pour la data (DevOps, Analytics, ML)
- ✅ **Universel** : Fonctionne sur 90% des systèmes de données
- ✅ **Performant** : Optimisations moteur > code applicatif

### 🌍 SQL dans les domaines modernes

**1️⃣ Big Data & Data Warehouses**
- Snowflake, BigQuery, Redshift → SQL comme interface
- Spark SQL, Presto, Trino → requêtes distribuées en SQL
- Lakehouse (Delta Lake, Iceberg) → SQL natif

**2️⃣ Data Engineering**
- ETL/ELT : dbt (Data Build Tool) → transformations en SQL
- Apache Airflow : orchestration de pipelines SQL
- Kafka + ksqlDB : streaming temps réel en SQL

**3️⃣ Data Analytics & BI**
- Tableau, Power BI, Looker → génèrent du SQL
- Jupyter Notebooks : %sql magic pour exploration
- Reverse ETL : Census, Hightouch → SQL vers outils métier

**4️⃣ Data Science & Machine Learning**
- Feature engineering : pandas → SQL-like (polars, duckDB)
- MLOps : Feature Store (Feast, Tecton) → requêtes SQL
- Prédictions en base : PostgresML, BigQuery ML

**5️⃣ Applications Modernes**
- GraphQL → traduit en SQL
- ORM (Prisma, Hibernate, Django ORM) → génèrent du SQL
- Serverless : Supabase, PlanetScale → API auto-générées sur SQL

### 💼 Opportunités professionnelles

**Rôles utilisant SQL quotidiennement** :
- Data Analyst ⭐⭐⭐
- Data Engineer ⭐⭐⭐
- Backend Developer ⭐⭐
- Analytics Engineer ⭐⭐⭐
- Business Intelligence ⭐⭐⭐
- Data Scientist ⭐⭐
- DevOps / SRE ⭐

**Salaire médian** (France, 2024) :
- Junior SQL : 35-45k€
- Confirmé : 45-65k€
- Senior + Data Engineering : 60-90k€

## Illustration suggérée
- Infographie : SQL au centre connecté à tous les domaines data
- Timeline : évolution SQL de 1974 à 2024
- Logos des outils modernes utilisant SQL

## Exemple (entrée)

**Cas concret : Analyse e-commerce**

**Table sales (ventes)**
| sale_id | product | amount | sale_date |
|---------|---------|--------|-----------|
| 1 | Laptop | 899.99 | 2024-01-15 |
| 2 | Souris | 29.99 | 2024-01-16 |
| 3 | Laptop | 899.99 | 2024-02-10 |

## Requête SQL
```sql
-- Analyse moderne : Ventes mensuelles avec croissance
WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', sale_date) AS month,
        SUM(amount) AS total_sales,
        COUNT(*) AS num_orders
    FROM sales
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT 
    month,
    total_sales,
    num_orders,
    LAG(total_sales) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month)) 
        / LAG(total_sales) OVER (ORDER BY month) * 100, 
        2
    ) AS growth_percent
FROM monthly_sales
ORDER BY month;
```

## Résultat (table)

| month | total_sales | num_orders | prev_month_sales | growth_percent |
|-------|-------------|------------|------------------|----------------|
| 2024-01-01 | 929.98 | 2 | NULL | NULL |
| 2024-02-01 | 899.99 | 1 | 929.98 | -3.23 |

## Notes pour le présentateur
- 🎯 **Message clé** : SQL n'est pas "vieux", c'est un fondement qui s'adapte aux nouvelles technologies
- **Argument principal** : Même avec NoSQL, Big Data, ML → SQL reste l'interface commune
- **Anecdotes** :
  - Google BigQuery traite des pétaoctets avec... du SQL
  - DuckDB : base SQL in-process plus rapide que pandas pour analytics
  - Modern Data Stack (Fivetran, dbt, Snowflake) : 100% SQL
- **Pourquoi SQL survit** :
  1. Déclaratif → facile à optimiser par le moteur
  2. Standardisé → portabilité entre systèmes
  3. Optimisé → 50 ans de recherche en bases de données
  4. Universel → tout le monde le connaît
- ⚠️ Ne pas opposer SQL à NoSQL/Python/etc. → complémentaires !
- **Conseil carrière** : Maîtriser SQL = ouvrir 80% des postes data
