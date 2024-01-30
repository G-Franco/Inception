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

re: fclean all

PHONY: all up down start stop clean fclean re