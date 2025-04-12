MAKEFLAGS=	--silent

all:		create_dirs
			docker-compose up -d

clean:
			docker-compose down -v --rmi all
			echo -e $(On_IGreen)"                                 "$(Color_Off)
			echo -e $(On_IGreen)$(BYellow)"       project cleaned!         "$(Color_Off)
			echo -e $(On_IGreen)"                                 "$(Color_Off)

fclean:		clean
			mkdir -p ~/save
			cp -r ~/data/* ~/save
			sudo rm -rf ~/data/*
			echo -e $(On_IGreen)"                                 "$(Color_Off)
			echo -e $(On_IGreen)$(BYellow)"    project fully cleaned!      "$(Color_Off)
			echo -e $(On_IGreen)"                                 "$(Color_Off)

create_dirs:
			mkdir -p ~/data/project_zomboid
			mkdir -p ~/data/satisfactory/conf
			mkdir -p ~/data/satisfactory/save

up:			create_dirs
			if [ -z "$(SERVICE)" ]; then \
				docker-compose up -d; \
			else \
				docker-compose up -d $(SERVICE); \
			fi

down:
			if [ -z "$(SERVICE)" ]; then \
				docker-compose down; \
			else \
				docker-compose stop $(SERVICE); \
			fi

reboot:
			if [ -z "$(SERVICE)" ]; then \
				docker-compose ps -q | xargs -r docker restart; \
			else \
				if [ "$(shell docker-compose ps -q $(SERVICE))" ]; then \
					docker-compose restart $(SERVICE); \
				fi \
			fi

status:
			docker-compose ps $(SERVICE)

re:
			if [ -z "$(SERVICE)" ]; then \
				docker-compose down -v --rmi all; \
				docker-compose up -d; \
			else \
				docker-compose stop $(SERVICE); \
				docker-compose rm -f $(SERVICE); \
				docker-compose image rm -f parinderfr-$(SERVICE); \
				docker-compose up -d $(SERVICE); \
			fi

.PHONY:		all up down reboot clean fclean re

#	-	-	-	-	-	Colors	-	-	-	-	-	-	#
#														|
BGreen=		'\033[1;32m'		#Bold Green				|
BYellow=	'\033[1;33m'		#Bold Yellow			|
#														|
On_IGreen=	'\033[0;102m'		#H.I-Green Background	|
#														|
Color_Off=	'\033[0m'			#Color Reset			|
#														|
#	-	-	-	-	-	-	-	-	-	-	-	-	-	#
