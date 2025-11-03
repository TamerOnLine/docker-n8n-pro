# 🚀 Project Setup with Docker & Traefik

This repository provides a ready-to-use **Docker Compose environment** with support for both **development and production** setups, including **Traefik + HTTPS** for secure deployment.

## 📂 Project Structure

```
project/
├─ docker-compose.yml               # Base shared configuration
├─ docker-compose.override.yml      # Local development settings (Dev)
├─ docker-compose.prod.yml          # Production setup with Traefik + TLS
├─ .env.example                     # Default environment values for development
├─ .env.prod.example                # Secure environment values for production
├─ data/                            # Persistent application data
└─ backups/                         # Backup directory
```

## 🧑‍💻 Run in Development Mode (Local)

```bash
cp .env.example .env
docker compose up -d
```

> 🔥 Runs without HTTPS — ideal for local development and testing.

## 🏢 Run in Production (with Traefik + HTTPS)

```bash
cp .env.prod.example .env
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Production features:

✅ Built-in HTTPS via Traefik + Let's Encrypt  
✅ Automatic domain routing & SSL certificates  
✅ Organized services & logging  

## 🧱 Requirements

- Docker 26+
- Docker Compose v2+
- Domain name (required for production HTTPS)

## 🛠 Customization

- Update ports, environment variables, and domain settings in `.env`
- Add or modify services using `docker-compose.override.yml`

## 📦 Backups

Important data and configurations should be stored in the `backups/` directory.

---

If you find this project useful, feel free to ⭐ star the repo on GitHub!
