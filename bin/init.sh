#!/usr/bin/env bash
set -euo pipefail

if ! command -v openssl >/dev/null 2>&1; then
  echo "Please install openssl first"; exit 1
fi

cp -n .env.example .env || true

# توليد مفتاح تشفير
if ! grep -q '^N8N_ENCRYPTION_KEY=' .env; then
  echo "N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)" >> .env
else
  # استبدال القيمة إن كانت placeholder
  sed -i.bak -E "s|^N8N_ENCRYPTION_KEY=.*$|N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)|" .env
fi

# طلب الدومين والإيميل (مرة واحدة فقط إن كانت placeholder)
if grep -q 'your-domain.com' .env; then
  read -rp "Enter domain (e.g. n8n.example.com): " DOMAIN
  sed -i.bak -E "s|^N8N_HOST=.*$|N8N_HOST=${DOMAIN}|" .env
fi
if grep -q 'you@example.com' .env; then
  read -rp "Let's Encrypt email: " EMAIL
  sed -i.bak -E "s|^LE_EMAIL=.*$|LE_EMAIL=${EMAIL}|" .env
fi

# Basic Auth (اختياري)
read -rp "Add BasicAuth for n8n? (y/N): " ADD_BA
if [[ "${ADD_BA:-N}" =~ ^[Yy]$ ]]; then
  read -rp "Username: " BA_USER
  read -rsp "Password: " BA_PASS; echo
  if command -v htpasswd >/dev/null 2>&1; then
    # صيغة Apache apr1
    HASH=$(printf "%s\n" "$BA_PASS" | htpasswd -ni "$BA_USER" | cut -d: -f2-)
    echo "BASIC_AUTH_USERS=${BA_USER}:${HASH}" >> .env
  else
    # بديل بسيط: MD5 apr1 عبر openssl
    SALT=$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8)
    HASH=$(openssl passwd -apr1 -salt "$SALT" "$BA_PASS")
    echo "BASIC_AUTH_USERS=${BA_USER}:${HASH}" >> .env
  fi
fi

mkdir -p data/n8n data/postgres data/letsencrypt backups
echo "✅ .env prepared. Run: docker compose up -d"
