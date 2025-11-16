# 15 - Fonctions : Numériques, Dates, Texte, CASE, COALESCE 🛠️

## Objectif
Maîtriser les fonctions PostgreSQL pour manipuler et transformer les données (calculs, dates, texte, logique conditionnelle).

## Contenu

### 🔢 Fonctions numériques

| Fonction | Description | Exemple |
|----------|-------------|---------|
| `ROUND(n, d)` | Arrondir à d décimales | `ROUND(15.678, 2)` → 15.68 |
| `CEIL(n)` | Arrondir au supérieur | `CEIL(15.1)` → 16 |
| `FLOOR(n)` | Arrondir à l'inférieur | `FLOOR(15.9)` → 15 |
| `ABS(n)` | Valeur absolue | `ABS(-10)` → 10 |
| `MOD(n, m)` | Modulo (reste) | `MOD(10, 3)` → 1 |

### 📅 Fonctions de dates

| Fonction | Description | Exemple |
|----------|-------------|---------|
| `CURRENT_DATE` | Date du jour | `2024-11-14` |
| `CURRENT_TIMESTAMP` | Date/heure actuelle | `2024-11-14 10:30:00` |
| `DATE_TRUNC('unit', date)` | Tronquer à l'unité | `DATE_TRUNC('month', '2024-11-14')` → `2024-11-01` |
| `EXTRACT(unit FROM date)` | Extraire partie | `EXTRACT(YEAR FROM date)` |
| `AGE(date1, date2)` | Différence | `AGE('2024-01-01', '2023-01-01')` → 1 year |
| `date + INTERVAL` | Ajouter durée | `CURRENT_DATE + INTERVAL '7 days'` |

### 📝 Fonctions de texte

| Fonction | Description | Exemple |
|----------|-------------|---------|
| `UPPER(text)` | Majuscules | `UPPER('hello')` → 'HELLO' |
| `LOWER(text)` | Minuscules | `LOWER('HELLO')` → 'hello' |
| `LENGTH(text)` | Longueur | `LENGTH('hello')` → 5 |
| `CONCAT(t1, t2)` | Concaténation | `CONCAT('Hello', ' World')` |
| `SUBSTRING(text, start, len)` | Sous-chaîne | `SUBSTRING('Hello', 1, 3)` → 'Hel' |
| `TRIM(text)` | Supprimer espaces | `TRIM(' hello ')` → 'hello' |
| `REPLACE(text, old, new)` | Remplacer | `REPLACE('hello', 'l', 'L')` → 'heLLo' |

### 🔀 CASE : Logique conditionnelle
**Syntaxe** :
```sql
CASE 
    WHEN condition1 THEN résultat1
    WHEN condition2 THEN résultat2
    ELSE résultat_par_défaut
END
```

### 🛡️ COALESCE : Gérer les NULL
Retourne la première valeur non-NULL.
```sql
COALESCE(valeur1, valeur2, valeur_défaut)
```

## Illustration suggérée
- Tableau récapitulatif des fonctions par catégorie
- Exemples visuels de CASE (if/else en SQL)

## Exemple (entrée)

**Table products**
| product_id | name | price | created_at |
|------------|------|-------|------------|
| 1 | Laptop | 899.99 | 2024-01-15 |
| 2 | Souris | NULL | 2024-02-20 |
| 3 | Clavier | 79.99 | 2024-03-10 |

## Requête SQL
```sql
-- Exemple 1 : Fonctions numériques
SELECT 
    name,
    price,
    ROUND(price * 1.20, 2) AS price_with_tax,
    FLOOR(price) AS price_floor,
    CEIL(price) AS price_ceil
FROM products
WHERE price IS NOT NULL;

-- Exemple 2 : Fonctions de dates
SELECT 
    name,
    created_at,
    EXTRACT(YEAR FROM created_at) AS year,
    DATE_TRUNC('month', created_at) AS month,
    AGE(CURRENT_DATE, created_at) AS age_product
FROM products;

-- Exemple 3 : Fonctions texte
SELECT 
    UPPER(name) AS name_upper,
    LOWER(name) AS name_lower,
    LENGTH(name) AS name_length,
    CONCAT(name, ' - ', price::TEXT, '€') AS full_description
FROM products;

-- Exemple 4 : CASE (catégorisation par prix)
SELECT 
    name,
    price,
    CASE 
        WHEN price IS NULL THEN 'Prix inconnu'
        WHEN price < 50 THEN 'Bon marché'
        WHEN price BETWEEN 50 AND 500 THEN 'Moyen'
        ELSE 'Cher'
    END AS price_category
FROM products;

-- Exemple 5 : COALESCE (remplacer NULL)
SELECT 
    name,
    COALESCE(price, 0) AS price_or_zero,
    COALESCE(price::TEXT, 'Prix non défini') AS price_display
FROM products;
```

## Résultat (table)

**Exemple 1** :
| name | price | price_with_tax | price_floor | price_ceil |
|------|-------|----------------|-------------|------------|
| Laptop | 899.99 | 1079.99 | 899 | 900 |
| Clavier | 79.99 | 95.99 | 79 | 80 |

**Exemple 4** :
| name | price | price_category |
|------|-------|----------------|
| Laptop | 899.99 | Cher |
| Souris | NULL | Prix inconnu |
| Clavier | 79.99 | Moyen |

**Exemple 5** :
| name | price_or_zero | price_display |
|------|---------------|---------------|
| Laptop | 899.99 | 899.99 |
| Souris | 0 | Prix non défini |
| Clavier | 79.99 | 79.99 |

## Notes pour le présentateur
- 🎯 **Message clé** : Les fonctions permettent de transformer les données directement en SQL sans post-traitement applicatif
- **Démonstration live** :
  1. CASE pour créer des segments clients (VIP, Regular, Occasional) selon montant dépensé
  2. DATE_TRUNC pour analyser ventes par mois
  3. COALESCE pour gérer champs optionnels (téléphone, email secondaire)
- **Bonnes pratiques** :
  - ✅ Utiliser COALESCE pour valeurs par défaut (évite NULL dans résultats)
  - ✅ CASE pour catégorisation/scoring
  - ✅ DATE_TRUNC pour agréger par période (jour, semaine, mois)
  - ⚠️ Trop de fonctions dans WHERE = pas d'index utilisé
- **Piège fréquent** :
  ```sql
  -- ❌ CASE sans ELSE → NULL si aucune condition
  CASE WHEN price > 100 THEN 'Cher' END
  
  -- ✅ Toujours mettre ELSE
  CASE WHEN price > 100 THEN 'Cher' ELSE 'Abordable' END
  ```
- **Cas réel** : Rapport de ventes avec TVA, catégories de prix, ancienneté produits
