#!/bin/bash

DOMAIN_NAME="parinder.fr"

echo " [INFO] starting script !!!"

# cron setup for certification renewal
echo "0 */12 * * * root certbot renew --quiet --deploy-hook \"nginx -s reload\"" > /etc/cron.d/renew-certbot
chmod 0644 /etc/cron.d/renew-certbot
crontab /etc/cron.d/renew-certbot

# certification
if [ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
  echo " [INFO] generating ssl certification"
  certbot certonly \
    --standalone \
    --non-interactive \
    --agree-tos \
    --register-unsafely-without-email \
    -d $DOMAIN_NAME
fi

nginx -g "daemon off;"
