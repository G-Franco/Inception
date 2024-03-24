## What is it?
A dockerized LEMP stack (Linux, Nginx, Mariadb, Wordpress with PHP).
- All services have their own container
- There are two volumes, one for the database, one for the website
- One docker network for internal communication
- Everything is built with one docker compose file

## How to use this?
1 - Clone this repository

2 - Run make

3 - Access the website at https://gacorrei.42.fr

## Clear space
To clear the space used by this project, run make fclean
