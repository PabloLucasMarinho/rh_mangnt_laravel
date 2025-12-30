FROM webdevops/php-nginx:8.4

ENV WEB_DOCUMENT_ROOT=/app/public

WORKDIR /app

COPY . /app

RUN composer install --no-dev --optimize-autoloader

RUN mkdir -p storage/logs \
    && chown -R application:application storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache

COPY supervisor/conf.d/queue.conf /opt/docker/etc/supervisor.d/queue.conf

EXPOSE 80
