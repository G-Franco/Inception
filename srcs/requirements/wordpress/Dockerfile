FROM debian:bullseye

# Update and upgrade
RUN apt-get update && apt-get upgrade -y && \
# Install wordpress dependencies
	apt-get install -y \
	php8.3 php8.3-fpm php8.3-mysql php8.3-curl php8.3-gd php8.3-intl php-pear \
	php-imagick php8.3-imap php8.3-memcache php8.3-pspell php8.3-recode \
	php8.3-sqlite3 php8.3-tidy php8.3-xmlrpc php8.3-xsl php8.3-mbstring \
	php-gettext php8.3-zip php8.3-common php8.3-opcache php-apcu php8.3-json \
	php8.3-iconv php8.3-xml php8.3-bcmath php8.3-soap php8.3-ldap php8.3-xml \
	php8.3-cli php8.3-cgi php8.3-dev php8.3-imagick php8.3-mysql php8.3-pgsql \
	php8.3-sqlite3 php8.3-gmp php8.3-geoip php8.3-redis php8.3-memcached \
	php8.3-igbinary php8.3-ldap php8.3-xmlrpc php8.3-xdebug php8.3-mongodb \
	php8.3-ssh2 php8.3-yaml php8.3-redis php8.3-memcached php8.3-igbinary \
	php8.3-ldap php8.3-xmlrpc php8.3-xdebug php8.3-mongodb php8.3-ssh2 \
	php8.3-yaml php8.3-redis php8.3-memcached php8.3-igbinary php8.3-ldap \
	php8.3-xmlrpc && \
# PHP-fpm must listen to port 9000
# sed edits the file in place (-i) and replaces the string with 9000
# The old configuration (listen = 127.0.0.1:9000) would only listen in localhost
	 sed -i 's/listen = 127.0.0.1:9000/listen = 9000/g' /etc/php/8.3/fpm/pool.d/www.conf && \
#Install wordpress cli
	 apt-get install -y wget && \
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/bin/wp-cli.phar

# Copy wordpress conf file
COPY	./conf/wordpress_conf.conf /tmp/wordpress_conf.conf
RUN		chmod +x /tmp/wordpress_conf.conf

WORKDIR /var/www/html/wordpress

#Configuration must run when container starts
ENTRYPOINT ["/tmp/wordpress_conf.conf"]