#!/bin/bash

# update server
steamcmd \
	+login anonymous \
    +app_update 380870 validate \
    +quit

# launch server
/root/.steam/steamapps/common/ProjectZomboid/start-server.sh -adminpassword aouhg54sd
