echo "[MariaDB] Configuring MariaDB..."

# Check if directory does not exist
if [! -d "/run/mysqld"]; then
	echo "[MariaDB] Creating mysqlrun directory and adding permissions."
	mkdir -p /run/mysqld
	# chown -> change ownwer
	# -R -> recursive
	# When -R is used, all subdirectories and files are changed as well.
	# mysql:mysql -> user:group to give ownership to
	chown -R mysql:mysql /run/mysqld
fi

if [-d "/var/lib/mysql/mysql"]
then
	echo "[MariaDB] MariaDB already configured."
else
	echo "[MariaDB] Installing MySQL Data Directory."
	chown -R mysql:mysql /var/lib/mysql
	# mysql_install_db -> initialize MySQL data directory and create system tables
	# --basedir -> base directory for the MySQL installation
	# --datadir -> path to the MySQL data directory
	# --user -> user name of the system user to use for running mysqld
	# --rpm -> run mysql_install_db without writing to error log
	# > /dev/null -> redirect output to /dev/null to suppress it
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	echo "[MariaDB] MySQL Data Directory done."

	# Before mariadb is operational, it needs to be configured in bootstrap mode
	# Bootstrap mode is used only for initial tasks and only uses basic SQL commands
	# Bootstrap mode is used to create the mysql database and the initial user accounts
	# But it can only read commands from a file, not from stdin
	echo "[MariaDB] Configuring MySQL."
	TMP=/tmp/init

	# Use the database called mysql
	echo "USE mysql;" > ${TMP}
	# Reload grant tables (database, table, and column privilege information)
	# FLUSH PRIVILEGES -> manually reload grant tables to ensure that any changes are applied
	echo "FLUSH PRIVILEGES;" >> ${TMP}
	# Remove nameless users
	echo "DELETE FROM mysql.user WHERE User='';" >> ${TMP}
	# Remove database named test
	echo "DROP DATABASE IF EXISTS test;" >> ${TMP}
	# Remove references to test database
	echo "DELETE FROM mysql.db WHERE Db='test';" >> ${TMP}
	# Remove root accounts that are not localhost
	echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> ${TMP}
	# Change root password to provided one
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MDB_ROOT_PASSWORD}';" >> ${TMP}
	# Create database with specified name
	echo "CREATE DATABASE ${MDB_NAME};" >> ${TMP}
	# Create user with specified name and password
	echo "CREATE USER '${WP_USER_EMAIL}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';" >> ${TMP}
	# Grant all privileges on database to user
	echo "GRANT ALL PRIVILEGES ON ${MDB_NAME}.* TO '${WP_USER_EMAIL}'@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';" >> ${TMP}
	# Runs at end to ensure that all changes to user priveleges are applied
	echo "FLUSH PRIVILEGES;" >> ${TMP}

	# Run the commands in the file and then delete it
	/usr/bin/mysqld --user=mysql --bootstrap < ${TMP}
	rm -f ${TMP}
	echo "[MariaDB] MySQL configuration done."
fi

echo "[MariaDB] Allowing remote connections to MariaDB"
# -i -> edit files in place
# s -> substitute
# | -> delimiter
# g -> global
# comments out skip-networking
# If skip-networking is enabled, the server only accepts localhost connections,
# not tcp/ip connections
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
# bind-address -> IP address to bind to
# 0.0.0.0 -> listens to all interfaces
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

echo "[MariaDB] Starting MariaDB daemon on default port 3306."

# Switch process to mysql, set user and output logs to console
exec /usr/bin/mysqld --user=mysql --console