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

# Derrubar todos os containers
down:
	$(DC) down

# Rebuild dos containers
rebuild:
	$(DC) down && $(DC) up --build

# =============================================================================
# DEBUG LOCAL (serviços individuais)
# =============================================================================

# Subir apenas orchestrator-api para debug
debug-orchestrator:
	$(DC) up --build orchestrator-api

# Subir apenas nl-query para debug
debug-nl-query:
	$(DC) up --build nl-query

# Subir apenas query-engine para debug
debug-query-engine:
	$(DC) up --build query-engine

# Subir serviços backend (orchestrator + nl-query + query-engine) para debug
debug-backend:
	$(DC) up --build orchestrator-api nl-query query-engine

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

# Ver status dos containers
ps:
	docker ps

# Ver status dos containers do askadb
ps-askadb:
	docker ps --filter "name=askadb"

# Limpar containers parados, redes e volumes (cuidado!)
clean:
	docker system prune -f

# Limpar apenas containers do askadb
clean-askadb:
	$(DC) down -v
	docker rmi $$(docker images -q askadb/*) 2>/dev/null || true

# =============================================================================
# AJUDA
# =============================================================================

help:
	@echo "Comandos disponíveis:"
	@echo ""
	@echo "DESENVOLVIMENTO:"
	@echo "  up              - Subir todos os serviços com build"
	@echo "  start           - Subir serviços sem rebuild"
	@echo "  down            - Derrubar todos os containers"
	@echo "  rebuild         - Rebuild dos containers"
	@echo ""
	@echo "DEBUG LOCAL:"
	@echo "  debug-orchestrator  - Subir apenas orchestrator-api"
	@echo "  debug-nl-query      - Subir apenas nl-query"
	@echo "  debug-query-engine  - Subir apenas query-engine"
	@echo "  debug-backend       - Subir backend completo (orchestrator + nl-query + query-engine)"
	@echo ""
	@echo "PRODUÇÃO:"
	@echo "  up-prod         - Subir todos os serviços em modo produção"
	@echo "  start-prod      - Subir serviços de produção sem rebuild"
	@echo "  down-prod       - Derrubar serviços de produção"
	@echo ""
	@echo "UTILITÁRIOS:"
	@echo "  logs            - Ver logs em tempo real"
	@echo "  logs-orchestrator - Ver logs do orchestrator-api"
	@echo "  logs-nl-query   - Ver logs do nl-query"
	@echo "  logs-query-engine - Ver logs do query-engine"
	@echo "  ps              - Ver status dos containers"
	@echo "  ps-askadb       - Ver status dos containers do askadb"
	@echo "  clean           - Limpar containers parados, redes e volumes"
	@echo "  clean-askadb    - Limpar apenas containers do askadb"
	@echo ""
	@echo "AJUDA:"
	@echo "  help            - Mostrar esta ajuda"
