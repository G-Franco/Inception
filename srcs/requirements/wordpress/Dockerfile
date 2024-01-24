FROM debian:bullseye

# Update and upgrade
RUN apt-get update && apt-get upgrade -y && \
# Install wordpress dependencies
	apt-get install -y \
	php7.4 php7.4-curl php7.4-fpm php7.4-bcmath php7.4-gd php7.4-soap php7.4-zip php7.4-mbstring \
    php7.4-mysqlnd php7.4-gd php7.4-xml php7.4-intl php7.4-zip php-cli && \
# PHP-fpm must listen to port 9000
# sed edits the file in place (-i) and replaces the string with 9000
# The old configuration (listen = 127.0.0.1:9000) would only listen in localhost
	sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf && \
#Install wordpress cli
	apt-get install -y wget && \
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/bin/wp && \
	# Clean up after installation, removes package lists from apt-get
	rm -rf /var/lib/apt/lists/*

# Copy wordpress conf file
COPY	./conf/wordpress_conf.sh /tmp/wordpress_conf.sh
RUN		chmod +x /tmp/wordpress_conf.sh

WORKDIR /var/www/html/wordpress

EXPOSE 9000

#Configuration must run when container starts
ENTRYPOINT ["/tmp/wordpress_conf.sh"]
# ENTRYPOINT ["sh", "-c", "sleep 2073600"]