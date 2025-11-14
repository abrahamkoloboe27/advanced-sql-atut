#!/bin/bash

# ============================================================================
# Script de test pour valider l'installation de shop_db
# ============================================================================

echo "========================================="
echo "🧪 TEST DE VALIDATION - shop_db"
echo "========================================="
echo ""

# Vérifier que Docker est installé
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé"
    exit 1
fi

echo "✅ Docker installé"

# Vérifier que docker-compose.yml existe
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml introuvable"
    exit 1
fi

echo "✅ docker-compose.yml trouvé"

# Valider la syntaxe du docker-compose
echo ""
echo "📋 Validation de docker-compose.yml..."
docker compose config > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ docker-compose.yml valide"
else
    echo "❌ docker-compose.yml invalide"
    exit 1
fi

# Vérifier l'existence des fichiers SQL
echo ""
echo "📋 Vérification des fichiers SQL..."

SQL_FILES=(
    "sql/00_create_database.sql"
    "sql/01_ddl/create_tables.sql"
    "sql/01_ddl/alter_drop.sql"
    "sql/01_ddl/indexes_views.sql"
    "sql/02_dml/insert_seed.sql"
    "sql/02_dml/select_queries.sql"
    "sql/02_dml/update_delete_truncate.sql"
    "sql/02_dml/merge_upsert.sql"
    "sql/03_dcl/grant_revoke.sql"
    "sql/04_tcl/transactions.sql"
    "sql/04_tcl/isolation_examples.sql"
    "sql/05_admin/explain_analyze_examples.sql"
)

MISSING_FILES=0
for file in "${SQL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file MANQUANT"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo ""
    echo "❌ $MISSING_FILES fichiers SQL manquants"
    exit 1
fi

echo ""
echo "✅ Tous les fichiers SQL présents ($((${#SQL_FILES[@]})) fichiers)"

# Vérifier les exercices et solutions
echo ""
echo "📋 Vérification des exercices..."

if [ -f "exercises/README.md" ]; then
    echo "  ✅ exercises/README.md"
else
    echo "  ❌ exercises/README.md MANQUANT"
fi

SOLUTION_FILES=(
    "solutions/exercice01.sql"
    "solutions/exercice02.sql"
    "solutions/exercice03.sql"
    "solutions/exercice04.sql"
    "solutions/exercice05.sql"
    "solutions/exercice06.sql"
)

for file in "${SOLUTION_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file MANQUANT"
    fi
done

# Vérifier la documentation
echo ""
echo "📋 Vérification de la documentation..."

DOC_FILES=(
    "README.md"
    "CONTRIBUTING.md"
    "slides/00_plan.md"
    "assets/database-schema.md"
    "Makefile"
)

for file in "${DOC_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file MANQUANT"
    fi
done

echo ""
echo "========================================="
echo "✅ VALIDATION TERMINÉE AVEC SUCCÈS"
echo "========================================="
echo ""
echo "Pour démarrer PostgreSQL:"
echo "  docker compose up -d"
echo ""
echo "Pour se connecter:"
echo "  docker exec -it shop_db_postgres psql -U pguser -d shop_db"
echo ""
echo "Pour utiliser les commandes simplifiées:"
echo "  make help"
echo ""
