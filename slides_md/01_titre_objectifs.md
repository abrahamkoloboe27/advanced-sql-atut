# 01 - Formation SQL PostgreSQL 🚀

## Objectif
Introduire la formation et établir les attentes pédagogiques pour les 3 heures à venir.

## Contenu

### 🎯 Titre de la formation
**Maîtriser SQL avec PostgreSQL : Des fondamentaux aux bonnes pratiques**

### 👥 Public cible
- Développeurs débutants en SQL
- Data Analysts en formation
- Professionnels souhaitant renforcer leurs bases

### 🎓 Objectifs pédagogiques
À l'issue de cette formation, vous serez capable de :

- ✅ Créer et structurer une base de données PostgreSQL complète
- ✅ Maîtriser les 4 familles SQL : DDL, DML, DCL, TCL
- ✅ Écrire des requêtes complexes avec jointures et agrégations
- ✅ Optimiser les performances avec indexes et EXPLAIN ANALYZE
- ✅ Gérer les transactions et comprendre les propriétés ACID
- ✅ Appliquer les bonnes pratiques de sécurité et performance

### 📋 Prérequis
- Connaissances de base en SQL (SELECT, WHERE)
- Ordinateur avec Docker installé
- Client PostgreSQL (psql, pgAdmin, DBeaver)
- Aucune expérience PostgreSQL nécessaire

### 🛠️ Environnement technique
- PostgreSQL 15+
- Base de données fictive : `shop_db`
- Tables : customers, products, orders

## Illustration suggérée
- Logo PostgreSQL
- Icônes représentant les 4 familles SQL
- Schéma simple de la base shop_db

## Exemple (entrée)
*Pas d'exemple de données pour cette slide d'introduction*

## Requête SQL
```sql
-- Vérification de la version PostgreSQL
SELECT version();
```

## Résultat (table)

| version |
|---------|
| PostgreSQL 15.x on x86_64-pc-linux-gnu, compiled by gcc... |

## Notes pour le présentateur
- 🎯 **Accroche** : Commencer par "Pourquoi SQL reste incontournable en 2024/2025"
- Demander aux participants leur niveau SQL (sondage rapide à main levée)
- Préciser que la formation est 70% pratique / 30% théorie
- Mentionner que le repo GitHub contient tous les exemples et solutions
- ⚠️ S'assurer que tout le monde a un environnement fonctionnel avant de continuer
- Partager le lien du repo dès le début
