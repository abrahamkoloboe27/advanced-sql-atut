# 09 - ACID : Les 4 Propriétés des Transactions ⚛️

## Objectif
Comprendre les propriétés ACID qui garantissent la fiabilité et la cohérence des transactions dans un SGBDR.

## Contenu

### 🎯 Définition ACID
**ACID** = 4 propriétés garanties par les SGBDR pour les transactions.

### 🔹 A - Atomicité (Atomicity)
**Principe** : Tout ou rien  
→ Une transaction est indivisible : soit toutes les opérations réussissent, soit aucune.

**Exemple** :
```sql
BEGIN;
  UPDATE accounts SET balance = balance - 100 WHERE id = 1;
  UPDATE accounts SET balance = balance + 100 WHERE id = 2;
COMMIT; -- Les 2 updates ou aucun
```

Si une opération échoue → ROLLBACK automatique.

### 🔹 C - Cohérence (Consistency)
**Principe** : Respect des règles métier  
→ Une transaction fait passer la base d'un état valide à un autre état valide.

**Exemple** :
- Contrainte CHECK : prix > 0
- Clé étrangère : customer_id doit exister
- Règle métier : stock ne peut pas être négatif

Si une contrainte est violée → transaction rejetée.

### 🔹 I - Isolation
**Principe** : Transactions concurrentes isolées  
→ Une transaction ne voit pas les modifications non validées d'une autre.

**Niveaux d'isolation PostgreSQL** :
1. READ COMMITTED (défaut)
2. REPEATABLE READ
3. SERIALIZABLE

**Exemple** :
Transaction A et B modifient la même ligne → pas d'interférence.

### 🔹 D - Durabilité (Durability)
**Principe** : Persistance garantie  
→ Une fois COMMIT effectué, les données sont sauvegardées même en cas de crash.

**Mécanisme** : Write-Ahead Logging (WAL) dans PostgreSQL.

## Illustration suggérée
- Acronyme ACID avec icônes pour chaque propriété
- Scénario de transfert bancaire illustrant ACID
- Timeline montrant isolation de 2 transactions

## Exemple (entrée)

**Table accounts (comptes bancaires)**
| account_id | owner | balance |
|------------|-------|---------|
| 1 | Alice | 500.00 |
| 2 | Bob | 300.00 |

## Requête SQL
```sql
-- Scénario : Transfert de 100€ d'Alice vers Bob

-- Transaction ACID complète
BEGIN;

-- Débit du compte Alice
UPDATE accounts 
SET balance = balance - 100 
WHERE account_id = 1;

-- Crédit du compte Bob
UPDATE accounts 
SET balance = balance + 100 
WHERE account_id = 2;

-- Vérification cohérence (optionnel)
SELECT SUM(balance) FROM accounts; -- Doit rester 800

COMMIT; -- Validation atomique et durable

-- Vérifier le résultat
SELECT * FROM accounts;
```

## Résultat (table)

**Après transaction COMMIT** :
| account_id | owner | balance |
|------------|-------|---------|
| 1 | Alice | 400.00 |
| 2 | Bob | 400.00 |

**Si erreur dans la transaction** :
→ ROLLBACK → Comptes restent à 500 et 300 (atomicité)

## Notes pour le présentateur
- 🎯 **Message clé** : ACID garantit que vos données restent cohérentes même en cas de pannes, bugs ou accès concurrent
- **Analogie** : ACID c'est comme un contrat blindé - soit tout est fait correctement, soit rien n'est fait
- **Démonstration live** :
  1. Transaction avec ROLLBACK volontaire → aucune modification persistée
  2. Transaction qui viole CHECK → rejetée automatiquement
  3. Deux sessions concurrentes modifiant la même ligne → isolation
- ⚠️ **Performance vs ACID** : Plus d'isolation = plus de sécurité mais moins de performance
- **Cas réel** : 
  - Paiement e-commerce : débiter client + créditer vendeur + décrémenter stock
  - Si une étape échoue (ex: stock insuffisant) → tout est annulé
- **PostgreSQL** : ACID respecté par défaut, contrairement à certains systèmes NoSQL (BASE)
