#!/bin/bash
set -e

cd /rh_mangnt_app

echo ">>> Limpando caches do Laravel..."
php artisan config:clear || true
php artisan route:clear || true
php artisan view:clear || true
php artisan cache:clear || true

echo ">>> Recriando caches do Laravel..."
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

echo ">>> Chamando entrypoint original..."
exec /opt/docker/bin/entrypoint.sh "$@"
