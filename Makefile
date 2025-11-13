.PHONY: help up down restart psql logs clean reset run-sql backup restore test

# Variables
POSTGRES_CONTAINER = shop_db_postgres
POSTGRES_USER = pguser
POSTGRES_DB = shop_db

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

help: ## Afficher cette aide
	@echo "$(GREEN)Commandes disponibles:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'

up: ## Démarrer PostgreSQL
	@echo "$(GREEN)Démarrage de PostgreSQL...$(NC)"
	docker-compose up -d
	@echo "$(GREEN)Attente du démarrage complet...$(NC)"
	@sleep 5
	@docker-compose ps
	@echo "$(GREEN)✓ PostgreSQL démarré sur localhost:5433$(NC)"

down: ## Arrêter PostgreSQL
	@echo "$(YELLOW)Arrêt de PostgreSQL...$(NC)"
	docker-compose down
	@echo "$(GREEN)✓ PostgreSQL arrêté$(NC)"

restart: down up ## Redémarrer PostgreSQL

psql: ## Se connecter à psql
	@echo "$(GREEN)Connexion à shop_db...$(NC)"
	docker exec -it $(POSTGRES_CONTAINER) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

logs: ## Afficher les logs PostgreSQL
	docker-compose logs -f postgres

clean: ## Nettoyer (arrêter + supprimer volumes)
	@echo "$(RED)Nettoyage complet (données supprimées)...$(NC)"
	docker-compose down -v
	@echo "$(GREEN)✓ Nettoyage terminé$(NC)"

reset: clean up ## Réinitialiser complètement (clean + up)
	@echo "$(GREEN)✓ Base réinitialisée$(NC)"

run-sql: ## Exécuter un fichier SQL (usage: make run-sql FILE=path/to/file.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)Erreur: Spécifiez un fichier avec FILE=path/to/file.sql$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)Exécution de $(FILE)...$(NC)"
	docker exec -i $(POSTGRES_CONTAINER) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(FILE)
	@echo "$(GREEN)✓ Script exécuté$(NC)"

backup: ## Créer une sauvegarde (backup.sql)
	@echo "$(GREEN)Création de la sauvegarde...$(NC)"
	docker exec $(POSTGRES_CONTAINER) pg_dump -U $(POSTGRES_USER) $(POSTGRES_DB) > backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✓ Sauvegarde créée$(NC)"

restore: ## Restaurer depuis une sauvegarde (usage: make restore FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)Erreur: Spécifiez un fichier avec FILE=backup.sql$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)Restauration depuis $(FILE)...$(NC)"
	docker exec -i $(POSTGRES_CONTAINER) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < $(FILE)
	@echo "$(GREEN)✓ Restauration terminée$(NC)"

test: ## Tester la connexion à la base
	@echo "$(GREEN)Test de connexion...$(NC)"
	@docker exec $(POSTGRES_CONTAINER) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) -c "SELECT 'Connexion OK' AS status;"
	@echo "$(GREEN)✓ Connexion réussie$(NC)"

stats: ## Afficher les statistiques de la base
	@echo "$(GREEN)Statistiques de shop_db:$(NC)"
	@docker exec $(POSTGRES_CONTAINER) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) -c "\
		SELECT \
			'customers' AS table_name, \
			COUNT(*) AS row_count \
		FROM customers \
		UNION ALL \
		SELECT 'products', COUNT(*) FROM products \
		UNION ALL \
		SELECT 'orders', COUNT(*) FROM orders;"

# Exécuter les scripts par catégorie
run-ddl: ## Exécuter tous les scripts DDL
	@echo "$(GREEN)Exécution des scripts DDL...$(NC)"
	@$(MAKE) run-sql FILE=sql/01_ddl/create_tables.sql
	@$(MAKE) run-sql FILE=sql/01_ddl/alter_drop.sql
	@$(MAKE) run-sql FILE=sql/01_ddl/indexes_views.sql

run-dml: ## Exécuter tous les scripts DML
	@echo "$(GREEN)Exécution des scripts DML...$(NC)"
	@$(MAKE) run-sql FILE=sql/02_dml/select_queries.sql
	@$(MAKE) run-sql FILE=sql/02_dml/update_delete_truncate.sql
	@$(MAKE) run-sql FILE=sql/02_dml/merge_upsert.sql

run-dcl: ## Exécuter les scripts DCL
	@echo "$(GREEN)Exécution des scripts DCL...$(NC)"
	@$(MAKE) run-sql FILE=sql/03_dcl/grant_revoke.sql

run-tcl: ## Exécuter les scripts TCL
	@echo "$(GREEN)Exécution des scripts TCL...$(NC)"
	@$(MAKE) run-sql FILE=sql/04_tcl/transactions.sql
	@$(MAKE) run-sql FILE=sql/04_tcl/isolation_examples.sql

run-admin: ## Exécuter les scripts d'administration
	@echo "$(GREEN)Exécution des scripts d'administration...$(NC)"
	@$(MAKE) run-sql FILE=sql/05_admin/explain_analyze_examples.sql

# Exécuter les exercices
run-ex1: ## Exécuter la solution de l'exercice 1
	@$(MAKE) run-sql FILE=solutions/exercice01.sql

run-ex2: ## Exécuter la solution de l'exercice 2
	@$(MAKE) run-sql FILE=solutions/exercice02.sql

run-ex3: ## Exécuter la solution de l'exercice 3
	@$(MAKE) run-sql FILE=solutions/exercice03.sql

run-ex4: ## Exécuter la solution de l'exercice 4
	@$(MAKE) run-sql FILE=solutions/exercice04.sql

run-ex5: ## Exécuter la solution de l'exercice 5
	@$(MAKE) run-sql FILE=solutions/exercice05.sql

run-ex6: ## Exécuter la solution de l'exercice 6
	@$(MAKE) run-sql FILE=solutions/exercice06.sql
