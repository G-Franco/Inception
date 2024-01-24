#!/bin/bash
sleep 5
# Check if WordPress config file exists
if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "[Wordpress startup 0] WordPress config file already present."
else
	echo "[Wordpress startup 1] Setting up WordPress"
	echo "[Wordpress startup 2] Updating WP-CLI tool"
	wp cli update --yes --allow-root
	echo "[Wordpress startup 3] Downloading WordPress"
	wp core download --allow-root
	echo "[Wordpress startup 4] Creating wp-config.php"
	wp config create --dbname=${MDB_NAME} --dbuser=${MDB_USER} --dbpass=${MDB_USER_PASSWORD} --dbhost=${MDB_HOST} --path=${WP_PATH} --allow-root
	echo "[Wordpress startup 5] Installing WordPress core"
	wp core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root
	echo "[Wordpress startup 6] Creating WordPress default user"
	wp user create ${MDB_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --display_name=${MDB_USER} --porcelain --path=${WP_PATH} --allow-root
	echo "[Wordpress startup 7] Installing WordPress theme"
	wp theme install bravada --path=${WP_PATH} --activate --allow-root
	wp theme status bravada --allow-root
	echo "[Wordpress startup 8] Setting WP_HOME and WP_SITEURL"
    wp option update home "https://${DOMAIN_NAME}" --path=${WP_PATH} --allow-root
    wp option update siteurl "https://${DOMAIN_NAME}" --path=${WP_PATH} --allow-root
fi

#Create the directory for the PHP-FPM socket
mkdir -p /run/php/

echo "[Wordpress startup] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm7.4 -F -R