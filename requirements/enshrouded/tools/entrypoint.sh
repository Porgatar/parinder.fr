#!/bin/bash

# update server
steamcmd \
    +@sSteamCmdForcePlatformType windows \
	+login anonymous \
    +app_update 2278520 validate \
    +quit

# Eding server password
ADMIN_PASSWORD=$(cat "$ENSHROUDED_ADMIN_PASS_FILE")
FRIEND_PASSWORD=$(cat "$ENSHROUDED_FRIEND_PASS_FILE")
DEFAULT_PASSWORD=$(cat "$ENSHROUDED_DEFAULT_PASS_FILE")
CONF_PATH="EnshroudedDedicatedServer/enshrouded_server.json"

jq --arg admin_pass "$ADMIN_PASSWORD" \
   --arg friend_pass "$FRIEND_PASSWORD" \
   --arg default_pass "$DEFAULT_PASSWORD" \
   '(.userGroups[] | select(.name == "Admin")).password = $admin_pass |
    (.userGroups[] | select(.name == "Friend")).password = $friend_pass |
    (.userGroups[] | select(.name == "Default")).password = $default_pass' \
   "$CONF_PATH" > "${CONF_PATH}.tmp" && mv "${CONF_PATH}.tmp" "$CONF_PATH"

# Wine talks too much and it's annoying
export WINEDEBUG=-all

# launch server
$HOME/.local/share/Steam/steamcmd/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/proton run $HOME/EnshroudedDedicatedServer/enshrouded_server.exe &

# Very big block of tape because of proton...
shutdown () {
    echo ""
    echo "INFO: Recieved SIGTERM, shutting down gracefully"
    kill -2 $enshrouded_pid
}
trap 'shutdown' TERM
timeout=0
while [ $timeout -lt 11 ]; do
    if ps -e | grep "enshrouded_serv"; then
        enshrouded_pid=$(ps -e | grep "enshrouded_serv" | awk '{print $1}')
        break
    elif [ $timeout -eq 10 ]; then
        echo "ERROR: Timed out waiting for enshrouded_server.exe to be running"
        exit 1
    fi
    sleep 6
    ((timeout++))
    echo "INFO: Waiting for enshrouded_server.exe to be running"
done
tail --pid=$enshrouded_pid -f /dev/null &
wait
if ps -e | grep "enshrouded_serv"; then
    tail --pid=$enshrouded_pid -f /dev/null
fi
echo "INFO: Shutdown complete."
exit 0
