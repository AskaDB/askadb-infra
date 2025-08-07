# Caminho para o docker-compose
DC=docker-compose

# Subir todos os serviços com build
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

# Ver logs em tempo real
logs:
	$(DC) logs -f

# Ver status dos containers
ps:
	docker ps

# Limpar containers parados, redes e volumes (cuidado!)
clean:
	docker system prune -f
