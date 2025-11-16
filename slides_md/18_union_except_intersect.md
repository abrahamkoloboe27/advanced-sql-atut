# 18 - UNION, EXCEPT, INTERSECT : Opérations Ensemblistes 🔀

## Objectif
Maîtriser les opérateurs ensemblistes pour combiner, soustraire ou trouver l'intersection de plusieurs résultats de requêtes.

## Contenu

### 🎯 Opérations ensemblistes
Combiner les résultats de plusieurs SELECT en un seul résultat.

**Prérequis** :
- ✅ Même nombre de colonnes dans chaque SELECT
- ✅ Types compatibles (même ordre)
- ✅ Noms de colonnes du premier SELECT utilisés

### 🔀 UNION : Fusion (sans doublons)
Combine les résultats et élimine les doublons.

**Syntaxe** :
```sql
SELECT col1, col2 FROM table1
UNION
SELECT col1, col2 FROM table2;
```

**UNION ALL** : Garde les doublons (plus rapide).

### ➖ EXCEPT : Différence
Retourne les lignes du premier SELECT qui ne sont pas dans le second.

**Syntaxe** :
```sql
SELECT col1, col2 FROM table1
EXCEPT
SELECT col1, col2 FROM table2;
```

### ∩ INTERSECT : Intersection
Retourne uniquement les lignes présentes dans TOUS les SELECT.

**Syntaxe** :
```sql
SELECT col1, col2 FROM table1
INTERSECT
SELECT col1, col2 FROM table2;
```

### 📊 Comparaison

| Opérateur | Analogie ensemble | Doublons |
|-----------|-------------------|----------|
| UNION | A ∪ B | Éliminés |
| UNION ALL | A ∪ B | Gardés |
| EXCEPT | A - B | Éliminés |
| INTERSECT | A ∩ B | Éliminés |

## Illustration suggérée
- Diagrammes de Venn pour UNION, EXCEPT, INTERSECT
- Tableau montrant résultats visuels de chaque opération

## Exemple (entrée)

**Table customers_2023**
| customer_id | name |
|-------------|------|
| 1 | Alice |
| 2 | Bob |
| 3 | Charlie |

**Table customers_2024**
| customer_id | name |
|-------------|------|
| 2 | Bob |
| 3 | Charlie |
| 4 | Diana |

## Requête SQL
```sql
-- 1. UNION : Tous les clients (2023 + 2024, sans doublons)
SELECT customer_id, name FROM customers_2023
UNION
SELECT customer_id, name FROM customers_2024
ORDER BY customer_id;

-- 2. UNION ALL : Tous les clients (avec doublons)
SELECT customer_id, name FROM customers_2023
UNION ALL
SELECT customer_id, name FROM customers_2024
ORDER BY customer_id;

-- 3. EXCEPT : Clients de 2023 qui ne sont plus là en 2024
SELECT customer_id, name FROM customers_2023
EXCEPT
SELECT customer_id, name FROM customers_2024;

-- 4. INTERSECT : Clients présents en 2023 ET 2024
SELECT customer_id, name FROM customers_2023
INTERSECT
SELECT customer_id, name FROM customers_2024;

-- 5. Cas pratique : Produits en stock OU en commande
SELECT product_id, name FROM products WHERE stock > 0
UNION
SELECT product_id, name FROM products p
WHERE EXISTS (SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id);
```

## Résultat (table)

**UNION (sans doublons)** :
| customer_id | name |
|-------------|------|
| 1 | Alice |
| 2 | Bob |
| 3 | Charlie |
| 4 | Diana |

**UNION ALL (avec doublons)** :
| customer_id | name |
|-------------|------|
| 1 | Alice |
| 2 | Bob |
| 2 | Bob |
| 3 | Charlie |
| 3 | Charlie |
| 4 | Diana |

**EXCEPT (clients perdus)** :
| customer_id | name |
|-------------|------|
| 1 | Alice |

**INTERSECT (clients fidèles)** :
| customer_id | name |
|-------------|------|
| 2 | Bob |
| 3 | Charlie |

## Notes pour le présentateur
- 🎯 **Message clé** : Les opérateurs ensemblistes permettent de combiner des résultats de requêtes comme on combine des ensembles mathématiques
- **Analogie** : 
  - UNION = Réunion de listes (sans doublons)
  - EXCEPT = "Qui est dans A mais pas dans B ?"
  - INTERSECT = "Qui est dans A ET dans B ?"
- **Démonstration live** :
  1. UNION vs UNION ALL avec COUNT(*) pour montrer l'élimination des doublons
  2. EXCEPT pour churn analysis (clients qui ont quitté)
  3. INTERSECT pour clients fidèles (présents dans 2+ périodes)
- **Performance** :
  - UNION coûte plus cher que UNION ALL (élimination doublons = tri/hachage)
  - Utiliser UNION ALL si doublons impossibles ou acceptables
  - EXCEPT/INTERSECT peuvent être remplacés par JOIN parfois (mais moins lisible)
- **Erreur fréquente** :
  ```sql
  -- ❌ ERREUR : Nombre de colonnes différent
  SELECT id, name FROM table1
  UNION
  SELECT id FROM table2;
  
  -- ✅ CORRECT :
  SELECT id, name FROM table1
  UNION
  SELECT id, NULL AS name FROM table2;
  ```
- **Bonnes pratiques** :
  - ✅ Toujours ajouter ORDER BY après les opérations ensemblistes
  - ✅ Utiliser UNION ALL par défaut (performance) sauf si doublons indésirables
  - ✅ Commenter pourquoi vous utilisez EXCEPT/INTERSECT (logique métier)
- **Cas réel** : 
  - Consolidation de données de plusieurs sources (UNION)
  - Analyse de churn (EXCEPT)
  - Segmentation clients (INTERSECT)
