#!/bin/bash

# update server
steamcmd \
	+login anonymous \
    +app_update 380870 validate \
    +quit

# launch server
/root/.steam/steamapps/common/ProjectZomboid/start-server.sh -adminpassword $(cat $PROJECT_ZOMBOID_ADMIN_PASS_FILE)
