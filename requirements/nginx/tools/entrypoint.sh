#!/bin/bash

DOMAIN_NAME="parinder.fr"

echo " [INFO] starting script !!!"

certbot certonly \
  --standalone \
  --non-interactive \
  --agree-tos \
  --register-unsafely-without-email \
  -d $DOMAIN_NAME

nginx -g "daemon off;"
