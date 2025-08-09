# Caminho para o docker-compose
DC=docker-compose

# Use bash em um único shell por receita
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -o pipefail -c

# =============================================================================
# COMANDOS PRINCIPAIS
# =============================================================================

# Subir todos os serviços com build (desenvolvimento)
up:
	$(DC) up --build

# Subir os serviços sem rebuild
start:
	$(DC) up

# Derrubar todos os containers do askadb (orquestrador central)
down:
	$(DC) down
	docker stop $$(docker ps -q --filter "name=askadb") 2>/dev/null || true
	docker rm $$(docker ps -aq --filter "name=askadb") 2>/dev/null || true

# Rebuild dos containers
rebuild:
	$(DC) down && $(DC) up --build

# =============================================================================
# DESENVOLVIMENTO
# =============================================================================

# Subir todos os serviços em modo desenvolvimento (UI com hot reload)
up-dev:
	$(DC) -f docker-compose.dev.yml up --build

# Subir apenas a UI em modo desenvolvimento
dev-ui:
	$(DC) -f docker-compose.dev.yml up --build ui

# Subir backend + UI em desenvolvimento
dev-full:
	$(DC) -f docker-compose.dev.yml up --build

# =============================================================================
# DEBUG LOCAL (serviços individuais)
# =============================================================================

# Subir apenas askadb-orchestrator-api para debug
debug-orchestrator:
	$(DC) up --build orchestrator-api

# Subir apenas askadb-nl-query para debug
debug-nl-query:
	$(DC) up --build nl-query

# Subir apenas askadb-query-engine para debug
debug-query-engine:
	$(DC) up --build query-engine

# Subir apenas askadb-ui para debug
debug-ui:
	$(DC) up --build ui

# Subir serviços backend (orchestrator + nl-query + query-engine) para debug
debug-backend:
	$(DC) up --build orchestrator-api nl-query query-engine

# Subir frontend + backend para debug completo
debug-full:
	$(DC) up --build

# =============================================================================
# PRODUÇÃO
# =============================================================================

# Subir todos os serviços em modo produção
up-prod:
	FASTAPI_ENV=production $(DC) -f docker-compose.prod.yml up --build -d

# Subir serviços de produção sem rebuild
start-prod:
	FASTAPI_ENV=production $(DC) -f docker-compose.prod.yml up -d

# Derrubar serviços de produção
down-prod:
	$(DC) -f docker-compose.prod.yml down
	docker stop $$(docker ps -q --filter "name=askadb") 2>/dev/null || true
	docker rm $$(docker ps -aq --filter "name=askadb") 2>/dev/null || true

# =============================================================================
# UTILITÁRIOS
# =============================================================================

# Ver logs em tempo real
logs:
	$(DC) logs -f

# Ver logs de um serviço específico
logs-orchestrator:
	$(DC) logs -f orchestrator-api

logs-nl-query:
	$(DC) logs -f nl-query

logs-query-engine:
	$(DC) logs -f query-engine

logs-ui:
	$(DC) logs -f ui

# Ver status dos containers
ps:
	docker ps

# Ver status dos containers do askadb
ps-askadb:
	docker ps --filter "name=askadb"

# Limpar containers parados, redes e volumes (cuidado!)
clean:
	docker system prune -f

# Limpar apenas containers do askadb (orquestrador central)
clean-askadb:
	$(DC) down -v
	docker stop $$(docker ps -q --filter "name=askadb") 2>/dev/null || true
	docker rm $$(docker ps -aq --filter "name=askadb") 2>/dev/null || true
	docker rmi $$(docker images -q askadb/*) 2>/dev/null || true

# =============================================================================
# AJUDA
# =============================================================================

help:
	@echo "Comandos disponíveis:"
	@echo ""
	@echo "DESENVOLVIMENTO:"
	@echo "  up              - Subir todos os serviços com build (orquestrador central)"
	@echo "  start           - Subir serviços sem rebuild"
	@echo "  down            - Derrubar todos os containers do askadb (orquestrador central)"
	@echo "  rebuild         - Rebuild dos containers"
	@echo ""
	@echo "DESENVOLVIMENTO COM HOT RELOAD:"
	@echo "  up-dev          - Subir todos os serviços em modo desenvolvimento (UI com hot reload)"
	@echo "  dev-ui          - Subir apenas a UI em modo desenvolvimento"
	@echo "  dev-full        - Subir backend + UI em desenvolvimento"
	@echo ""
	@echo "DEBUG LOCAL:"
	@echo "  debug-orchestrator  - Subir apenas askadb-orchestrator-api"
	@echo "  debug-nl-query      - Subir apenas askadb-nl-query"
	@echo "  debug-query-engine  - Subir apenas askadb-query-engine"
	@echo "  debug-ui            - Subir apenas askadb-ui"
	@echo "  debug-backend       - Subir backend completo (orchestrator + nl-query + query-engine)"
	@echo "  debug-full          - Subir frontend + backend completo"
	@echo ""
	@echo "PRODUÇÃO:"
	@echo "  up-prod         - Subir todos os serviços em modo produção"
	@echo "  start-prod      - Subir serviços de produção sem rebuild"
	@echo "  down-prod       - Derrubar serviços de produção"
	@echo ""
	@echo "UTILITÁRIOS:"
	@echo "  logs            - Ver logs em tempo real"
	@echo "  logs-orchestrator - Ver logs do askadb-orchestrator-api"
	@echo "  logs-nl-query   - Ver logs do askadb-nl-query"
	@echo "  logs-query-engine - Ver logs do askadb-query-engine"
	@echo "  logs-ui         - Ver logs do askadb-ui"
	@echo "  ps              - Ver status dos containers"
	@echo "  ps-askadb       - Ver status dos containers do askadb"
	@echo "  clean           - Limpar containers parados, redes e volumes"
	@echo "  clean-askadb    - Limpar apenas containers do askadb (orquestrador central)"
	@echo ""
	@echo "GIT (multi-repo):"
	@echo "  status-all      - Mostra status/resumo de mudanças em todos os repos"
	@echo "  push-all        - git add/commit/push em todos os repos (MSG=\"...\")"
	@echo "  push-all-dry    - Dry-run do push-all (sem executar)"

# =============================================================================
# GIT - COMMIT & PUSH EM TODOS OS REPOS
# =============================================================================

# Diretório base (os repos ficam como irmãos do askadb-infra)
BASE_DIR := ..
# Liste aqui os repositórios que quer varrer
REPOS := \
  $(BASE_DIR)/askadb-ai-agent-sdk \
  $(BASE_DIR)/askadb-dashboard-core \
  $(BASE_DIR)/askadb-docs \
  $(BASE_DIR)/askadb-infra \
  $(BASE_DIR)/askadb-nl-query \
  $(BASE_DIR)/askadb-orchestrator-api \
  $(BASE_DIR)/askadb-pipeline-ingest \
  $(BASE_DIR)/askadb-query-engine \
  $(BASE_DIR)/askadb-ui

# Mensagem de commit (pode sobrescrever com MSG="...")
MSG ?= subindo ajustes
# Branch default caso HEAD esteja destacado e não haja main/master
DEFAULT_BRANCH ?= main

status-all:
	for repo in $(REPOS); do \
	  if [ -d "$$repo/.git" ]; then \
	    echo "===== $$repo ====="; \
	    cd "$$repo"; \
	    echo "Branch: $$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo '(detached)')"; \
	    git status --short --branch || true; \
	    cd - >/dev/null 2>&1 || true; \
	  else echo "Pulando $$repo (não é repo git)"; fi; \
	done

push-all:
	set -euo pipefail
	for repo in $(REPOS); do \
	  if [ -d "$$repo/.git" ]; then \
	    echo "===== $$repo ====="; \
	    cd "$$repo"; \
	    branch=$$(git symbolic-ref --short -q HEAD || true); \
	    if [ -z "$$branch" ]; then \
	      if git show-ref --verify --quiet refs/heads/main; then branch=main; \
	      elif git show-ref --verify --quiet refs/heads/master; then branch=master; \
	      else branch=$(DEFAULT_BRANCH); git checkout -b "$$branch" || git checkout "$$branch"; fi; \
	    fi; \
	    git checkout "$$branch" >/dev/null 2>&1 || true; \
	    if git remote get-url origin >/dev/null 2>&1; then :; else echo "(sem remote origin)"; fi; \
	    git fetch --all --prune >/dev/null 2>&1 || true; \
	    if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then git rebase --abort || true; fi; \
	    untracked=$$(git ls-files --others --exclude-standard | wc -l | tr -d ' '); \
	    if ! git diff --cached --quiet; then staged_changes=1; else staged_changes=0; fi; \
	    if ! git diff --quiet; then unstaged_changes=1; else unstaged_changes=0; fi; \
	    if [ "$$untracked" -gt 0 ] || [ "$$staged_changes" -eq 1 ] || [ "$$unstaged_changes" -eq 1 ]; then \
	      git add --all; \
	      git commit -m "$(MSG)" || true; \
	    else \
	      echo "Sem mudanças para commitar em $$repo"; \
	    fi; \
	    git pull --rebase || (git rebase --abort || true); \
	    if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then \
	      git push origin "$$branch" || true; \
	    else \
	      git push -u origin "$$branch" || true; \
	    fi; \
	    cd - >/dev/null 2>&1 || true; \
	  else \
	    echo "Pulando $$repo (não é repo git)"; \
	  fi; \
	done

push-all-dry:
	for repo in $(REPOS); do \
	  echo "===== $$repo ====="; \
	  echo "(dry) git add --all && git commit -m '$(MSG)' && git pull --rebase && git push"; \
	done
