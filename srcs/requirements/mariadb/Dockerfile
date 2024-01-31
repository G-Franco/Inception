FROM debian:bullseye

# Update and upgrade
# -y to auto accept prompts, otherwise it will wait for user input
RUN apt-get update && apt-get upgrade -y && \
	echo "Update and upgrade done" && \
# Installation
# Client is installed to have access to mysql command line
	 apt-get install -y mariadb-server mariadb-client && \
	 rm -rf /var/lib/apt/lists/*

# Copy configuration and add execution rights
COPY ./conf/mdb_conf.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mdb_conf.sh

EXPOSE 3306

# Run configuration script
ENTRYPOINT ["/usr/local/bin/mdb_conf.sh"]