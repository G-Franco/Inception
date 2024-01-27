#!/bin/sh

# Check for existing installation
if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# Check for existing database
if [ ! -d "/var/lib/mysql/mysql" ]; then
	
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm > /dev/null
	# Temporary file stores SQL commands for bootstrap installation of MariaDB
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	# https://stackoverflow.com/questions/10299148/mysql-error-1045-28000-access-denied-for-user-billlocalhost-using-passw
 	# Write SQL commands to temporary file
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM	mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MDB_ROOT_PASSWORD';

CREATE DATABASE $MDB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$MDB_USER'@'%' IDENTIFIED by '$MDB_USER_PASSWORD';
GRANT ALL PRIVILEGES ON $MDB_NAME.* TO '$MDB_USER'@'%';

FLUSH PRIVILEGES;
EOF
	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	rm -f $tfile
fi

# Allow remote connections to the database
# sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

# Finally, it starts the MariaDB server in console mode, using the 'mysql' user.
exec /usr/bin/mysqld --user=mysql --console