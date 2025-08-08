# Caminho para o docker-compose
DC=docker-compose

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
	@echo "AJUDA:"
	@echo "  help            - Mostrar esta ajuda"
