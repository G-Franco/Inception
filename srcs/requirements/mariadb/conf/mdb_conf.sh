#/bin/sh

# Initilize MySQL data directory and create system tables
mysql_install_db
# Start MySQL server
# /etc/init.d/mysql start
mysqld_safe &

if [ -d "/var/lib/mysql/$MDB_NAME" ]
then 

	echo "Database has already been created"
else
# Run mysql_secure_installation with an here_doc to automate
# Steps:
# Create and confirm a new password
# Remove anonymous users
# DON'T disallow root login remotely
# Remove test database and access to it
# Reload privilege tables
mysql_secure_installation << _EOF_

n
Y
$MDB_ROOT_PASSWORD
$MDB_ROOT_PASSWORD
Y
n
Y
Y
_EOF_

echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MDB_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot
echo "CREATE DATABASE IF NOT EXISTS $MDB_NAME; GRANT ALL ON $MDB_NAME.* TO '$MDB_USER'@'%' IDENTIFIED BY '$MDB_USER_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root

fi

/etc/init.d/mysql stop

exec "$@"