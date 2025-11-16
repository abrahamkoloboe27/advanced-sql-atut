# 📚 Slides Markdown - Formation SQL PostgreSQL

## Vue d'ensemble

Ce dossier contient **27 slides au format Markdown** pour une formation complète sur SQL avec PostgreSQL.

Chaque fichier Markdown représente une diapositive avec :
- ✅ **Titre** (H1)
- ✅ **Objectif** : But pédagogique (1-2 phrases)
- ✅ **Contenu** : Explication théorique avec bullets et tableaux
- ✅ **Illustration suggérée** : Recommandations visuelles
- ✅ **Exemple (entrée)** : Données source en table Markdown
- ✅ **Requête SQL** : Code exécutable dans blocs ```sql```
- ✅ **Résultat (table)** : Sortie attendue en table Markdown
- ✅ **Notes pour le présentateur** : Conseils, démos, pièges à éviter

## 📋 Liste des slides

| # | Fichier | Titre | Durée recommandée |
|---|---------|-------|-------------------|
| 00 | `00_plan.md` | Plan Pédagogique | 5 min |
| 01 | `01_titre_objectifs.md` | Titre & Objectifs | 5 min |
| 02 | `02_plan_seance.md` | Plan de la Séance | 5 min |
| 03 | `03_sgbdr.md` | C'est quoi un SGBDR ? | 10 min |
| 04 | `04_sql.md` | C'est quoi SQL ? | 10 min |
| 05 | `05_familles_sql.md` | Familles DDL/DML/DCL/TCL | 10 min |
| 06 | `06_ddl.md` | DDL : CREATE/ALTER/DROP | 15 min |
| 07 | `07_dml.md` | DML : SELECT/INSERT/UPDATE/DELETE | 15 min |
| 08 | `08_merge_upsert.md` | MERGE / Upsert PostgreSQL | 10 min |
| 09 | `09_acid.md` | ACID | 10 min |
| 10 | `10_transactions.md` | Transactions BEGIN/COMMIT/ROLLBACK | 15 min |
| 11 | `11_sql_aujourdhui.md` | Pourquoi SQL aujourd'hui ? | 10 min |
| 12 | `12_anatomy_select.md` | Anatomie d'un SELECT | 10 min |
| 13 | `13_where_filtres.md` | WHERE / Filtres / NULL | 10 min |
| 14 | `14_group_by_having.md` | GROUP BY / HAVING | 15 min |
| 15 | `15_fonctions.md` | Fonctions (dates, texte, CASE...) | 15 min |
| 16 | `16_jointures.md` | Jointures INNER/LEFT/RIGHT/FULL | 20 min |
| 17 | `17_cte_subqueries.md` | CTE vs Subqueries | 15 min |
| 18 | `18_union_except_intersect.md` | UNION / EXCEPT / INTERSECT | 10 min |
| 19 | `19_window_functions.md` | Window Functions | 20 min |
| 20 | `20_explain_analyze.md` | EXPLAIN ANALYZE | 15 min |
| 21 | `21_indexes_views.md` | Indexes / Views / MV | 20 min |
| 22 | `22_optimisation.md` | Optimisation & Bonnes pratiques | 15 min |
| 23 | `23_securite_dcl.md` | Sécurité GRANT/REVOKE | 15 min |
| 24 | `24_migrations_cicd.md` | Migrations & CI/CD | 10 min |
| 25 | `25_erreurs_communes.md` | Erreurs communes | 10 min |
| 26 | `26_exercices.md` | Exercices proposés | 10 min |
| 27 | `27_annexes_ressources.md` | Annexes & Ressources | 5 min |

**Durée totale slides** : ~3h15 (hors exercices pratiques)

## 🎯 Utilisation

### Pour le formateur

**Préparation** :
1. Lire tous les slides en avance
2. Préparer environnement PostgreSQL + démo
3. Tester tous les exemples SQL
4. Adapter timing selon niveau du groupe

**Pendant la formation** :
- Projeter ou partager les slides Markdown (rendu GitHub, VS Code, Obsidian...)
- Alterner théorie (slides) et pratique (live coding)
- Exécuter les exemples SQL en direct
- Encourager questions à tout moment

**Format de présentation** :
- **Markdown natif** : GitHub, GitLab, Bitbucket (rendu auto)
- **Marp** : Convertir en slides HTML/PDF (https://marp.app/)
- **Reveal.js** : Présentation interactive
- **Obsidian** : Mode présentation
- **VS Code + extension** : Markdown Preview Enhanced

### Pour les participants

**Pendant la formation** :
- Suivre les slides projetés
- Tester les exemples dans votre environnement
- Prendre notes supplémentaires

**Après la formation** :
- Consulter les slides comme référence
- Refaire les exemples SQL
- Explorer les "Notes pour le présentateur"

## 📦 Structure d'un slide

Chaque fichier suit ce template :

```markdown
# XX - Titre du slide 🎯

## Objectif
Phrase décrivant ce que le participant va apprendre.

## Contenu
- Point 1
- Point 2
- Tableau si pertinent

## Illustration suggérée
Recommandation visuelle pour enrichir le slide.

## Exemple (entrée)
**Table exemple**
| col1 | col2 |
|------|------|
| val1 | val2 |

## Requête SQL
\`\`\`sql
SELECT * FROM table;
\`\`\`

## Résultat (table)
| col1 | col2 |
|------|------|
| res1 | res2 |

## Notes pour le présentateur
- 🎯 Message clé
- Démonstration live suggérée
- Erreurs fréquentes
- Bonnes pratiques
```

## 🚀 Conversion en slides

### Marp (recommandé pour PDF/HTML)

```bash
# Installer Marp CLI
npm install -g @marp-team/marp-cli

# Convertir un slide en PDF
marp 01_titre_objectifs.md -o output.pdf

# Convertir tous les slides en HTML
marp *.md --html
```

### Reveal.js

Utiliser un convertisseur Markdown → Reveal.js ou éditer manuellement.

### Obsidian

1. Ouvrir le dossier dans Obsidian
2. Utiliser le mode "Slide" (Ctrl+E)

## 💡 Conseils d'utilisation

### Ordre de présentation

Suivre l'ordre numérique (00 → 27) pour progression logique.

**Variantes possibles** :
- **Version courte (2h)** : Slides 01-07, 10, 13, 16, 20, 22, 26
- **Version standard (3h)** : Tous les slides
- **Version avancée (4h)** : Tous + temps étendu sur 17, 19, 21, 24

### Adaptation du contenu

Les slides sont modulaires :
- Retirer slides non pertinents pour votre audience
- Ajouter exemples métier spécifiques
- Adapter timing selon engagement

### Personnalisation

Vous pouvez :
- ✅ Modifier exemples pour votre contexte métier
- ✅ Ajouter slides supplémentaires
- ✅ Traduire en autre langue
- ✅ Adapter style Markdown

## 📊 Feedback & Contributions

**Améliorer les slides** :
- Signaler erreurs techniques
- Proposer exemples plus clairs
- Suggérer illustrations
- Partager retours d'expérience formateur

**Contribuer** : Voir `CONTRIBUTING.md` à la racine du repo.

## 📄 Licence

Ces slides font partie du projet `advanced-sql-atut` sous licence MIT.

---

**Bon enseignement ! 🎓**
