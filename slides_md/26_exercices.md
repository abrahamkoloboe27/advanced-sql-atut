# 26 - Exercices Proposés 🎯

## Objectif
Présenter les 6 exercices pratiques progressifs et les instructions pour les réaliser.

## Contenu

### 📚 Vue d'ensemble des exercices

Les exercices sont disponibles dans le dossier `exercises/` du repository et couvrent l'ensemble des compétences SQL vues pendant la formation.

**Prérequis** :
- ✅ Base de données `shop_db` créée et peuplée
- ✅ Accès PostgreSQL (psql, pgAdmin, DBeaver)
- ✅ Fichier `sql/seed.sql` exécuté

### 🎓 Liste des exercices

**🟢 Exercice 1 : Créer une table (DDL) - 15 min**
- **Objectif** : Maîtriser CREATE TABLE avec contraintes
- **Niveau** : Débutant
- **Compétences** : DDL, clés primaires/étrangères, CHECK, ON DELETE CASCADE
- **Livrable** : Table `order_items` avec relations vers `orders` et `products`

**🟢 Exercice 2 : Requêtes SELECT avec jointures (DML) - 20 min**
- **Objectif** : Maîtriser SELECT, JOIN, GROUP BY, HAVING
- **Niveau** : Débutant à Intermédiaire
- **Compétences** : INNER JOIN, LEFT JOIN, agrégations, ORDER BY
- **Livrable** : 4 requêtes d'analyse (clients, commandes, produits)

**🟡 Exercice 3 : UPDATE et DELETE sécurisés (DML) - 20 min**
- **Objectif** : Modifier données avec WHERE et RETURNING
- **Niveau** : Intermédiaire
- **Compétences** : UPDATE, DELETE, WHERE, RETURNING, transactions
- **Livrable** : Scripts de mise à jour avec validation

**🟡 Exercice 4 : Transaction avec gestion d'erreur (TCL) - 25 min**
- **Objectif** : Gérer transactions complexes avec SAVEPOINT
- **Niveau** : Intermédiaire
- **Compétences** : BEGIN, COMMIT, ROLLBACK, SAVEPOINT, gestion d'erreur
- **Livrable** : Transaction complète de passage de commande avec stock

**🟡 Exercice 5 : Optimisation avec index (Administration) - 25 min**
- **Objectif** : Comprendre impact des index avec EXPLAIN ANALYZE
- **Niveau** : Intermédiaire à Avancé
- **Compétences** : EXPLAIN ANALYZE, CREATE INDEX, index composés
- **Livrable** : Analyse performance avant/après index

**🔴 Exercice 6 : Vue et permissions (DDL + DCL) - 30 min**
- **Objectif** : Créer vues et gérer permissions par rôle
- **Niveau** : Avancé
- **Compétences** : CREATE VIEW, GRANT, REVOKE, CREATE ROLE
- **Livrable** : Vue analytique + 3 rôles avec permissions différentes

### 🚀 Instructions d'exécution

**1. Préparer l'environnement**
```bash
# Démarrer PostgreSQL (Docker)
docker-compose up -d

# Se connecter à la base
docker exec -it shop_db_postgres psql -U pguser -d shop_db

# Ou avec psql local
psql -h localhost -p 5433 -U pguser -d shop_db
```

**2. Vérifier les données**
```sql
-- Vérifier que les tables sont peuplées
SELECT COUNT(*) FROM customers;  -- Devrait retourner 5
SELECT COUNT(*) FROM products;   -- Devrait retourner 6
SELECT COUNT(*) FROM orders;     -- Devrait retourner 6
```

**3. Réaliser les exercices**
- Lire l'énoncé complet dans `exercises/README.md`
- Créer vos scripts SQL dans votre éditeur
- Tester dans psql ou votre client SQL
- Comparer avec solutions dans `solutions/`

**4. Ressources disponibles**
- 📖 Énoncés : `exercises/README.md`
- ✅ Solutions SQL : `solutions/sql/`
- 📝 Explications : `solutions/*.md`
- 💾 Données : `sql/seed.sql`

### 💡 Conseils

**Pour réussir** :
- ✅ Lire l'énoncé en entier avant de coder
- ✅ Tester chaque requête progressivement
- ✅ Utiliser BEGIN/ROLLBACK pour tester UPDATE/DELETE
- ✅ Consulter les slides si besoin de rappel
- ✅ Ne pas hésiter à consulter la documentation PostgreSQL

**Si vous êtes bloqué** :
1. Relire la slide correspondante
2. Consulter les exemples dans `sql/`
3. Regarder la solution partielle
4. Demander de l'aide au formateur

## Illustration suggérée
- Timeline des exercices avec niveau de difficulté
- Icônes par type (DDL, DML, DCL, TCL, Admin)

## Exemple (entrée)

**Aperçu Exercice 2 : Requête avec jointure**

**Tables disponibles** :
- `customers` : customer_id, first_name, last_name, email
- `orders` : order_id, customer_id, total_amount, status, order_date
- `products` : product_id, name, price, category, stock

## Requête SQL
```sql
-- Exemple de requête attendue (Exercice 2.1)
-- Lister commandes avec nom du client

SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_id,
    o.order_date,
    o.total_amount,
    o.status
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;
```

## Résultat (table)

| customer_name | order_id | order_date | total_amount | status |
|---------------|----------|------------|--------------|--------|
| Alice Martin | 2 | 2024-01-20 | 200.00 | COMPLETED |
| Alice Martin | 1 | 2024-01-15 | 150.00 | COMPLETED |
| Bob Dupont | 3 | 2024-01-18 | 75.00 | PENDING |

## Notes pour le présentateur
- 🎯 **Message clé** : Les exercices consolident l'apprentissage - pratique > théorie
- **Timing recommandé** :
  - Explication exercices : 10 min
  - Temps de travail : 90-120 min (selon niveau groupe)
  - Revue solutions : 30 min
- **Organisation suggérée** :
  - **Solo** : Exercices 1-2 individuellement (20-30 min)
  - **Pause** : 10 min
  - **Solo** : Exercices 3-4 individuellement (40 min)
  - **Pause** : 10 min
  - **Binôme** : Exercices 5-6 en pair programming (40 min)
  - **Collectif** : Revue solutions ensemble (30 min)
- **Adaptation niveau** :
  - **Groupe débutant** : Focus exercices 1-3, guider sur 4-5, 6 optionnel
  - **Groupe intermédiaire** : Tous les exercices, bonus pour les rapides
  - **Groupe avancé** : Exercices rapidement, se concentrer sur optimisation et edge cases
- **Variantes possibles** :
  - **Code golf** : Qui écrit la requête la plus courte ?
  - **Performance** : Qui optimise le mieux (EXPLAIN ANALYZE) ?
  - **Créativité** : Inventer des requêtes business supplémentaires
- **Points de vigilance** :
  - Vérifier que tout le monde a l'environnement fonctionnel avant de commencer
  - Circuler pour aider ceux en difficulté
  - Encourager à consulter solutions si vraiment bloqué (pas de frustration)
  - Célébrer les réussites (requête qui fonctionne = victoire !)
- **Débriefing collectif** :
  - Demander qui a réussi chaque exercice
  - Faire présenter solutions alternatives intéressantes
  - Montrer erreurs courantes et comment les éviter
  - Répondre aux questions techniques
