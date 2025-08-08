# askadb - Infra

Infraestrutura para desenvolvimento local e integração entre os serviços da organização Askadb.

## 🚀 Serviços

Este ambiente inclui os seguintes serviços:

- **orchestrator-api** → Porta `8000`  
  Orquestra as chamadas entre a UI, `nl-query` e `query-engine`.

- **nl-query** → Porta `8001`  
  Serviço que transforma linguagem natural em queries SQL.

- **query-engine** → Porta `8002`  
  Executa queries em dados locais (CSV/Parquet) usando DuckDB.

## ▶️ Comandos Makefile

### Desenvolvimento

```bash
# Subir todos os serviços com build
make up

# Subir serviços sem rebuild
make start

# Derrubar todos os containers
make down

# Rebuild dos containers
make rebuild
```

### Debug Local (serviços individuais)

```bash
# Subir apenas orchestrator-api para debug
make debug-orchestrator

# Subir apenas nl-query para debug
make debug-nl-query

# Subir apenas query-engine para debug
make debug-query-engine

# Subir backend completo (orchestrator + nl-query + query-engine)
make debug-backend
```

### Produção

```bash
# Subir todos os serviços em modo produção
make up-prod

# Subir serviços de produção sem rebuild
make start-prod

# Derrubar serviços de produção
make down-prod
```

### Utilitários

```bash
# Ver logs em tempo real
make logs

# Ver logs de um serviço específico
make logs-orchestrator
make logs-nl-query
make logs-query-engine

# Ver status dos containers
make ps
make ps-askadb

# Limpar containers
make clean
make clean-askadb

# Mostrar ajuda completa
make help
```

## 🔁 Parar e resetar os serviços

```bash
make down
make up
```

## 🌐 Testar

Acesse a documentação Swagger em:

- http://localhost:8000/docs → orchestrator-api
- http://localhost:8001/docs → nl-query
- http://localhost:8002/docs → query-engine (se exposto)

## 🔐 Variáveis de ambiente

As variáveis globais estão no arquivo `.env` nesta mesma pasta.

Exemplo:

```env
OPENAI_API_KEY=sk-xxxxx
ENV=development
```

## 🏭 Produção

Para produção, use os comandos `make up-prod`, `make start-prod` e `make down-prod`. Estes comandos usam o arquivo `docker-compose.prod.yml` que inclui:

- Restart policies (`unless-stopped`)
- Network dedicada (`askadb-network`)
- Container names com prefixo `askadb-`
- Environment `FASTAPI_ENV=production`

## 💡 Dicas

- Os serviços se comunicam entre si usando os nomes definidos no `docker-compose.yml` como hostnames.
- Para adicionar novos serviços, edite o `docker-compose.yml` e use `depends_on` e `env_file` para mantê-lo consistente.
- Use `make debug-*` para subir apenas os serviços que você precisa para desenvolvimento.
- Use `make help` para ver todos os comandos disponíveis.
