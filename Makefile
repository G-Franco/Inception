all: up

up:
# -f: Specify a compose file
# -d: Detached mode: Run containers in the background
# --build: Build images before starting containers.
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

start:
	docker compose -f ./srcs/docker-compose.yml start

stop:
	docker compose -f ./srcs/docker-compose.yml stop

clean:
# down: Stop and remove containers, networks, images
# --volumes: also removes volumes
# --rmi: Remove images.
	docker compose -f srcs/docker-compose.yml down --volumes --rmi all

fclean: clean
# prune: Remove unused data
# -a: Remove all unused images not just dangling ones
# --volumes: Prune volumes
# --force: Do not prompt for confirmation
	docker system prune -a --volumes --force
	docker network ls -q -f "driver=custom" | xargs -r docker network rm 2>/dev/null
	sudo rm -rf ~/data/mariadb/*
	sudo rm -rf ~/data/wordpress/*

re: fclean all

info:
	@echo "Containers:"
	docker ps -a
	@echo "-------------------------------------------------------------------"
	@echo "Images:"
	docker images -a
	@echo "-------------------------------------------------------------------"
	@echo "Volumes:"
	docker volume ls
	@echo "-------------------------------------------------------------------"
	@echo "Networks:"
	docker network ls

connect:
	docker exec -it mariadb mysql -u root -p

PHONY: all up down start stop clean fclean re info connect