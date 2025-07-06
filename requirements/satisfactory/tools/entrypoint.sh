#!/bin/bash

# update server
steamcmd \
    +force_install_dir $HOME/SatisfactoryDedicatedServer \
	+login anonymous \
    +app_update 1690800 validate \
    +quit

# launch server
./SatisfactoryDedicatedServer/FactoryServer.sh
