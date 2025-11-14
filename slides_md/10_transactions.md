# 10 - Transactions : BEGIN / COMMIT / ROLLBACK 🔄

## Objectif
Maîtriser les commandes de gestion de transactions (TCL) pour garantir l'intégrité des données lors d'opérations multiples.

## Contenu

### 🎯 C'est quoi une Transaction ?
Une **transaction** = séquence d'opérations SQL traitées comme une unité atomique.

**Principe** : Tout ou rien (propriété ACID)

### 📝 Commandes TCL

**BEGIN / START TRANSACTION**
```sql
BEGIN; -- Démarre une transaction
```

**COMMIT**
```sql
COMMIT; -- Valide toutes les modifications
```

**ROLLBACK**
```sql
ROLLBACK; -- Annule toutes les modifications
```

**SAVEPOINT**
```sql
SAVEPOINT nom;           -- Crée un point de sauvegarde
ROLLBACK TO SAVEPOINT nom; -- Revient au point
```

### 🔧 Modes auto-commit
**PostgreSQL par défaut** : Chaque commande est auto-commit  
**En transaction** : Désactivé jusqu'au COMMIT/ROLLBACK

### ⚠️ Quand utiliser les transactions ?
- ✅ Opérations multiples liées (transfert bancaire)
- ✅ Import de données (tout ou rien)
- ✅ Modifications critiques (comptabilité, stock)
- ❌ SELECT simple (pas nécessaire)

## Illustration suggérée
- Diagramme de flux : BEGIN → Opérations → COMMIT/ROLLBACK
- Timeline montrant état de la base avant/pendant/après transaction

## Exemple (entrée)

**Table orders (état initial)**
| order_id | customer_id | total_amount | status |
|----------|-------------|--------------|--------|
| 1 | 1 | 150.00 | PENDING |

**Table products (état initial)**
| product_id | name | stock |
|------------|------|-------|
| 1 | Laptop | 5 |

## Requête SQL
```sql
-- Scénario : Passer une commande avec déduction de stock

BEGIN; -- Démarre la transaction

-- 1. Créer la commande
INSERT INTO orders (customer_id, total_amount, status) 
VALUES (2, 899.99, 'PENDING')
RETURNING order_id;

-- 2. Décrémenter le stock
UPDATE products 
SET stock = stock - 1 
WHERE product_id = 1 AND stock > 0;

-- Vérifier que le stock a été décrémenté
SELECT stock FROM products WHERE product_id = 1;

-- Si tout est OK → COMMIT
-- Si problème (ex: stock = 0) → ROLLBACK

COMMIT; -- Valide les 2 opérations atomiquement

-- Vérifier le résultat
SELECT * FROM products WHERE product_id = 1;
```

## Résultat (table)

**Après COMMIT** :
| product_id | name | stock |
|------------|------|-------|
| 1 | Laptop | 4 |

**Si ROLLBACK avait été appelé** :
| product_id | name | stock |
|------------|------|-------|
| 1 | Laptop | 5 |

(Aucune modification n'aurait été persistée)

## Notes pour le présentateur
- 🎯 **Message clé** : Les transactions garantissent que des opérations multiples sont toutes exécutées ou toutes annulées
- **Démonstration live** :
  1. BEGIN → UPDATE → ROLLBACK → Vérifier que rien n'a changé
  2. BEGIN → INSERT dans 2 tables → COMMIT → Vérifier les 2 insertions
  3. BEGIN → INSERT → Erreur de contrainte → ROLLBACK automatique
  4. SAVEPOINT : BEGIN → INSERT → SAVEPOINT → DELETE → ROLLBACK TO SAVEPOINT
- **Analogie** : Transaction = panier d'achats e-commerce
  - Vous ajoutez plusieurs articles (opérations)
  - Soit vous validez le panier (COMMIT)
  - Soit vous l'abandonnez (ROLLBACK)
- ⚠️ **Attention** : Transaction ouverte trop longtemps = locks sur les tables → performance dégradée
- **Best practice** : Garder les transactions courtes et ciblées
- **Cas réel** : Système de réservation (avion, hôtel) → réserver + payer + envoyer confirmation = 1 transaction
