# 🚀 Formation SQL avec PostgreSQL - shop_db

> Dépôt pédagogique pour une séance pratique complète sur SQL avec PostgreSQL. Base de données fictive simple, exemples commentés, exercices progressifs et environnement Docker prêt à l'emploi.

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📋 Table des matières

- [Objectifs pédagogiques](#-objectifs-pédagogiques)
- [Prérequis](#-prérequis)
- [Installation rapide](#-installation-rapide)
- [Structure du projet](#-structure-du-projet)
- [Slides de formation](#-slides-de-formation)
- [Plan de la séance](#-plan-de-la-séance)
- [Utilisation](#-utilisation)
- [Exercices](#-exercices)
- [Contribuer](#-contribuer)

---

## 🎯 Objectifs pédagogiques

À l'issue de cette formation, vous serez capable de :

✅ **Maîtriser les 4 langages SQL** : DDL, DML, DCL, TCL  
✅ **Créer et manipuler** une base de données PostgreSQL complète  
✅ **Optimiser les performances** avec index et EXPLAIN ANALYZE  
✅ **Gérer les transactions** avec isolation et ACID  
✅ **Appliquer les bonnes pratiques** de sécurité et performance

---

## ⏱️ Durée recommandée

**Total : 3 heures**

| Section | Durée | Contenu |
|---------|-------|---------|
| Introduction & Setup | 20 min | Installation, présentation du schéma |
| DDL | 40 min | CREATE, ALTER, DROP, INDEX, VIEW |
| DML | 40 min | SELECT, INSERT, UPDATE, DELETE, MERGE |
| DCL | 20 min | GRANT, REVOKE, gestion des rôles |
| TCL | 30 min | Transactions, niveaux d'isolation |
| Administration | 20 min | EXPLAIN ANALYZE, optimisation |
| Exercices pratiques | 30 min | 6 exercices progressifs |
| Q&A & Conclusion | 20 min | Questions, récapitulatif |

---

## 📦 Prérequis

### Logiciels requis
- **Docker** (version 20.10+) et **Docker Compose** (v2+)
- Un client PostgreSQL :
  - `psql` (ligne de commande)
  - [pgAdmin](https://www.pgadmin.org/) (interface graphique)
  - [DBeaver](https://dbeaver.io/) (multi-DB)
  - Ou tout autre client SQL

### Connaissances recommandées
- Bases de SQL (SELECT, WHERE, INSERT)
- Ligne de commande (terminal/PowerShell)
- Aucune expérience PostgreSQL nécessaire

---

## 🚀 Installation rapide

### 1. Cloner le dépôt

\`\`\`bash
git clone https://github.com/abrahamkoloboe27/advanced-sql-atut.git
cd advanced-sql-atut
\`\`\`

### 2. Lancer PostgreSQL avec Docker

\`\`\`bash
docker-compose up -d
\`\`\`

**Vérifier que le conteneur est démarré :**
\`\`\`bash
docker-compose ps
\`\`\`

### 3. Se connecter à la base de données

**Avec psql :**
\`\`\`bash
docker exec -it shop_db_postgres psql -U pguser -d shop_db
\`\`\`

**Avec un client externe (pgAdmin, DBeaver) :**
- **Host** : \`localhost\`
- **Port** : \`5433\`
- **Database** : \`shop_db\`
- **User** : \`pguser\`
- **Password** : \`pgpass\`

### 4. Tester l'installation

\`\`\`sql
-- Dans psql ou votre client SQL
SELECT COUNT(*) FROM customers;  -- Devrait retourner 5
SELECT COUNT(*) FROM products;   -- Devrait retourner 6
SELECT COUNT(*) FROM orders;     -- Devrait retourner 6
\`\`\`

---

## 📚 Slides de Formation

Ce dépôt contient **27 slides au format Markdown** pour une formation complète de 3 heures sur SQL et PostgreSQL.

### 📂 Contenu des slides

**Dossier** : [`slides_md/`](slides_md/)

Les slides couvrent :
- **Fondamentaux** : SGBDR, SQL, familles DDL/DML/DCL/TCL (slides 00-05)
- **DDL/DML** : Création et manipulation de données (slides 06-08)
- **Transactions** : ACID, BEGIN/COMMIT/ROLLBACK (slides 09-10)
- **SQL aujourd'hui** : Importance dans Big Data, Data Engineering (slide 11)
- **Requêtes avancées** : SELECT, WHERE, GROUP BY, Fonctions, Jointures (slides 12-16)
- **Techniques avancées** : CTE, UNION, Window Functions (slides 17-19)
- **Performance** : EXPLAIN ANALYZE, Indexes, Views (slides 20-21)
- **Production** : Optimisation, Sécurité, Migrations, Bonnes pratiques (slides 22-25)
- **Pratique** : Exercices, Ressources (slides 26-27)

### 🎯 Caractéristiques des slides

Chaque slide contient :
- ✅ Objectif pédagogique clair
- ✅ Contenu théorique structuré
- ✅ Exemple pratique avec données source
- ✅ Requête SQL exécutable
- ✅ Résultat en table Markdown
- ✅ Notes pour le présentateur (démos, pièges, bonnes pratiques)

### 🚀 Utilisation des slides

**Pour formateurs** :
```bash
# Visualiser avec n'importe quel lecteur Markdown
# GitHub, VS Code, Obsidian, etc.

# Convertir en slides HTML/PDF avec Marp
npm install -g @marp-team/marp-cli
marp slides_md/*.md --html
```

**Pour participants** :
- Lire directement sur GitHub : [`slides_md/README.md`](slides_md/README.md)
- Cloner le repo et ouvrir avec votre éditeur Markdown préféré

### 📖 Données de démonstration

Les exemples des slides utilisent le fichier [`sql/seed.sql`](sql/seed.sql) :

```bash
# Charger les données d'exemple
psql -h localhost -p 5433 -U pguser -d shop_db -f sql/seed.sql
```

Tables créées : `customers`, `products`, `orders` (≤ 5 lignes chacune, conçues pour les exemples pédagogiques)

---

## 💻 Utilisation

### Exécuter les scripts SQL

#### Depuis le conteneur Docker
\`\`\`bash
# Se connecter au conteneur
docker exec -it shop_db_postgres psql -U pguser -d shop_db

# Exécuter un script depuis psql
\i /path/to/script.sql
\`\`\`

#### Depuis l'hôte
\`\`\`bash
# Exécuter un script depuis l'extérieur du conteneur
docker exec -i shop_db_postgres psql -U pguser -d shop_db < sql/02_dml/select_queries.sql
\`\`\`

---

## 📝 Exercices

Le dossier \`exercises/\` contient **6 exercices progressifs** :

1. 🟢 **Exercice 1** : Créer une table \`order_items\` (DDL)
2. 🟢 **Exercice 2** : Requêtes SELECT avec jointures (DML)
3. 🟡 **Exercice 3** : UPDATE et DELETE sécurisés (DML)
4. 🟡 **Exercice 4** : Transaction avec gestion d'erreur (TCL)
5. 🟡 **Exercice 5** : Optimisation avec index (Administration)
6. 🔴 **Exercice 6** : Vue et permissions (DDL + DCL)

📖 **Voir** : [\`exercises/README.md\`](exercises/README.md)  
✅ **Solutions** : [\`solutions/\`](solutions/)

---

## 🤖 Comment utiliser ce repo avec GitHub Copilot

Ce repository est optimisé pour l'apprentissage avec GitHub Copilot :

### 💬 Questions à poser à Copilot
- "Explique-moi cette requête SQL dans `sql/02_dml/select_queries.sql`"
- "Comment optimiser cette requête avec un index ?"
- "Quelle est la différence entre INNER JOIN et LEFT JOIN dans cet exemple ?"
- "Génère une requête pour trouver les clients qui n'ont jamais commandé"
- "Aide-moi à débugger cette erreur PostgreSQL"

### 🔍 Navigation efficace
- Utilisez `@workspace` pour poser des questions sur l'ensemble du repo
- Référencez les slides : "Explique le concept de CTE dans `slides_md/17_cte_subqueries.md`"
- Demandez des exemples : "Donne-moi un exemple de window function basé sur la table `orders`"

### ✨ Génération de code
- "Écris une requête pour analyser les ventes par catégorie"
- "Crée une migration pour ajouter une colonne `discount` à la table `orders`"
- "Génère un exercice SQL sur les agrégations"

### 🎯 Conseils
- Les slides contiennent des exemples exécutables → demandez des variations
- Utilisez le contexte du `seed.sql` pour des requêtes réalistes
- Copilot peut expliquer les plans EXPLAIN ANALYZE

---

## 🏆 Bonnes pratiques

### Sécurité
- ✅ Toujours utiliser \`WHERE\` dans \`UPDATE\` et \`DELETE\`
- ✅ Appliquer le principe du moindre privilège (DCL)
- ✅ Utiliser des transactions pour opérations critiques
- ⚠️ Ne jamais utiliser le superuser en production

### Performance
- ✅ Créer des index sur colonnes filtrées/jointes
- ✅ Utiliser \`EXPLAIN ANALYZE\` pour détecter les lenteurs
- ✅ Exécuter \`VACUUM\` et \`ANALYZE\` régulièrement
- ⚠️ Ne pas sur-indexer (ralentit INSERT/UPDATE)

---

**Bon apprentissage ! 🚀**
