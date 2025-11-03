#!/usr/bin/env bash
set -euo pipefail
source .env

DB_FILE=${1:-}
N8N_TGZ=${2:-}

if [ ! -f "$DB_FILE" ] || [ ! -f "$N8N_TGZ" ]; then
  echo "Usage: bin/restore.sh backups/db-YYYYmmdd-HHMMSS.sql backups/n8n-YYYYmmdd-HHMMSS.tgz"
  exit 1
fi

DB_CID=$(docker compose ps -q db)
if [ -z "$DB_CID" ]; then
  echo "Database container not running"; exit 1
fi

echo "→ Restoring Postgres..."
cat "$DB_FILE" | docker exec -i "$DB_CID" psql -U "$POSTGRES_USER" -d "$POSTGRES_DB"

echo "→ Restoring n8n data..."
tar -xzf "$N8N_TGZ" -C ./data

echo "✅ Restore done."
