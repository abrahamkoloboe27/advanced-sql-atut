# SQL Avancé — Africa Tech Up Tour 2025 🚀

Ce dépôt a pour objectif d'enseigner des **concepts avancés de SQL** utiles en data engineering et data science.
Les notions sont d'abord expliquées dans des scripts SQL organisés par langage, puis mises en pratique via des **exercices progressifs** pour maîtriser PostgreSQL.

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue.svg)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📋 Table des matières

- [Les langages SQL abordés](#-les-langages-sql-abordés)
- [Objectifs pédagogiques](#-objectifs-pédagogiques)
- [Prérequis](#-prérequis)
- [Installation rapide](#-installation-rapide)
- [Installation Docker](#-installation-docker)
- [Structure du projet](#-structure-du-projet)
- [Connexion à la base de données](#-connexion-à-la-base-de-données)
- [Plan de la séance](#-plan-de-la-séance)
- [Utilisation](#-utilisation)
- [Exercices](#-exercices)
- [Contribuer](#-contribuer)

---

## 🗂️ Les langages SQL abordés

Ce cours couvre les **4 principaux langages SQL** ainsi que l'administration de base de données PostgreSQL :

### 1️⃣ **DDL** (Data Definition Language) - Langage de Définition de Données

Permet de définir et modifier la structure de la base de données.

**Concepts abordés** :
- `CREATE TABLE` : Création de tables avec contraintes (PK, FK, CHECK, UNIQUE)
- `ALTER TABLE` : Modification de tables (ajouter/supprimer colonnes, renommer)
- `DROP TABLE` : Suppression de tables (simple, CASCADE)
- `CREATE INDEX` : Création d'index (simple, composé, partiel, unique)
- `CREATE VIEW` : Création de vues (simples et matérialisées)

**Scripts disponibles** :
- `sql/01_ddl/create_tables.sql` - Création des tables principales
- `sql/01_ddl/alter_drop.sql` - Modifications et suppressions
- `sql/01_ddl/indexes_views.sql` - Index et vues

### 2️⃣ **DML** (Data Manipulation Language) - Langage de Manipulation de Données

Permet de manipuler les données dans les tables.

**Concepts abordés** :
- `SELECT` : Requêtes simples et avancées (JOIN, GROUP BY, HAVING, CTE, Window Functions)
- `INSERT` : Insertion de données (simple, RETURNING, depuis SELECT)
- `UPDATE` : Mise à jour de données (simple, multi-colonnes, avec calcul)
- `DELETE` : Suppression de données (simple, sous-requête)
- `TRUNCATE` : Suppression rapide de toutes les données
- `MERGE/UPSERT` : INSERT ON CONFLICT (spécifique PostgreSQL)

**Scripts disponibles** :
- `sql/02_dml/insert_seed.sql` - Données initiales
- `sql/02_dml/select_queries.sql` - 28 exemples de requêtes SELECT
- `sql/02_dml/update_delete_truncate.sql` - Modifications et suppressions
- `sql/02_dml/merge_upsert.sql` - Gestion des conflits d'insertion

### 3️⃣ **DCL** (Data Control Language) - Langage de Contrôle de Données

Permet de gérer les droits d'accès et la sécurité.

**Concepts abordés** :
- `CREATE ROLE` / `CREATE USER` : Création de rôles et utilisateurs
- `GRANT` : Attribution de permissions (SELECT, INSERT, UPDATE, DELETE, ALL)
- `REVOKE` : Révocation de permissions
- Politique de sécurité (principe du moindre privilège)

**Scripts disponibles** :
- `sql/03_dcl/grant_revoke.sql` - Gestion des permissions et rôles

### 4️⃣ **TCL** (Transaction Control Language) - Langage de Contrôle de Transactions

Permet de gérer les transactions et garantir l'intégrité des données.

**Concepts abordés** :
- `BEGIN` / `COMMIT` / `ROLLBACK` : Gestion de transactions
- `SAVEPOINT` : Points de sauvegarde dans une transaction
- Niveaux d'isolation (READ COMMITTED, REPEATABLE READ, SERIALIZABLE)
- Propriétés ACID (Atomicité, Cohérence, Isolation, Durabilité)

**Scripts disponibles** :
- `sql/04_tcl/transactions.sql` - Transactions et gestion d'erreurs
- `sql/04_tcl/isolation_examples.sql` - Niveaux d'isolation

### 5️⃣ **Administration** - Optimisation et Performance

Concepts d'administration et optimisation de base de données.

**Concepts abordés** :
- `EXPLAIN` : Analyse du plan d'exécution
- `EXPLAIN ANALYZE` : Analyse avec temps réels
- Optimisation avec index
- `VACUUM` et `ANALYZE` : Maintenance de la base
- `pg_stat_statements` : Statistiques des requêtes

**Scripts disponibles** :
- `sql/05_admin/explain_analyze_examples.sql` - Optimisation et performance

---

## 🎯 Objectifs pédagogiques

À l'issue de cette formation, vous serez capable de :

✅ **Maîtriser les 5 langages SQL** : DDL, DML, DCL, TCL et Administration  
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
- **Docker** (version 20.10+) et **Docker Compose** (v2+) — [Voir la section Installation Docker](#-installation-docker)
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

Voir la section [Connexion à la base de données](#-connexion-à-la-base-de-données) pour les différentes méthodes.

### 4. Tester l'installation

\`\`\`sql
-- Dans psql ou votre client SQL
SELECT COUNT(*) FROM customers;  -- Devrait retourner 5
SELECT COUNT(*) FROM products;   -- Devrait retourner 6
SELECT COUNT(*) FROM orders;     -- Devrait retourner 6
\`\`\`

---

## 🐳 Installation Docker

Docker est requis pour exécuter PostgreSQL dans un environnement isolé et reproductible.

### Windows

**Option 1 : Docker Desktop (recommandé)**

1. Téléchargez [Docker Desktop pour Windows](https://www.docker.com/products/docker-desktop/)
2. Exécutez l'installateur et suivez les instructions
3. Redémarrez votre ordinateur si demandé
4. Vérifiez l'installation :
   \`\`\`bash
   docker --version
   docker-compose --version
   \`\`\`

**Option 2 : WSL2 + Docker**

1. Activez WSL2 : [Guide Microsoft WSL2](https://docs.microsoft.com/fr-fr/windows/wsl/install)
2. Installez Docker Desktop et activez l'intégration WSL2
3. Utilisez Docker depuis votre terminal WSL2

### macOS

**Option 1 : Docker Desktop (recommandé)**

1. Téléchargez [Docker Desktop pour Mac](https://www.docker.com/products/docker-desktop/)
2. Ouvrez le fichier `.dmg` et glissez Docker vers Applications
3. Lancez Docker depuis Applications
4. Vérifiez l'installation :
   \`\`\`bash
   docker --version
   docker-compose --version
   \`\`\`

**Option 2 : Homebrew**

\`\`\`bash
brew install --cask docker
\`\`\`

### Linux (Ubuntu/Debian)

**Installation via le dépôt officiel Docker** :

\`\`\`bash
# Mise à jour des paquets
sudo apt-get update

# Installation des prérequis
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Ajout de la clé GPG Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Ajout du dépôt Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation de Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Démarrage de Docker
sudo systemctl start docker
sudo systemctl enable docker

# Ajout de votre utilisateur au groupe docker (pour éviter sudo)
sudo usermod -aG docker $USER
newgrp docker

# Vérification
docker --version
docker compose version
\`\`\`

**Pour d'autres distributions Linux** :
- Fedora/RHEL/CentOS : [Guide Docker pour Fedora](https://docs.docker.com/engine/install/fedora/)
- Arch Linux : `sudo pacman -S docker docker-compose`
- openSUSE : [Guide Docker pour openSUSE](https://docs.docker.com/engine/install/opensuse/)

### Vérification de l'installation

Une fois Docker installé, vérifiez que tout fonctionne :

\`\`\`bash
# Vérifier les versions
docker --version
docker compose version

# Tester avec une image hello-world
docker run hello-world
\`\`\`

Si la commande affiche un message de bienvenue, Docker est correctement installé ! 🎉

### Ressources supplémentaires

- [Documentation officielle Docker](https://docs.docker.com/get-docker/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Post-installation Linux](https://docs.docker.com/engine/install/linux-postinstall/)

---

## 📂 Structure du projet

Arborescence complète du dépôt et explication de chaque dossier :

\`\`\`
advanced-sql-atut/
├── 📄 README.md                    # Ce fichier - Guide complet du projet
├── 📄 CONTRIBUTING.md              # Guide pour contribuer au projet
├── 📄 SUMMARY.md                   # Résumé et statistiques du projet
├── 📄 docker-compose.yml           # Configuration Docker PostgreSQL 15
├── 📄 Makefile                     # Commandes utilitaires (make up, make psql, etc.)
├── 📄 test_installation.sh         # Script de validation de l'installation
├── 📄 .gitignore                   # Fichiers à exclure de Git
│
├── 📂 sql/                         # ⭐ Scripts SQL organisés par langage
│   ├── 📄 00_create_database.sql  # Script de création de la base shop_db
│   │
│   ├── 📂 01_ddl/                  # Data Definition Language
│   │   ├── create_tables.sql      # Création des tables (customers, products, orders)
│   │   ├── alter_drop.sql         # Modifications et suppressions de tables
│   │   └── indexes_views.sql      # Index et vues (simples et matérialisées)
│   │
│   ├── 📂 02_dml/                  # Data Manipulation Language
│   │   ├── insert_seed.sql        # Insertion des données initiales
│   │   ├── select_queries.sql     # 28 exemples de requêtes SELECT
│   │   ├── update_delete_truncate.sql  # Modifications et suppressions
│   │   └── merge_upsert.sql       # Gestion des conflits (UPSERT)
│   │
│   ├── 📂 03_dcl/                  # Data Control Language
│   │   └── grant_revoke.sql       # Gestion des permissions et rôles
│   │
│   ├── 📂 04_tcl/                  # Transaction Control Language
│   │   ├── transactions.sql       # Transactions et gestion d'erreurs
│   │   └── isolation_examples.sql # Niveaux d'isolation
│   │
│   └── 📂 05_admin/                # Administration
│       └── explain_analyze_examples.sql  # Optimisation et performance
│
├── 📂 exercises/                   # ⭐ Exercices pratiques
│   └── README.md                  # Énoncés des 6 exercices + 1 bonus
│
├── 📂 solutions/                   # ⭐ Solutions des exercices
│   ├── exercice01.sql             # Solution exercice 1 (DDL)
│   ├── exercice02.sql             # Solution exercice 2 (SELECT + JOIN)
│   ├── exercice03.sql             # Solution exercice 3 (UPDATE/DELETE)
│   ├── exercice04.sql             # Solution exercice 4 (Transactions)
│   ├── exercice05.sql             # Solution exercice 5 (EXPLAIN + Index)
│   └── exercice06.sql             # Solution exercice 6 (Vues + Permissions)
│
├── 📂 slides/                      # Support de cours
│   └── 00_plan.md                 # Plan pédagogique de la séance (3h)
│
├── 📂 assets/                      # Ressources complémentaires
│   └── database-schema.md         # Schéma détaillé de la base de données
│
└── 📂 pdf/                         # PDFs générés (optionnel)
\`\`\`

### 🔑 Fichiers et dossiers essentiels

| Dossier/Fichier | Description | Quand l'utiliser |
|-----------------|-------------|------------------|
| **sql/** | Scripts SQL organisés par langage | Pour apprendre les concepts SQL |
| **exercises/README.md** | Énoncés des exercices | Pour pratiquer |
| **solutions/** | Solutions des exercices | Pour vérifier vos réponses |
| **docker-compose.yml** | Configuration PostgreSQL | Pour lancer la base de données |
| **Makefile** | Commandes utilitaires | Pour des raccourcis (make psql, make up) |
| **slides/00_plan.md** | Plan pédagogique | Pour formateurs |
| **assets/database-schema.md** | Schéma de la base | Pour comprendre la structure |

---

## 🔌 Connexion à la base de données

Une fois le conteneur Docker démarré, plusieurs méthodes permettent de se connecter à la base de données PostgreSQL.

### Informations de connexion

**Paramètres par défaut** :
- **Host** : `localhost`
- **Port** : `5432`
- **Database** : `shop_db`
- **User** : `postgres`
- **Password** : `postgres`

### Méthode 1 : psql (ligne de commande)

**Depuis le conteneur Docker** (recommandé) :

\`\`\`bash
docker exec -it shop_db_postgres psql -U postgres -d shop_db
\`\`\`

**Depuis l'hôte** (si psql est installé) :

\`\`\`bash
psql -h localhost -p 5432 -U postgres -d shop_db
\`\`\`

**Commandes psql utiles** :
\`\`\`sql
\dt                  -- Lister toutes les tables
\d customers         -- Décrire la table customers
\du                  -- Lister les utilisateurs
\l                   -- Lister les bases de données
\q                   -- Quitter psql
\i fichier.sql       -- Exécuter un script SQL
\?                   -- Aide des commandes psql
\h SELECT            -- Aide sur la syntaxe SELECT
\`\`\`

### Méthode 2 : pgAdmin (interface graphique)

[pgAdmin](https://www.pgadmin.org/) est l'outil d'administration graphique officiel de PostgreSQL.

**Installation** :
- Windows/macOS : Téléchargez depuis [pgadmin.org](https://www.pgadmin.org/download/)
- Linux : `sudo apt install pgadmin4` ou `sudo snap install pgadmin4`
- Docker : `docker run -p 5050:80 -e PGADMIN_DEFAULT_EMAIL=admin@admin.com -e PGADMIN_DEFAULT_PASSWORD=admin dpage/pgadmin4`

**Configuration de la connexion** :
1. Ouvrez pgAdmin
2. Clic droit sur "Servers" → "Register" → "Server"
3. Onglet "General" :
   - Name : `shop_db_local`
4. Onglet "Connection" :
   - Host : `localhost`
   - Port : `5432`
   - Database : `shop_db`
   - Username : `postgres`
   - Password : `postgres`
5. Cliquez sur "Save"

### Méthode 3 : DBeaver (multi-base de données)

[DBeaver](https://dbeaver.io/) est un outil universel qui supporte PostgreSQL, MySQL, SQLite, etc.

**Installation** :
- Téléchargez depuis [dbeaver.io](https://dbeaver.io/download/)
- Ou via package manager : `brew install --cask dbeaver-community` (macOS)

**Configuration de la connexion** :
1. Ouvrez DBeaver
2. Cliquez sur "Nouvelle connexion" (icône prise électrique)
3. Sélectionnez "PostgreSQL" → "Next"
4. Configurez :
   - Host : `localhost`
   - Port : `5432`
   - Database : `shop_db`
   - Username : `postgres`
   - Password : `postgres`
5. Testez la connexion → "Finish"

### Méthode 4 : DataGrip (JetBrains - payant)

[DataGrip](https://www.jetbrains.com/datagrip/) est un IDE de base de données professionnel.

**Installation** : Téléchargez depuis [jetbrains.com/datagrip](https://www.jetbrains.com/datagrip/)

**Configuration** : Similaire à DBeaver

### Méthode 5 : Extensions VS Code

Plusieurs extensions VS Code permettent de se connecter à PostgreSQL :

- **[SQLTools](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)** + **[SQLTools PostgreSQL Driver](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools-driver-pg)**
- **[PostgreSQL](https://marketplace.visualstudio.com/items?itemName=ckolkman.vscode-postgres)**

**Configuration avec SQLTools** :
1. Installez les deux extensions
2. Ouvrez la palette de commandes (Cmd/Ctrl + Shift + P)
3. Tapez "SQLTools: Add New Connection"
4. Sélectionnez PostgreSQL et configurez les paramètres

### Méthode 6 : Client Python (psycopg2)

Pour les développeurs Python :

\`\`\`python
import psycopg2

# Connexion
conn = psycopg2.connect(
    host="localhost",
    port=5432,
    database="shop_db",
    user="postgres",
    password="postgres"
)

# Exécuter une requête
cursor = conn.cursor()
cursor.execute("SELECT COUNT(*) FROM customers")
print(cursor.fetchone())

# Fermer
cursor.close()
conn.close()
\`\`\`

### Vérification de la connexion

Une fois connecté, testez avec ces requêtes :

\`\`\`sql
-- Vérifier les tables créées
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

-- Compter les enregistrements
SELECT 
  (SELECT COUNT(*) FROM customers) as nb_customers,
  (SELECT COUNT(*) FROM products) as nb_products,
  (SELECT COUNT(*) FROM orders) as nb_orders;

-- Afficher un échantillon
SELECT * FROM customers LIMIT 3;
\`\`\`

**Résultat attendu** :
- 5 clients
- 6 produits
- 6 commandes

---

## 📅 Plan de la séance

Répartition détaillée pour une session de **3 heures** :

| Horaire | Durée | Section | Activités |
|---------|-------|---------|-----------|
| 00:00 - 00:20 | 20 min | **Introduction & Setup** | Présentation du plan, installation Docker, connexion à la base, présentation du schéma shop_db |
| 00:20 - 01:00 | 40 min | **DDL** | CREATE TABLE, ALTER TABLE, DROP TABLE, INDEX, VIEW (fichiers `sql/01_ddl/`) |
| 01:00 - 01:40 | 40 min | **DML** | SELECT avancé, INSERT, UPDATE, DELETE, MERGE (fichiers `sql/02_dml/`) |
| 01:40 - 02:00 | 20 min | **DCL** | CREATE ROLE, GRANT, REVOKE (fichier `sql/03_dcl/grant_revoke.sql`) |
| 02:00 - 02:30 | 30 min | **TCL** | Transactions, SAVEPOINT, niveaux d'isolation (fichiers `sql/04_tcl/`) |
| 02:30 - 02:50 | 20 min | **Administration** | EXPLAIN ANALYZE, optimisation (fichier `sql/05_admin/explain_analyze_examples.sql`) |
| 02:50 - 03:20 | 30 min | **Exercices** | Pratique guidée des 6 exercices (voir `exercises/README.md`) |
| 03:20 - 03:40 | 20 min | **Q&A & Conclusion** | Questions, récapitulatif, ressources complémentaires |

**💡 Conseil pour les formateurs** : Consultez le fichier `slides/00_plan.md` pour un plan détaillé avec notes pédagogiques.

---

## 💻 Utilisation

### Exécuter les scripts SQL

#### Méthode 1 : Depuis le conteneur Docker (recommandé)

\`\`\`bash
# Se connecter au conteneur
docker exec -it shop_db_postgres psql -U postgres -d shop_db

# Dans psql, exécuter un script
\i /docker-entrypoint-initdb.d/02-create-tables.sql

# Ou exécuter les scripts montés dans le dossier sql/
# Note: Les scripts ne sont pas automatiquement montés, utilisez la méthode 2
\`\`\`

#### Méthode 2 : Depuis l'hôte

\`\`\`bash
# Exécuter un script spécifique
docker exec -i shop_db_postgres psql -U postgres -d shop_db < sql/02_dml/select_queries.sql

# Exécuter tous les scripts DDL dans l'ordre
docker exec -i shop_db_postgres psql -U postgres -d shop_db < sql/01_ddl/create_tables.sql
docker exec -i shop_db_postgres psql -U postgres -d shop_db < sql/01_ddl/alter_drop.sql
docker exec -i shop_db_postgres psql -U postgres -d shop_db < sql/01_ddl/indexes_views.sql
\`\`\`

#### Méthode 3 : Avec le Makefile (raccourcis)

\`\`\`bash
# Lancer PostgreSQL
make up

# Se connecter à psql
make psql

# Voir les logs
make logs

# Redémarrer le conteneur
make restart

# Arrêter le conteneur
make down

# Nettoyer (supprimer volumes et données)
make clean

# Réinitialiser complètement
make reset

# Exécuter un script spécifique
make run-sql FILE=sql/02_dml/select_queries.sql

# Tester la connexion et compter les enregistrements
make test

# Voir toutes les commandes disponibles
make help
\`\`\`

### Parcours d'apprentissage recommandé

**Pour les débutants** :
1. Commencez par `sql/01_ddl/create_tables.sql` pour comprendre la structure
2. Insérez les données avec `sql/02_dml/insert_seed.sql`
3. Pratiquez les requêtes SELECT avec `sql/02_dml/select_queries.sql`
4. Faites les exercices 1 et 2

**Pour niveau intermédiaire** :
1. Explorez les transactions avec `sql/04_tcl/transactions.sql`
2. Étudiez les permissions avec `sql/03_dcl/grant_revoke.sql`
3. Optimisez avec `sql/05_admin/explain_analyze_examples.sql`
4. Faites les exercices 3, 4, et 5

**Pour niveau avancé** :
1. Étudiez les niveaux d'isolation avec `sql/04_tcl/isolation_examples.sql`
2. Maîtrisez les UPSERT avec `sql/02_dml/merge_upsert.sql`
3. Faites l'exercice 6 et le bonus

---

## 📝 Exercices

Le dossier `exercises/` contient **6 exercices progressifs** pour mettre en pratique les concepts appris.

### Liste des exercices

| # | Titre | Difficulté | Concepts | Temps estimé |
|---|-------|------------|----------|--------------|
| 1 | Créer une table order_items | 🟢 Facile | DDL, CREATE TABLE, Contraintes | 10 min |
| 2 | Requêtes SELECT avec jointures | 🟢 Facile | DML, SELECT, JOIN, GROUP BY | 15 min |
| 3 | UPDATE et DELETE sécurisés | 🟡 Moyen | DML, UPDATE, DELETE, WHERE, RETURNING | 15 min |
| 4 | Transaction avec gestion d'erreur | 🟡 Moyen | TCL, BEGIN, COMMIT, ROLLBACK, SAVEPOINT | 20 min |
| 5 | Optimisation avec index | 🟡 Moyen | Administration, EXPLAIN ANALYZE, INDEX | 20 min |
| 6 | Vue et permissions | 🔴 Difficile | DDL+DCL, VIEW, GRANT, REVOKE | 30 min |
| Bonus | Gestion de stock avec transactions | 🔴 Difficile | TCL avancé, SERIALIZABLE, Gestion d'erreur | 45 min |

### Comment utiliser les exercices

1. **Lisez l'énoncé** dans `exercises/README.md`
2. **Essayez de résoudre** l'exercice par vous-même
3. **Testez votre solution** dans la base de données
4. **Comparez** avec la solution dans `solutions/exerciceXX.sql`
5. **Comprenez** les différences et améliorations possibles

### Structure des solutions

Chaque fichier de solution contient :
- ✅ La solution commentée
- 💡 Explications des choix techniques
- ⚠️ Pièges à éviter
- 🎯 Points clés à retenir

**Exemple** :
\`\`\`bash
# Voir l'énoncé de l'exercice 1
cat exercises/README.md

# Essayer de résoudre...

# Consulter la solution
cat solutions/exercice01.sql

# Exécuter la solution
docker exec -i shop_db_postgres psql -U postgres -d shop_db < solutions/exercice01.sql
\`\`\`

### Barème d'auto-évaluation

| Exercices réussis | Niveau | Prochaine étape |
|-------------------|--------|-----------------|
| 1-2 | 🌱 Débutant | Continuez à pratiquer les bases (SELECT, INSERT) |
| 3-4 | 🌿 Intermédiaire | Approfondissez les transactions et optimisation |
| 5-6 | 🌳 Avancé | Excellente maîtrise, explorez les concepts avancés |
| Bonus | 🚀 Expert | Prêt pour des architectures complexes et production |

---

## 🏆 Bonnes pratiques

### Sécurité

- ✅ **Toujours utiliser WHERE** dans `UPDATE` et `DELETE` pour éviter les modifications massives accidentelles
- ✅ **Appliquer le principe du moindre privilège** (DCL) : donner uniquement les permissions nécessaires
- ✅ **Utiliser des transactions** pour les opérations critiques
- ✅ **Valider les données** avec des contraintes CHECK
- ⚠️ **Ne jamais utiliser le superuser** en production
- ⚠️ **Ne jamais stocker de mots de passe en clair**

### Performance

- ✅ **Créer des index** sur les colonnes fréquemment filtrées ou jointes
- ✅ **Utiliser EXPLAIN ANALYZE** pour détecter les requêtes lentes
- ✅ **Exécuter VACUUM et ANALYZE** régulièrement pour maintenir les statistiques
- ✅ **Limiter les SELECT \*** : sélectionner uniquement les colonnes nécessaires
- ⚠️ **Ne pas sur-indexer** : trop d'index ralentit INSERT/UPDATE/DELETE
- ⚠️ **Éviter les sous-requêtes** dans les SELECT si des JOIN sont possibles

### Maintenabilité

- ✅ **Commenter les requêtes complexes**
- ✅ **Utiliser des noms de colonnes explicites**
- ✅ **Normaliser la base** (éviter la redondance)
- ✅ **Documenter le schéma** (voir `assets/database-schema.md`)
- ✅ **Versionner les migrations** (pour évolutions du schéma)

### Développement

- ✅ **Tester avec BEGIN/ROLLBACK** avant de modifier des données
- ✅ **Utiliser RETURNING** pour voir les modifications en temps réel
- ✅ **Sauvegarder avant des opérations risquées** : `pg_dump shop_db > backup.sql`
- ✅ **Utiliser des transactions** pour grouper plusieurs opérations liées

---

## 🔧 Commandes utiles

### Gestion Docker

\`\`\`bash
# Démarrer le conteneur
docker-compose up -d

# Arrêter le conteneur
docker-compose down

# Voir les logs en temps réel
docker-compose logs -f

# Redémarrer le conteneur
docker-compose restart

# Supprimer le conteneur et les volumes (⚠️ perte de données)
docker-compose down -v

# Voir l'état du conteneur
docker-compose ps

# Accéder au shell du conteneur
docker exec -it shop_db_postgres bash
\`\`\`

### Commandes PostgreSQL (psql)

\`\`\`sql
-- Lister les bases de données
\l

-- Se connecter à une base
\c shop_db

-- Lister les tables
\dt

-- Décrire une table
\d customers

-- Lister les utilisateurs/rôles
\du

-- Lister les vues
\dv

-- Lister les index
\di

-- Afficher les permissions
\dp customers

-- Exécuter un fichier SQL
\i /path/to/script.sql

-- Activer le timing des requêtes
\timing

-- Changer le format d'affichage
\x  -- Mode étendu (une colonne par ligne)

-- Quitter
\q

-- Aide sur les commandes psql
\?

-- Aide SQL
\h SELECT
\`\`\`

### Sauvegardes et restauration

\`\`\`bash
# Sauvegarder la base complète
docker exec shop_db_postgres pg_dump -U postgres shop_db > backup.sql

# Sauvegarder uniquement le schéma
docker exec shop_db_postgres pg_dump -U postgres -s shop_db > schema.sql

# Sauvegarder uniquement les données
docker exec shop_db_postgres pg_dump -U postgres -a shop_db > data.sql

# Restaurer une sauvegarde
docker exec -i shop_db_postgres psql -U postgres -d shop_db < backup.sql

# Sauvegarder en format compressé
docker exec shop_db_postgres pg_dump -U postgres -Fc shop_db > backup.dump

# Restaurer depuis format compressé
docker exec -i shop_db_postgres pg_restore -U postgres -d shop_db backup.dump
\`\`\`

---

## 📚 Ressources complémentaires

### Documentation officielle

- [PostgreSQL Documentation](https://www.postgresql.org/docs/current/) - Documentation complète
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/) - Tutoriels détaillés
- [PostgreSQL Wiki](https://wiki.postgresql.org/) - Articles et guides communautaires

### Outils en ligne

- [PostgreSQL Exercises](https://pgexercises.com/) - Exercices interactifs
- [explain.depesz.com](https://explain.depesz.com/) - Analyser les plans d'exécution
- [explain.dalibo.com](https://explain.dalibo.com/) - Visualiser EXPLAIN (français)
- [SQL Fiddle](http://sqlfiddle.com/) - Tester des requêtes en ligne

### Livres recommandés

- **PostgreSQL: Up and Running** - Regina Obe, Leo Hsu
- **The Art of PostgreSQL** - Dimitri Fontaine
- **PostgreSQL Query Optimization** - Henrietta Dombrovskaya

### Cours en ligne

- [SQL for Data Science](https://www.coursera.org/learn/sql-for-data-science) - Coursera
- [The Complete SQL Bootcamp](https://www.udemy.com/course/the-complete-sql-bootcamp/) - Udemy
- [PostgreSQL Fundamentals](https://www.pluralsight.com/courses/postgresql-getting-started) - Pluralsight

### Communautés

- [Stack Overflow PostgreSQL](https://stackoverflow.com/questions/tagged/postgresql)
- [PostgreSQL Reddit](https://www.reddit.com/r/PostgreSQL/)
- [PostgreSQL Slack](https://postgres-slack.herokuapp.com/)
- [PostgreSQL France](https://www.postgresql.fr/) - Communauté francophone

---

## 🤝 Contribuer

Les contributions sont les bienvenues ! Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour savoir comment :

- 🐛 Signaler un bug
- 💡 Proposer une amélioration
- 📝 Ajouter des exemples SQL
- 🎯 Créer de nouveaux exercices
- 📖 Améliorer la documentation

---

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

---

## 👨‍💻 Auteur

**Abraham KOLOBOE**
- GitHub: [@abrahamkoloboe27](https://github.com/abrahamkoloboe27)
- Formation : Africa Tech Up Tour 2025

---

## 🙏 Remerciements

- L'équipe **Africa Tech Up Tour** pour l'organisation
- La communauté **PostgreSQL** pour la documentation
- Tous les **contributeurs** du projet

---

**Bon apprentissage ! 🚀**

_Si vous trouvez ce projet utile, n'hésitez pas à lui donner une ⭐ sur GitHub !_
