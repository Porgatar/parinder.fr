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
EOF

echo "creating random secret passwords..."
echo "$(openssl rand -base64 12)" > secrets/project_zomboid_admin_pass.txt

echo "Done."
