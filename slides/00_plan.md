# 📚 Plan Pédagogique - Formation SQL PostgreSQL

## 🎯 Objectifs de la formation

À l'issue de cette séance pratique, les participants seront capables de :
- Créer et manipuler une base de données PostgreSQL
- Maîtriser les 4 langages SQL (DDL, DML, DCL, TCL)
- Optimiser les performances avec index et EXPLAIN ANALYZE
- Gérer les transactions et comprendre les niveaux d'isolation
- Appliquer les bonnes pratiques de sécurité et performance

---

## ⏱️ Durée recommandée : 3 heures

**Répartition suggérée :**
- Introduction et setup : 20 min
- DDL (CREATE, ALTER, DROP, INDEX, VIEW) : 40 min
- DML (SELECT, INSERT, UPDATE, DELETE) : 40 min
- DCL (GRANT, REVOKE) : 20 min
- TCL (Transactions, Isolation) : 30 min
- Administration (EXPLAIN ANALYZE) : 20 min
- Exercices pratiques : 30 min
- Q&A et conclusion : 20 min

---

## 📋 Plan détaillé des slides

### Slide 1 : Page de garde
- **Titre** : Formation pratique SQL avec PostgreSQL
- **Sous-titre** : Maîtriser les fondamentaux et bonnes pratiques
- **Durée** : 3 heures
- **Niveau** : Débutant à Intermédiaire

### Slide 2 : Objectifs pédagogiques
- Comprendre les 4 langages SQL (DDL, DML, DCL, TCL)
- Créer et manipuler une base shop_db (clients, produits, commandes)
- Optimiser les requêtes avec index
- Gérer les permissions et la sécurité
- Maîtriser les transactions ACID

### Slide 3 : Prérequis
- Connaissance de base en SQL (SELECT, WHERE)
- Docker installé (pour environnement PostgreSQL)
- Éditeur SQL (psql, pgAdmin, DBeaver, ou autre)
- Aucune expérience PostgreSQL nécessaire

### Slide 4 : Schéma de la base shop_db
```
📦 shop_db
├── customers (clients)
│   ├── customer_id (PK)
│   ├── first_name
│   ├── last_name
│   ├── email (UNIQUE)
│   └── created_at
├── products (produits)
│   ├── product_id (PK)
│   ├── name
│   ├── price (CHECK > 0)
│   ├── category
│   └── stock (CHECK >= 0)
└── orders (commandes)
    ├── order_id (PK)
    ├── customer_id (FK → customers)
    ├── order_date
    ├── total_amount
    └── status (PENDING/COMPLETED/CANCELLED)
```

### Slide 5 : DDL - Data Definition Language
**Définition de la structure de la base**
- `CREATE TABLE` : Créer tables avec contraintes
- `ALTER TABLE` : Modifier structure (ADD/DROP COLUMN)
- `DROP TABLE` : Supprimer tables
- `CREATE INDEX` : Créer index pour performance
- `CREATE VIEW` : Créer vues réutilisables
- **Démo** : Création de shop_db

### Slide 6 : DML - Data Manipulation Language
**Manipulation des données**
- `INSERT INTO` : Insérer nouvelles données
- `SELECT` : Récupérer données (WHERE, JOIN, GROUP BY)
- `UPDATE` : Modifier données existantes
- `DELETE` : Supprimer données
- `TRUNCATE` : Vider une table
- `INSERT ... ON CONFLICT` : UPSERT PostgreSQL
- **Démo** : Requêtes sur shop_db

### Slide 7 : Jointures et agrégations
**SELECT avancé**
- INNER JOIN, LEFT JOIN, RIGHT JOIN
- COUNT, SUM, AVG, MIN, MAX
- GROUP BY, HAVING
- Window Functions (ROW_NUMBER, RANK)
- CTE (Common Table Expressions)
- **Démo** : Analyses clients/commandes

### Slide 8 : DCL - Data Control Language
**Gestion des permissions**
- `CREATE ROLE` / `CREATE USER` : Créer rôles/utilisateurs
- `GRANT` : Accorder permissions (SELECT, INSERT, UPDATE, DELETE)
- `REVOKE` : Révoquer permissions
- Principe du moindre privilège
- **Démo** : Rôles analyst, manager, admin

### Slide 9 : TCL - Transaction Control Language
**Gestion des transactions ACID**
- `BEGIN` : Démarrer transaction
- `COMMIT` : Valider modifications
- `ROLLBACK` : Annuler modifications
- `SAVEPOINT` : Points de sauvegarde
- Propriétés ACID : Atomicité, Cohérence, Isolation, Durabilité
- **Démo** : Transaction de commande

### Slide 10 : Niveaux d'isolation
**Isolation des transactions concurrentes**
| Niveau | Dirty Read | Non-Rep. Read | Phantom Read | Performance |
|--------|------------|---------------|--------------|-------------|
| READ COMMITTED (défaut) | ❌ | ✅ | ✅ | Élevée |
| REPEATABLE READ | ❌ | ❌ | ✅* | Moyenne |
| SERIALIZABLE | ❌ | ❌ | ❌ | Faible |

*PostgreSQL protège contre Phantom Reads même en REPEATABLE READ

### Slide 11 : Optimisation des performances
**EXPLAIN ANALYZE et index**
- `EXPLAIN` : Plan d'exécution prévu
- `EXPLAIN ANALYZE` : Temps réels d'exécution
- Index : B-tree, Hash, GIN, GiST
- Seq Scan vs Index Scan
- `VACUUM` et `ANALYZE` : Maintenance
- **Démo** : Optimisation avec index

### Slide 12 : Bonnes pratiques
**🏆 Recommandations**
- ✅ Toujours utiliser WHERE dans UPDATE/DELETE
- ✅ Créer index sur colonnes filtrées/jointes
- ✅ Utiliser transactions pour opérations critiques
- ✅ Appliquer principe du moindre privilège
- ✅ VACUUM/ANALYZE régulièrement
- ⚠️ Ne pas sur-indexer (ralentit INSERT/UPDATE)
- ⚠️ Tester en environnement réaliste

### Slide 13 : Exercices pratiques
**6 exercices progressifs**
1. Créer une nouvelle table
2. Requêtes SELECT avec jointures
3. UPDATE sécurisé avec WHERE
4. Transaction avec gestion d'erreur
5. Optimiser une requête avec index
6. Créer vue + appliquer permissions

### Slide 14 : Ressources complémentaires
**📚 Pour aller plus loin**
- Documentation PostgreSQL : postgresql.org/docs
- Tutoriels interactifs : pgexercises.com
- Visualisation EXPLAIN : explain.depesz.com
- Outils : pgAdmin, DBeaver, DataGrip
- Ce dépôt GitHub : Exemples commentés et corrigés

### Slide 15 : Conclusion et Q&A
**🎓 Récapitulatif**
- DDL : Structure de la base
- DML : Manipulation des données
- DCL : Permissions et sécurité
- TCL : Transactions ACID
- Administration : Performance et maintenance

**Questions / Réponses**

---

## 🎓 Notes pour le formateur

### Points clés à emphasiser
1. **DDL** : Importance des contraintes (PK, FK, CHECK, UNIQUE)
2. **DML** : Danger de UPDATE/DELETE sans WHERE
3. **DCL** : Sécurité par défaut (moindre privilège)
4. **TCL** : Atomicité des transactions (tout ou rien)
5. **Performance** : Index bien placés >> sur-indexation

### Démonstrations live recommandées
- Créer shop_db de A à Z avec participants
- Montrer erreur UPDATE sans WHERE puis ROLLBACK
- Comparer temps avec/sans index (EXPLAIN ANALYZE)
- Simuler transaction bancaire (transfert d'argent)
- Créer rôles et tester permissions

### Adaptations possibles
- **Version courte (2h)** : Réduire TCL et DCL, focus DDL+DML
- **Version longue (4h)** : Ajouter triggers, fonctions PL/pgSQL
- **Public avancé** : Plus de window functions, CTE récursives, partitioning
- **Public débutant** : Plus de temps sur SELECT, moins sur isolation

### Pièges à éviter
- Ne pas aller trop vite sur les jointures (bien expliquer INNER vs LEFT)
- Bien montrer différence TRUNCATE vs DELETE
- Expliquer que MERGE nécessite PostgreSQL 15+
- Préciser qu'EXPLAIN ANALYZE exécute vraiment la requête

---

## 📊 Évaluation des acquis

**Questions de contrôle (oral ou écrit)**
1. Quelle est la différence entre DELETE et TRUNCATE ?
2. Comment empêcher les doublons dans une colonne ?
3. Quel niveau d'isolation utiliser pour un rapport financier ?
4. Comment optimiser une requête lente ?
5. Quelle est la différence entre GRANT et REVOKE ?

**Mini-projet final** : Créer une base de gestion de bibliothèque
- 3 tables : books, members, loans
- Contraintes FK, CHECK
- Vue des prêts en cours
- Rôles avec permissions différentes
- Transaction de prêt/retour de livre
