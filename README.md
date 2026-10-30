# AutoManager

Protótipo educacional para gestão de oficinas mecânicas.

## Pré-requisitos

- Git
- Docker com Docker Compose

## Como iniciar

Clone o projeto:

```bash
git clone https://github.com/VictorCalisto/auto_app.git
```

Entre na pasta do projeto:

```bash
cd auto_app
```

Suba os serviços:

```bash
docker compose up -d
```

Os serviços iniciados são:

- Rails API: http://localhost:3000
- Flutter Web: http://localhost:8080
- PostgreSQL
- Redis
- Sidekiq

Para acompanhar os logs:

```bash
docker compose logs -f
```

Para encerrar os containers:

```bash
docker compose down
```

Os dados do PostgreSQL, Redis, Bundler e cache do Flutter são mantidos em
volumes Docker. Por isso, reiniciar os containers não precisa baixar novamente
as dependências.

O Rails funciona como API e não serve a interface do sistema. A interface é
executada pelo Flutter Web.
