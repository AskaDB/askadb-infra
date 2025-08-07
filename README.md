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

## ▶️ Subir os serviços

```bash
cd infra
docker-compose up --build
```

## 🔁 Parar e resetar os serviços

```bash
docker-compose down -v   # Remove containers e volumes
docker-compose up --build
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

## 💡 Dicas

- Os serviços se comunicam entre si usando os nomes definidos no `docker-compose.yml` como hostnames.
- Para adicionar novos serviços, edite o `docker-compose.yml` e use `depends_on` e `env_file` para mantê-lo consistente.
