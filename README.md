# docker-n8n-pro — Self-Hosted n8n (TLS, Traefik, Backups)

## 🚀 Quick Start (Production with Domain)

```bash
git clone <your_repo_url> docker-n8n-pro
cd docker-n8n-pro
bash bin/init.sh              # Prepares .env and folders
docker compose up -d          # Launches Traefik + DB + n8n
```
- Wait ~1 minute for SSL certificates.
- Open: `https://YOUR_DOMAIN`

## 🧪 Local Development (No Domain / No SSL)

```bash
cp .env.example .env
docker compose -f docker-compose.yml -f docker-compose.override.yml up -d
# Visit http://localhost:5678
```

## 💾 Backups

```bash
bash bin/backup.sh
bash bin/restore.sh backups/db-*.sql backups/n8n-*.tgz
```

## 📁 Templates

Import automation templates from: `templates/flows/*.json` inside n8n.
