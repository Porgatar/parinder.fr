######## Satisfactory ########

FROM ubuntu:24.04

ENV USER ubuntu
ENV HOME /home/ubuntu

WORKDIR $HOME

COPY tools/entrypoint.sh .
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

 # Install Satisfactory server
RUN steamcmd \
    +force_install_dir $HOME/SatisfactoryDedicatedServer \
	+login anonymous \
    +app_update 1690800 validate \
    +quit

RUN chown -R ubuntu:ubuntu $HOME
USER ubuntu

# server Launch
ENTRYPOINT ["./entrypoint.sh"]
