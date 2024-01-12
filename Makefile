all: up

up:
	sudo mkdir -p /home/gacorrei/data/mariadb_data
	sudo mkdir -p /home/gacorrei/data/wordpress_data
# -f: Specify a compose file
# -d: Detached mode: Run containers in the background
# --build: Build images before starting containers.
	docker-compose -f ./srcs/compose.yaml up -d --build

down:
	docker-compose -f ./srcs/compose.yaml down

start:
	docker-compose -f ./srcs/compose.yaml start

stop:
	docker-compose -f ./srcs/compose.yaml stop

clean:
	docker-compose -f srcs/compose.yaml down
# -q: Only display numeric IDs
# -a: Show all containers (default shows just running)
# 2>/dev/null: Redirect errors to /dev/null
	docker stop $(docker ps -qa) 2>/dev/null
	docker rm $(docker ps -qa) 2>/dev/null
# rmi: Remove one or more images
# -f: Force removal of the image
	docker rmi -f $(docker images -qa) 2>/dev/null
	docker volume rm $(docker volume ls -q) 2>/dev/null
	docker network rm $(docker network ls -q) 2>/dev/null
# prune: Remove unused data
# -a: Remove all unused images not just dangling ones
	docker system prune -a --volume 2>/dev/null
# --force: Do not prompt for confirmation
	docker system prune -a --force 2>/dev/null
	sudo rm -rf /home/gacorrei/data

PHONY: all up down start stop clean