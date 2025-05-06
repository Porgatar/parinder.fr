#!/bin/bash

if [ -d "secrets" ]; then

  echo "secrets already exists..."
  exit 0
fi

echo "creating the .env file..."
mkdir -p secrets
cat <<EOF > .env
# HOST
# IP_ADDRESS='$(hostname -I | awk '{print $1}')'

# PROJECT ZOMBOID
PROJECT_ZOMBOID_ADMIN_PASS_FILE='/run/secrets/project_zomboid_admin_pass'

# ENSHROUDED
ENSHROUDED_ADMIN_PASS_FILE='/run/secrets/enshrouded_admin_pass'
ENSHROUDED_FRIEND_PASS_FILE='/run/secrets/enshrouded_friend_pass'
ENSHROUDED_DEFAULT_PASS_FILE='/run/secrets/enshrouded_default_pass'
EOF

echo "creating random secret passwords..."
echo "$(openssl rand -base64 12)" > secrets/project_zomboid_admin_pass.txt
echo "$(openssl rand -base64 12)" > secrets/enshrouded_admin_pass.txt
echo "$(openssl rand -base64 12)" > secrets/enshrouded_friend_pass.txt
echo "$(openssl rand -base64 12)" > secrets/enshrouded_default_pass.txt

echo "creating ssl key/crt..."
openssl req -x509 -newkey rsa:4096 \
    -keyout requirements/nginx/tools/ssl.key \
    -out requirements/nginx/tools/ssl.crt \
    -sha256 -days 3650 -nodes \
    -subj "/C=FR/ST=Charente/L=Angoulême/O=42/OU=42/CN=ft_transcendence.42.fr" \
	> /dev/null 2>&1

echo "Done."
