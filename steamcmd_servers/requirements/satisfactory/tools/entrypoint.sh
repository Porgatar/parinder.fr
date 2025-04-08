#!/bin/bash

# update server
steamcmd \
	+login anonymous \
    +app_update 1690800 -beta experimental validate \
    +quit

# launch server
./SatisfactoryDedicatedServer/FactoryServer.sh
