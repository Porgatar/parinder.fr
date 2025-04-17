#!/bin/bash

# handle_api_key() {

#     if [[ -e "secrets/user_management_42auth_client_id.txt" && -e "secrets/user_management_42auth_client_secret.txt" ]]; then

#         echo "getting 42Auth secrets to unable 42Auth login..."
#         sed -i "s|const clientId = '.*';|const clientId = '$(cat secrets/user_management_42auth_client_id.txt)';|" "requirements/user_management/app/management/static/login/js/login.js"
#     else

#         echo "
# Don't forget to create a new api to unable the 42 remote auth and set the
# redirection path to 'https://$(hostname -I | awk '{print $1}')/user/api/register-42/' here:
# https://profile.intra.42.fr/oauth/applications
# "

#         read -p "Enter Client UID : " CLIENT_UID
#         read -p "Enter Client Secret : " CLIENT_SECRET

#         echo "$CLIENT_UID" > secrets/user_management_42auth_client_id.txt
#         echo "$CLIENT_SECRET" > secrets/user_management_42auth_client_secret.txt

#         echo "getting 42Auth secrets to unable 42Auth login..."
#         sed -i "s|const clientId = '.*';|const clientId = '$CLIENT_UID';|" "requirements/user_management/app/management/static/login/js/login.js"
#     fi
# }

# if grep -q "127.0.0.1    ft_transcendence.fr" /etc/hosts; then

#     echo "the ft_transcendence.fr host is already set."
# else

#     echo "127.0.0.1    ft_transcendence.fr" | sudo tee -a /etc/hosts > /dev/null
#     echo "the ft_transcendence.fr host has been set."
# fi

if [ -d "secrets" ]; then

  echo "secrets already exists..."
#   handle_api_key
  exit 0
fi

# read -p "Enter debug setup (0/1) : " DEBUG
# read -p "Enter the db name : " DB_NAME
# read -p "Enter the db user name : " DB_USER
# read -p "Enter the grafana admin name : " GF_ADMIN_NAME

echo "creating the .env file..."
mkdir -p secrets
cat <<EOF > .env
# HOST
# IP_ADDRESS='$(hostname -I | awk '{print $1}')'

# # POSTGRES
# POSTGRES_HOST='postgres'
# POSTGRES_PORT='5432'
# POSTGRES_ENGINE='postgresql'
# POSTGRES_DB='${DB_NAME}'
# POSTGRES_USER='${DB_USER}'
# POSTGRES_PASSWORD_FILE='/run/secrets/db_user_pass'

# # USER_MANAGEMENT
# USER_MANAGEMENT_DEBUG=${DEBUG}
# USER_MANAGEMENT_SECRET_KEY_FILE='/run/secrets/user_management_secret_key'
# USER_MANAGEMENT_42AUTH_CLIENT_ID_FILE='/run/secrets/user_management_42auth_client_id'
# USER_MANAGEMENT_42AUTH_CLIENT_SECRET_FILE='/run/secrets/user_management_42auth_client_secret'
# USER_MANAGEMENT_ALLOWED_HOSTS='userManagement'

# # GAME
# GAME_DEBUG=${DEBUG}
# GAME_SECRET_KEY_FILE='/run/secrets/game_secret_key'
# GAME_ALLOWED_HOSTS='game'

# # CHAT
# CHAT_DEBUG=${DEBUG}
# CHAT_SECRET_KEY_FILE='/run/secrets/chat_secret_key'
# CHAT_ALLOWED_HOSTS='chat'

# # GRAFANA
# GF_SECURITY_ADMIN_USER='${GF_ADMIN_NAME}'
# GF_SECURITY_ADMIN_PASSWORD__FILE='/run/secrets/gf_admin_pass'

# # EXPORTERS
# REDIS_ADDR='redis:6379'

# PROJECT ZOMBOID
PROJECT_ZOMBOID_ADMIN_PASS_FILE='/run/secrets/project_zomboid_admin_pass'
EOF

echo "creating random secret passwords..."
echo "$(openssl rand -base64 12)" > secrets/project_zomboid_admin_pass.txt
# echo "$(openssl rand -base64 12)" > secrets/user_management_secret_key.txt
# echo "$(openssl rand -base64 12)" > secrets/game_secret_key.txt
# echo "$(openssl rand -base64 12)" > secrets/chat_secret_key.txt
# echo "$(openssl rand -base64 12)" > secrets/db_user_pass.txt
# echo "$(openssl rand -base64 12)" > secrets/gf_admin_pass.txt

echo "creating ssl key/crt..."
openssl req -x509 -newkey rsa:4096 \
    -keyout requirements/nginx/tools/ssl.key \
    -out requirements/nginx/tools/ssl.crt \
    -sha256 -days 3650 -nodes \
    -subj "/C=FR/ST=Charente/L=Angoulême/O=42/OU=42/CN=ft_transcendence.42.fr" \
	> /dev/null 2>&1

# handle_api_key

echo "Done."
