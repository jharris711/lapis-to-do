# A todo app written in Lua using the Lapis framework

- [Lua Programming Language](https://www.lua.org/)
- [Lapis Web Framework](https://leafo.net/lapis/)

## Prerequisites

- Docker
- Docker Compose

## Start the app

### 1. Build and start containers
```bash
docker-compose up -d
```

### 2. Run database migrations (first time only)
```bash
docker-compose exec app lapis migrate docker
```

### 3. Access the app
Open your browser to [http://localhost:8080](http://localhost:8080)

## Development

### View logs
```bash
docker-compose logs -f app
```

### Stop the app
```bash
docker-compose down
```

### Rebuild after code changes
```bash
docker-compose build
docker-compose up -d
```

### Access the app container shell
```bash
docker-compose exec app sh
```

### Run migrations
```bash
docker-compose exec app lapis migrate docker
```

## Local Development (without Docker)

If you prefer to run without Docker:

```bash
cd lapis-to-do 
lapis server
```

Note: Requires Lua, LuaJIT, OpenResty, and PostgreSQL installed locally.