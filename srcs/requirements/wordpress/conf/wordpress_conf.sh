echo "[Wordpress startup] Waiting for MariaDB..."
# Wait for MariaDB to be accessible
# -h - host
# -u - user
# -p - password
# dev/null - redirect output to /dev/null to silence output
while ! mariadb -h${MDB_HOST} -u${MDB_USER} -p${MDB_ADMIN_PASSWORD} ${MDB_NAME} &>/dev/null;
do
    sleep 3
done
echo "[Wordpress startup] MariaDB ok."

# Check if WordPress config file exists
if [ -f ${WP_PATH}/wp-config.php ]
then
	echo "[Wordpress startup] WordPress config file already present."
else
	echo "[Wordpress startup] Setting up WordPress"
	echo "[Wordpress startup] Updating WP-CLI tool"
	wp-cli.phar cli update --yes --allow-root
	echo "[Wordpress startup] Downloading WordPress"
	wp-cli.phar core download --allow-root
	echo "[Wordpress startup] Creating wp-config.php"
	wp-cli.phar config create --dbname=${MDB_NAME} --dbuser=${MDB_USER} --dbpass=${WP_USER_PASSWORD} --dbhost=${MDB_HOST} --path=${WP_PATH} --allow-root
	echo "[Wordpress startup] Installing WordPress core"
	wp-cli.phar core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH} --allow-root
	echo "[Wordpress startup] Creating WordPress default user"
	wp-cli.phar user create ${MDB_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --display_name=${MDB_USER} --porcelain --path=${WP_PATH} --allow-root
	echo "[Wordpress startup] Installing WordPress theme"
	wp-cli.phar theme install bravada --path=${WP_PATH} --activate --allow-root
	wp-cli.phar theme status bravada --allow-root
fi

echo "[Wordpress startup] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm81 -F -R