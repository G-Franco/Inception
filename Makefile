LOGIN		= gacorrei
DOMAIN		= ${LOGIN}.42.fr
DATA_PATH	= /home/${LOGIN}/data
ENV			= LOGIN=${LOGIN} DATA_PATH=${DATA_PATH} DOMAIN=${DOMAIN}

all: up

up: setup
# -f: Specify a compose file
# -d: Detached mode: Run containers in the background
# --build: Build images before starting containers.
	${ENV} docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	${ENV} docker-compose -f ./srcs/docker-compose.yml down

start:
	${ENV} docker-compose -f ./srcs/docker-compose.yml start

stop:
	${ENV} docker-compose -f ./srcs/docker-compose.yml stop

status:
# ps: List containers
	cd ./srcs && docker-compose ps && cd ..

logs:
	cd ./srcs && docker-compose logs && cd ..

setup:
	${ENV} ./conf_login.sh
	${ENV} ./conf_hosts.sh
	sudo mkdir -p /home/${LOGIN}
	sudo mkdir -p ${DATA_PATH}
	sudo mkdir -p ${DATA_PATH}/mariadb_data
	sudo mkdir -p ${DATA_PATH}/wordpress_data

clean:
	sudo rm -rf ${DATA_PATH}

fclean: clean
	${ENV} ./anonymize.sh
# -a: Remove all unused images not just dangling ones
# -f: Do not prompt for confirmation
# --volumes: Remove all unused local volumes
	docker system prune -a -f --volumes
# Remove volumes
	docker volume rm srcs_mariadb_data srcs_wordpress_data

PHONY: all up down start stop status logs setup clean fclean