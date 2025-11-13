# 🤝 Guide de Contribution

Merci de votre intérêt pour contribuer à ce projet pédagogique ! Ce guide vous explique comment ajouter des exemples, améliorer la documentation ou corriger des bugs.

---

## 📋 Table des matières

- [Comment contribuer](#comment-contribuer)
- [Structure du projet](#structure-du-projet)
- [Ajouter des exemples SQL](#ajouter-des-exemples-sql)
- [Ajouter des exercices](#ajouter-des-exercices)
- [Style de code](#style-de-code)
- [Soumettre une Pull Request](#soumettre-une-pull-request)

---

## 🚀 Comment contribuer

Il existe plusieurs façons de contribuer :

1. **Signaler un bug** : Ouvrir une [issue](https://github.com/abrahamkoloboe27/advanced-sql-atut/issues)
2. **Proposer une amélioration** : Ouvrir une [issue](https://github.com/abrahamkoloboe27/advanced-sql-atut/issues) avec le tag `enhancement`
3. **Ajouter des exemples SQL** : Créer une Pull Request
4. **Améliorer la documentation** : Créer une Pull Request
5. **Créer des exercices** : Créer une Pull Request

---

## 📁 Structure du projet

Avant de contribuer, familiarisez-vous avec la structure :

```
advanced-sql-atut/
├── sql/
│   ├── 01_ddl/          # Exemples DDL (CREATE, ALTER, DROP)
│   ├── 02_dml/          # Exemples DML (SELECT, INSERT, UPDATE, DELETE)
│   ├── 03_dcl/          # Exemples DCL (GRANT, REVOKE)
│   ├── 04_tcl/          # Exemples TCL (Transactions)
│   └── 05_admin/        # Administration (EXPLAIN, VACUUM)
├── exercises/           # Énoncés des exercices
├── solutions/           # Solutions des exercices
├── slides/              # Support pédagogique
└── assets/              # Schémas et diagrammes
```

---

## 📝 Ajouter des exemples SQL

### 1. Choisir la catégorie appropriée

Placez votre exemple dans le bon dossier :
- **DDL** : Création/modification de structure (tables, index, vues)
- **DML** : Manipulation de données (SELECT, INSERT, UPDATE, DELETE)
- **DCL** : Gestion des permissions (GRANT, REVOKE)
- **TCL** : Transactions (BEGIN, COMMIT, ROLLBACK)
- **Admin** : Performance et maintenance

### 2. Format des fichiers SQL

Tous les fichiers SQL doivent suivre ce format :

```sql
-- ============================================================================
-- Script: nom_du_script.sql
-- Description: Description claire et concise
-- ============================================================================

\echo '============================================================';
\echo 'TITRE DE LA SECTION';
\echo '============================================================';
\echo '';

-- ============================================================================
-- Mot-clé: NOM_DU_MOT_CLÉ
-- Description: Explication pédagogique du mot-clé
-- Syntaxe: Exemple de syntaxe
-- Cas d'usage: Quand l'utiliser
-- ============================================================================

-- Exemple 1: Description de l'exemple
-- ============================================================================
\echo '1️⃣ Description de l exemple:';
\echo '';

-- Code SQL commenté
SELECT * FROM table_name;

\echo '';
\echo '✅ Explication du résultat';
\echo '';
```

### 3. Règles importantes

- ✅ **Commentaires en français** : Toute la documentation doit être en français
- ✅ **Pédagogie** : Expliquer pourquoi et quand utiliser chaque commande
- ✅ **Exemples progressifs** : Du simple au complexe
- ✅ **Émojis discrets** : Utiliser 1️⃣, 2️⃣, ✅, ⚠️, 💡, etc.
- ✅ **Testabilité** : Les scripts doivent s'exécuter sans erreur sur shop_db
- ✅ **Nettoyage** : Restaurer l'état initial à la fin si nécessaire

### 4. Exemple de contribution

```sql
-- Exemple d'ajout dans sql/02_dml/advanced_select.sql

-- ============================================================================
-- Exemple X: Utilisation de LATERAL JOIN
-- ============================================================================
\echo 'X️⃣ LATERAL JOIN - Sous-requête corrélée:';

-- Trouver les 3 commandes les plus récentes par client
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    recent_orders.*
FROM customers c
CROSS JOIN LATERAL (
    SELECT order_id, order_date, total_amount
    FROM orders o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.order_date DESC
    LIMIT 3
) recent_orders;

\echo '';
\echo '💡 LATERAL permet de référencer la table de gauche (c) dans la sous-requête';
\echo '   Équivalent à un FOR EACH dans d autres langages';
\echo '';
```

---

## 🎯 Ajouter des exercices

### 1. Structure d'un exercice

Chaque exercice doit être ajouté à `exercises/README.md` et avoir sa solution dans `solutions/exerciceXX.sql`.

**Format de l'énoncé** :

```markdown
## 🟢/🟡/🔴 Exercice X : Titre de l'exercice (Catégorie)

**Difficulté** : Facile / Moyen / Difficile  
**Objectif** : Objectif pédagogique clair

### Énoncé

Description détaillée de ce qu'il faut faire...

**Contraintes** :
- Liste des contraintes

**Données de test** :
\`\`\`sql
-- Données à utiliser pour tester
\`\`\`
```

### 2. Créer la solution

Créez un fichier `solutions/exerciceXX.sql` :

```sql
-- ============================================================================
-- SOLUTION EXERCICE X : Titre
-- ============================================================================

\echo '========================================';
\echo 'SOLUTION EXERCICE X';
\echo '========================================';
\echo '';

-- Code de la solution avec commentaires explicatifs

\echo '';
\echo '✅ Exercice X terminé!';
\echo '';
```

### 3. Difficulté des exercices

- 🟢 **Facile** : Utilisation directe d'un mot-clé (CREATE TABLE, SELECT simple)
- 🟡 **Moyen** : Combinaison de plusieurs concepts (JOIN + GROUP BY, transaction simple)
- 🔴 **Difficile** : Logique complexe (CTE récursifs, SAVEPOINT, permissions avancées)

---

## 🎨 Style de code

### SQL

```sql
-- ✅ BON
SELECT 
    c.customer_id,
    c.first_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;

-- ❌ MAUVAIS (pas d'indentation)
SELECT c.customer_id,c.first_name,COUNT(o.order_id) AS total_orders FROM customers c LEFT JOIN orders o ON c.customer_id=o.customer_id GROUP BY c.customer_id,c.first_name HAVING COUNT(o.order_id)>5 ORDER BY total_orders DESC;
```

### Conventions de nommage

- **Tables** : `nom_table` (minuscules, snake_case)
- **Colonnes** : `nom_colonne` (minuscules, snake_case)
- **Index** : `idx_table_colonne` (préfixe idx_)
- **Vues** : `nom_vue` ou `vw_nom_vue`
- **Contraintes FK** : `fk_table_source_cible`

### Commentaires

```sql
-- Commentaire court sur une ligne

-- Commentaire plus long sur plusieurs lignes
-- qui explique une logique complexe ou
-- un choix d'implémentation particulier

/* 
 * Bloc de commentaire pour 
 * des explications détaillées
 */
```

---

## 🔧 Tester vos modifications

Avant de soumettre une Pull Request :

1. **Démarrer la base de données** :
   ```bash
   make up
   ```

2. **Tester votre script** :
   ```bash
   make run-sql FILE=sql/votre_script.sql
   ```

3. **Vérifier qu'il n'y a pas d'erreurs** :
   ```bash
   make test
   ```

4. **Vérifier que les données sont cohérentes** :
   ```bash
   make stats
   ```

---

## 📤 Soumettre une Pull Request

### 1. Fork et clone

```bash
# Fork le dépôt sur GitHub (bouton Fork)

# Clone votre fork
git clone https://github.com/VOTRE_USERNAME/advanced-sql-atut.git
cd advanced-sql-atut

# Ajouter le dépôt original comme remote
git remote add upstream https://github.com/abrahamkoloboe27/advanced-sql-atut.git
```

### 2. Créer une branche

```bash
# Créer une branche pour votre fonctionnalité
git checkout -b feature/nom-de-votre-feature

# Exemples :
# git checkout -b feature/add-cte-examples
# git checkout -b fix/typo-in-exercises
# git checkout -b doc/improve-contributing-guide
```

### 3. Faire vos modifications

- Modifiez les fichiers
- Testez vos changements (voir section Tester)
- Committez de manière atomique :

```bash
git add .
git commit -m "feat: Ajouter exemples de CTE récursives"

# Autres exemples :
# git commit -m "fix: Corriger erreur dans exercice 3"
# git commit -m "docs: Améliorer README avec exemples"
# git commit -m "chore: Mettre à jour docker-compose"
```

### 4. Pousser et créer la PR

```bash
# Pousser votre branche
git push origin feature/nom-de-votre-feature

# Créer une Pull Request sur GitHub
# Aller sur https://github.com/abrahamkoloboe27/advanced-sql-atut
# Cliquer sur "Compare & pull request"
```

### 5. Description de la PR

Utilisez ce template :

```markdown
## Description
Brève description de votre contribution

## Type de changement
- [ ] 🐛 Bug fix
- [ ] ✨ Nouvelle fonctionnalité
- [ ] 📝 Documentation
- [ ] 🎨 Style / Formatage
- [ ] ♻️ Refactoring
- [ ] 🧪 Tests

## Checklist
- [ ] J'ai testé mes modifications localement
- [ ] J'ai ajouté des commentaires en français
- [ ] J'ai suivi le style de code du projet
- [ ] J'ai mis à jour la documentation si nécessaire
- [ ] Mes commits ont des messages clairs
```

---

## 🎓 Types de contributions recherchées

### Exemples prioritaires

1. **Fonctions avancées** :
   - Window functions (LEAD, LAG, NTILE)
   - CTE récursives
   - JSONB et opérateurs JSON

2. **Performance** :
   - Exemples de slow queries → optimisation
   - Comparaison de plans d'exécution
   - Partitioning

3. **Cas d'usage réels** :
   - Gestion de panier e-commerce
   - Système de réservation
   - Audit trail / logs

4. **Sécurité** :
   - Row Level Security (RLS)
   - Chiffrement de colonnes
   - Audit de permissions

### Documentation

- Traductions (anglais, espagnol, etc.)
- Schémas et diagrammes visuels
- Vidéos tutoriels
- Astuces et raccourcis

### Outils

- Scripts de migration
- Docker optimisé pour production
- CI/CD avec tests automatiques

---

## ❓ Questions

Si vous avez des questions :

- 📧 Email : contact@example.com
- 💬 Ouvrir une [Discussion GitHub](https://github.com/abrahamkoloboe27/advanced-sql-atut/discussions)
- 🐛 Créer une [Issue](https://github.com/abrahamkoloboe27/advanced-sql-atut/issues)

---

## 📜 Code de conduite

- Soyez respectueux et bienveillant
- Acceptez les critiques constructives
- Focalisez sur ce qui est meilleur pour le projet
- Aidez les nouveaux contributeurs

---

**Merci pour votre contribution ! 🙏**
