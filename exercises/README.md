# 📝 Exercices SQL - Formation PostgreSQL

## Instructions générales

- Utilisez la base de données `shop_db` créée lors de la formation
- Testez vos requêtes avant de passer à l'exercice suivant
- Les solutions sont disponibles dans le dossier `solutions/`
- N'hésitez pas à consulter les fichiers d'exemples dans `sql/`

---

## 🟢 Exercice 1 : Créer une nouvelle table (DDL)

**Difficulté** : Facile  
**Objectif** : Maîtriser CREATE TABLE avec contraintes

### Énoncé

Créez une table `order_items` qui permettra de stocker les lignes de commande (produits dans chaque commande). Cette table doit contenir :

- `order_item_id` : Clé primaire auto-incrémentée (SERIAL)
- `order_id` : Référence vers la table `orders` (clé étrangère)
- `product_id` : Référence vers la table `products` (clé étrangère)
- `quantity` : Quantité commandée (INTEGER, doit être > 0)
- `unit_price` : Prix unitaire au moment de la commande (NUMERIC(10,2))

**Contraintes à respecter** :
- Les deux clés étrangères doivent avoir ON DELETE CASCADE
- La quantité doit être strictement positive (CHECK)
- Le prix unitaire doit être positif ou nul

### Données de test à insérer
Après création de la table, insérez ces données :
```sql
-- Commande 1 : Laptop + Souris
(1, 1, 2, 899.99)  -- order_id=1, product_id=1, qty=1, price=899.99
(1, 2, 1, 29.99)   -- order_id=1, product_id=2, qty=1, price=29.99

-- Commande 2 : Clavier
(2, 3, 1, 79.99)
```

---

## 🟢 Exercice 2 : Requêtes SELECT avec jointures (DML)

**Difficulté** : Facile  
**Objectif** : Maîtriser SELECT, JOIN, GROUP BY

### Énoncé

En utilisant les tables `customers`, `orders` et `products`, écrivez les requêtes suivantes :

#### 2.1 - Liste des commandes avec nom du client
Afficher : nom complet du client, numéro de commande, date, montant total, statut

#### 2.2 - Clients ayant passé plus d'une commande
Afficher : nom du client, nombre de commandes (trié par nombre décroissant)

#### 2.3 - Top 3 des clients par montant dépensé
Afficher : nom du client, total dépensé (uniquement commandes COMPLETED)

#### 2.4 - Produits jamais commandés (si vous avez créé order_items)
Afficher : nom du produit, catégorie, prix

**Astuce** : Utilisez LEFT JOIN puis WHERE IS NULL pour la 2.4

---

## 🟡 Exercice 3 : UPDATE et DELETE sécurisés (DML)

**Difficulté** : Moyen  
**Objectif** : Maîtriser UPDATE/DELETE avec WHERE et RETURNING

### Énoncé

#### 3.1 - Augmenter les prix de 5%
Augmentez de 5% le prix de tous les produits de la catégorie "Informatique".  
Utilisez RETURNING pour afficher les produits modifiés.

#### 3.2 - Annuler les commandes en attente depuis plus de 30 jours
Créez d'abord une commande de test avec une date ancienne :
```sql
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES (1, '2024-01-01', 50.00, 'PENDING');
```

Puis écrivez une requête UPDATE qui change le statut en "CANCELLED" pour toutes les commandes PENDING datant de plus de 30 jours.

#### 3.3 - Supprimer les produits en rupture de stock
Supprimez les produits dont le stock est à 0 ET qui n'ont jamais été commandés (si vous avez order_items).

**⚠️ Important** : Testez d'abord avec SELECT avant d'exécuter UPDATE ou DELETE !

---

## 🟡 Exercice 4 : Transaction avec gestion d'erreur (TCL)

**Difficulté** : Moyen  
**Objectif** : Maîtriser BEGIN, COMMIT, ROLLBACK, SAVEPOINT

### Énoncé

Écrivez une transaction qui simule le passage d'une commande complète :

1. Démarrer une transaction
2. Insérer une nouvelle commande dans `orders`
3. Créer un SAVEPOINT `after_order`
4. Décrémenter le stock du produit commandé
5. Si le stock devient négatif :
   - Faire ROLLBACK TO SAVEPOINT
   - Afficher un message d'erreur
6. Sinon :
   - Valider la transaction avec COMMIT

**Scénario de test** :
- Client : customer_id = 1
- Produit : product_id = 1
- Quantité : 2
- Montant : Calculer selon le prix du produit

**Bonus** : Gérer le cas où le client n'existe pas

---

## 🟡 Exercice 5 : Optimisation avec index (Administration)

**Difficulté** : Moyen  
**Objectif** : Comprendre l'impact des index avec EXPLAIN ANALYZE

### Énoncé

#### 5.1 - Mesurer la performance sans index
Écrivez une requête qui recherche tous les produits d'une catégorie :
```sql
SELECT * FROM products WHERE category = 'Informatique';
```

Exécutez-la avec `EXPLAIN ANALYZE` et notez :
- Le type de scan utilisé (Seq Scan ou Index Scan)
- Le temps d'exécution

#### 5.2 - Créer un index approprié
Créez un index sur la colonne `category` de la table `products`.

#### 5.3 - Re-mesurer la performance
Exécutez à nouveau la même requête avec `EXPLAIN ANALYZE`.  
Comparez les résultats (type de scan, temps).

#### 5.4 - Index composé
Créez un index composé sur `(category, price)` et testez cette requête :
```sql
SELECT * FROM products 
WHERE category = 'Informatique' 
ORDER BY price DESC;
```

**Question** : Quel index est utilisé ? Pourquoi ?

---

## 🔴 Exercice 6 : Vue et permissions (DDL + DCL)

**Difficulté** : Difficile  
**Objectif** : Créer une vue et gérer les permissions

### Énoncé

#### 6.1 - Créer une vue analytique
Créez une vue `customer_analytics` qui affiche pour chaque client :
- customer_id
- Nom complet (first_name + last_name)
- Nombre total de commandes
- Montant total dépensé (toutes commandes)
- Montant moyen par commande
- Date de la dernière commande
- Statut client : 'VIP' si montant total > 1000€, 'Regular' sinon

#### 6.2 - Créer des rôles avec permissions
Créez trois rôles :

**a) `sales_analyst` (lecture seule)**
- Peut lire toutes les tables
- Peut lire toutes les vues
- Peut se connecter à la base

**b) `sales_manager` (lecture + écriture)**
- Toutes les permissions de sales_analyst
- Peut INSERT, UPDATE, DELETE sur orders
- Peut UPDATE products (pour gérer le stock)

**c) `data_admin` (tous les droits)**
- Peut CREATE, ALTER, DROP tables
- Peut GRANT des permissions à d'autres

#### 6.3 - Créer des utilisateurs
Créez un utilisateur pour chaque rôle :
- alice_analyst (rôle sales_analyst, password: 'analyst123')
- bob_manager (rôle sales_manager, password: 'manager123')
- charlie_admin (rôle data_admin, password: 'admin123')

#### 6.4 - Tester les permissions
Écrivez des requêtes pour vérifier que :
- alice peut SELECT mais pas INSERT
- bob peut UPDATE orders mais pas DROP tables
- charlie a tous les droits

---

## 🔴 Exercice Bonus : Gestion de stock avec transactions

**Difficulté** : Difficile  
**Objectif** : Transaction complexe avec isolation SERIALIZABLE

### Énoncé

Créez une fonction (ou un script) qui gère un achat complet avec gestion de stock :

1. Vérifier que le client existe
2. Vérifier que tous les produits existent et ont assez de stock
3. Créer la commande dans `orders`
4. Créer les lignes de commande dans `order_items`
5. Décrémenter le stock de chaque produit
6. Si une étape échoue : ROLLBACK complet avec message d'erreur détaillé
7. Si tout réussit : COMMIT et retourner l'order_id

**Paramètres** :
- customer_id
- Liste de (product_id, quantity)

**Utiliser** :
- Niveau d'isolation : SERIALIZABLE
- Gestion d'erreur complète (EXCEPTION)
- SAVEPOINT pour chaque étape critique

**Exemple d'appel** :
```
Client 1 achète :
- Produit 1 (qty: 1)
- Produit 2 (qty: 2)
```

---

## 💡 Conseils pour les exercices

### Avant de commencer
1. Assurez-vous que la base shop_db est bien créée et peuplée
2. Sauvegardez vos données si nécessaire : `pg_dump shop_db > backup.sql`
3. Lisez bien les énoncés et identifiez les tables concernées

### Pendant les exercices
- Testez avec SELECT avant UPDATE/DELETE
- Utilisez BEGIN/ROLLBACK pour tester sans modifier les données
- Consultez les fichiers d'exemples dans sql/ si besoin
- N'hésitez pas à ajouter des COMMENT pour documenter vos requêtes

### Après chaque exercice
- Vérifiez vos résultats avec SELECT
- Comparez avec les solutions proposées
- Essayez de trouver des variantes ou optimisations

---

## 🎯 Barème d'auto-évaluation

| Exercices réussis | Niveau |
|-------------------|--------|
| 1-2 | Débutant - Continuez à pratiquer les bases |
| 3-4 | Intermédiaire - Bonnes bases, approfondissez |
| 5-6 | Avancé - Excellente maîtrise de SQL |
| Bonus | Expert - Prêt pour des cas complexes |

**Bon courage ! 🚀**
