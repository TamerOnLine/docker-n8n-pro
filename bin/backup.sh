#!/usr/bin/env bash
set -euo pipefail
source .env

TS=$(date +"%Y%m%d-%H%M%S")
mkdir -p backups

# اسم خدمة db قد يختلف حسب المشروع، نتعامل معه دِيناميكياً
DB_CID=$(docker compose ps -q db)
if [ -z "$DB_CID" ]; then
  echo "Database container not running"; exit 1
fi

echo "→ Dumping Postgres..."
docker exec -t "$DB_CID" pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" > "backups/db-${TS}.sql"

echo "→ Archiving n8n data..."
tar -czf "backups/n8n-${TS}.tgz" -C ./data n8n

echo "✅ Backups saved under ./backups"
