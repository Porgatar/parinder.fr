#!/bin/bash

if [ -d "secrets" ]; then

  echo "secrets already exists..."
  exit 0
fi

read -p "Enter the Country name : " SSL_C
read -p "Enter the State name : " SSL_ST
read -p "Enter the Locality name : " SSL_L
read -p "Enter the Organization name : " SSL_O
read -p "Enter the Organizational Unit name : " SSL_OU
read -p "Enter the Common name : " SSL_CN

echo "creating the .env file..."
mkdir -p secrets
cat <<EOF > .env
# HOST
# IP_ADDRESS='$(hostname -I | awk '{print $1}')'

# PROJECT ZOMBOID
PROJECT_ZOMBOID_ADMIN_PASS_FILE='/run/secrets/project_zomboid_admin_pass'
EOF

echo "creating random secret passwords..."
echo "$(openssl rand -base64 12)" > secrets/project_zomboid_admin_pass.txt

echo "creating ssl key/crt..."
openssl req -x509 -newkey rsa:4096 \
    -keyout requirements/nginx/tools/ssl.key \
    -out requirements/nginx/tools/ssl.crt \
    -sha256 -days 3650 -nodes \
    -subj "/C=$SSL_C/ST=$SSL_ST/L=$SSL_L/O=$SSL_O/OU=$SSL_OU/CN=$SSL_CN" \
	> /dev/null 2>&1

echo "Done."
