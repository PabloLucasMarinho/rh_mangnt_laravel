# =====================================================
# 1) Stage: Composer (dependências PHP)
# =====================================================
FROM composer:2.7 AS composer

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install \
    --no-dev \
    --no-interaction \
    --prefer-dist \
    --optimize-autoloader

COPY . .

RUN composer dump-autoload --optimize


# =====================================================
# 2) Stage: Frontend build (Vite)
# =====================================================
FROM node:20-alpine AS node

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build


# =====================================================
# 3) Stage: Runtime (PHP + Nginx)
# =====================================================
FROM php:8.2-fpm-alpine

# Dependências do sistema
RUN apk add --no-cache \
    nginx \
    supervisor \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    bash

# Extensões PHP necessárias ao Laravel
RUN docker-php-ext-install \
    intl \
    pdo \
    pdo_mysql \
    zip \
    opcache

# Configuração do PHP
COPY docker/php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Diretório da aplicação
WORKDIR /var/www/html

# Copia código e dependências já buildadas
COPY --from=composer /app /var/www/html
COPY --from=node /app/public/build /var/www/html/public/build

# Permissões
RUN chown -R www-data:www-data \
    storage \
    bootstrap/cache

# Configuração do Nginx
COPY docker/nginx/default.conf /etc/nginx/http.d/default.conf

# Configuração do Supervisor
COPY docker/supervisor/supervisord.conf /etc/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
