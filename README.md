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
