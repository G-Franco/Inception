FROM debian:bullseye

# Update and upgrade
RUN apt-get update && apt-get upgrade -y && \
# Install wordpress dependencies
	apt-get install -y \
	php php-curl php-fpm php-bcmath php-gd php-soap php-zip php-mbstring \
    php-mysqlnd php-gd php-xml php-intl php-zip && \
# PHP-fpm must listen to port 9000
# sed edits the file in place (-i) and replaces the string with 9000
# The old configuration (listen = 127.0.0.1:9000) would only listen in localhost
	sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf && \
#Install wordpress cli
	apt-get install -y wget && \
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/bin/wp-cli.phar

# Copy wordpress conf file
COPY	./conf/wordpress_conf.sh /tmp/wordpress_conf.sh
RUN		chmod +x /tmp/wordpress_conf.sh

WORKDIR /var/www/html/wordpress

#Configuration must run when container starts
ENTRYPOINT ["/tmp/wordpress_conf.sh"]