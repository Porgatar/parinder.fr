######## nginx ########

FROM nginx:1.27

RUN apt-get update && apt-get install -y \
    certbot \
    python3-certbot-nginx \
    cron \
    && rm -rf /var/lib/apt/lists/*

COPY tools/nginx.conf /etc/nginx/nginx.conf

COPY www/html /var/www/html

COPY tools/entrypoint.sh .

RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
