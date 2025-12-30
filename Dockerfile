FROM webdevops/php-nginx:8.2

ENV WEB_DOCUMENT_ROOT=/app/public

WORKDIR /rh_mangnt_app

COPY . .

RUN composer install --no-dev --optimize-autoloader
RUN chmod -R 777 storage bootstrap/cache

COPY supervisor/conf.d/queue.conf /opt/docker/etc/supervisor.d/queue.conf

EXPOSE 80

CMD ["supervisord"]
