######## Enshrouded ########

FROM ubuntu:24.04

ENV USER ubuntu
ENV HOME /home/ubuntu

WORKDIR $HOME

COPY tools/entrypoint.sh .
COPY tools/enshrouded_server.json EnshroudedDedicatedServer/

RUN chmod 755 ./entrypoint.sh

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends ca-certificates locales steamcmd \
    && rm -rf /var/lib/apt/lists/*

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

# Create symlink for executable
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Update SteamCMD and verify latest version
RUN steamcmd +quit

# Fix missing directories and libraries
RUN mkdir -p $HOME/.steam \
    && ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
    && ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
    && ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
    && ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so

# Install proton GE and dependency
ENV EXTERNAL_CONFIG 0
ENV GE_PROTON_VERSION "9-27"
ENV STEAM_SDK64_PATH="$HOME/.steam/sdk64"
ENV STEAM_SDK32_PATH="$HOME/.steam/sdk32"
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH "$HOME/.local/share/Steam/steamcmd/"
ENV STEAM_COMPAT_DATA_PATH "$HOME/.local/share/Steam/steamapps/compatdata/2278520"
ENV UMU_ID 0

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends curl python3 libfreetype6 dbus lib32gcc-s1 jq \
    && mkdir -p "$HOME/.local/share/Steam/steamapps/compatdata/2278520" "$HOME/.local/share/Steam/steamcmd/compatibilitytools.d" \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id \
    && curl -sqL "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz" | tar zxvf - -C "$HOME/.local/share/Steam/steamcmd/compatibilitytools.d/" 

# Install Enshrouded server
RUN steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir $HOME/EnshroudedDedicatedServer \
	+login anonymous \
    +app_update 2278520 validate \
    +quit

RUN chown -R ubuntu:ubuntu $HOME
USER ubuntu

# server Launch
ENTRYPOINT ["./entrypoint.sh"]
