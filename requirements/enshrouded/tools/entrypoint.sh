#!/bin/bash

# update server
steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir $HOME/EnshroudedDedicatedServer \
	+login anonymous \
    +app_update 2278520 validate \
    +quit

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
