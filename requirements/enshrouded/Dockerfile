######## Enshrouded ########

FROM ubuntu:24.04

# global/steam env
ENV USER=ubuntu \
    HOME=/home/ubuntu \
    LANG='en_US.UTF-8' \
    LANGUAGE='en_US:en'

# proton GE ENV
ENV EXTERNAL_CONFIG=0 \
    GE_PROTON_VERSION="9-27" \
    STEAM_SDK64_PATH="$HOME/.steam/sdk64" \
    STEAM_SDK32_PATH="$HOME/.steam/sdk32" \
    STEAM_COMPAT_CLIENT_INSTALL_PATH="$HOME/.local/share/Steam/steamcmd/" \
    STEAM_COMPAT_DATA_PATH="$HOME/.local/share/Steam/steamapps/compatdata/2278520" \
    UMU_ID=0

WORKDIR $HOME

# install SteamCMD and dependency
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG DEBIAN_FRONTEND=noninteractive
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends ca-certificates locales steamcmd \
    && rm -rf /var/lib/apt/lists/* \
    && locale-gen en_US.UTF-8 \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Install proton GE dependency
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends curl python3 libfreetype6 dbus lib32gcc-s1 \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id

USER ubuntu

# fix steam missing libraries
RUN steamcmd +quit \
    && mkdir -p $HOME/.steam \
    && ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
    && ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
    && ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
    && ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so

# Install proton GE
RUN mkdir -p "$HOME/.local/share/Steam/steamapps/compatdata/2278520" "$HOME/.local/share/Steam/steamcmd/compatibilitytools.d" \
    && curl -sqL "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz" | tar zxvf - -C "$HOME/.local/share/Steam/steamcmd/compatibilitytools.d/" 

# Install Enshrouded server
RUN steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir $HOME/EnshroudedDedicatedServer \
	+login anonymous \
    +app_update 2278520 validate \
    +quit

COPY --chown=ubuntu:ubuntu tools/entrypoint.sh .
COPY --chown=ubuntu:ubuntu tools/enshrouded_server.json EnshroudedDedicatedServer/

RUN chmod +x ./entrypoint.sh

# server Launch
ENTRYPOINT ["./entrypoint.sh"]
