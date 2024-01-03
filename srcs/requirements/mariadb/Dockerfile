FROM debian:bullseye

# Update and upgrade
# -y to auto accept prompts, otherwise it will wait for user input
RUN apt-get update && apt-get upgrade -y
RUN	echo "Update and upgrade done"

# Installation
# No nned to specify server, it's included in mariadb
# Client is installed to have access to mysql command line
RUN apt-get install -y mariadb mariadb-client

# Copy configuration and add execution rights
COPY ./srcs/requirements/mariadb/conf/mdb_conf.sh /temp/mdb_conf.sh
RUN chmod +x /temp/mdb_conf.sh

EXPOSE 3306

# Run configuration script
ENTRYPOINT ["sh", "/temp/mdb_conf.sh"]