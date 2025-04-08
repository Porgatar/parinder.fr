MAKEFLAGS=	--silent

all:
			mkdir -p ~/data/project_zomboid
			mkdir -p ~/data/satisfactory/conf
			mkdir -p ~/data/satisfactory/save
			docker-compose -f docker-compose.yml up -d
			echo -e $(On_IGreen)"                                 "$(Color_Off)
			echo -e $(On_IGreen)$(BGreen)"          docker up!            "$(Color_Off)
			echo -e $(On_IGreen)"                                 "$(Color_Off)

down:
			docker-compose -f docker-compose.yml down
			echo -e $(On_IGreen)"                                 "$(Color_Off)
			echo -e $(On_IGreen)$(BYellow)"         docker down!           "$(Color_Off)
			echo -e $(On_IGreen)"                                 "$(Color_Off)

clean:
			docker-compose -f docker-compose.yml down -v --rmi all
			docker volume prune -f
			docker network prune -f
			echo -e $(On_IGreen)"                                 "$(Color_Off)
			echo -e $(On_IGreen)$(BYellow)"    project fully cleaned!      "$(Color_Off)
			echo -e $(On_IGreen)"                                 "$(Color_Off)

fclean:		clean
			mkdir -p ~/save
			cp -r ~/data/* ~/save
			sudo rm -rf ~/data/*

reboot:		down all

re:			clean all

.PHONY:		all down clean fclean reboot re

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
