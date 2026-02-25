# Hormone Data API

Rails API for user-authenticated hormone studies and submissions.

## Run with Docker

### Requirements
- Docker Desktop (or Docker Engine + Compose v2)

### Start API
```bash
docker compose up --build
```

API will be available at `http://localhost:3000`.

### Stop API
```bash
docker compose down
```

### Reset local DB volume (optional)
```bash
docker compose down -v
```

## Auth Flow (API)

### Sign up
```bash
curl -X POST http://localhost:3000/signup \
  -H "Content-Type: application/json" \
  -d '{"user":{"email":"user@example.com","password":"password123","password_confirmation":"password123"}}'
```

### Log in
```bash
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

### Profile
```bash
curl http://localhost:3000/profile \
  -H "Authorization: Bearer <token>"
```
