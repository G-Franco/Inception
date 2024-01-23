echo "[Wordpress startup] Waiting for MariaDB..."
# Wait for MariaDB to be accessible
# -h - host
# -u - user
# -p - password
# dev/null - redirect output to /dev/null to silence output
#while ! mysql -h${MDB_HOST} -u${MDB_USER} -p${MDB_ADMIN_PASSWORD} ${MDB_NAME} &>/dev/null;
#do
#    sleep 3
#done
#echo "[Wordpress startup] MariaDB ok."
# export WP_TITLE="Inception_Eval"
# export WP_ADMIN_USER="big_boss"
# export WP_ADMIN_EMAIL="cant_excel@gmail.com"
# export WP_ADMIN_PASSWORD="Unhackable2"
# export WP_USER_EMAIL="generic_tester@gmail.com"
# export WP_USER_PASSWORD="1234"
# export WP_PATH="/var/www/html/wordpress"

# # MariaDB
# export MDB_NAME="wordpress_db"
# # 3306 is the default port, added to be explicit
# export MDB_HOST="mariadb:3306"
# export MDB_ROOT_PASSWORD="UnguessableRootPassword"
# export MDB_USER="generic_tester"
# export MDB_USER_PASSWORD="super_STRONG_p455w0rd"

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
fi

echo "[Wordpress startup] Starting WordPress fastCGI on port 9000."
exec /usr/sbin/php-fpm7.4 -F