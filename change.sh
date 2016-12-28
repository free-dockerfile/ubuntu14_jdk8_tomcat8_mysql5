#!/bin/bash

SSH_BASE_PWD=$1
SSH_ADMIN_PWD=$2
DB_APP_PWD=$3
DB_ADMIN_PWD=$4

echo 'sshuser:'$SSH_BASE_PWD | chpasswd

echo 'root:'$SSH_ADMIN_PWD | chpasswd
sleep 1s

echo "CREATE DATABASE appdb CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -uroot -p''$DEV_PWD
sleep 1s
echo "CREATE USER 'dbappuser'@'%' IDENTIFIED BY '"$DB_APP_PWD"';" | mysql -uroot -p''$DEV_PWD
sleep 1s
echo "GRANT ALL PRIVILEGES ON appdb.* TO 'dbappuser'@'%' WITH GRANT OPTION;" | mysql -uroot -p''$DEV_PWD
sleep 1s
mysql -udbappuser -p''$DB_APP_PWD appdb < /usr/local/src/lib/tomcat/default/webapps/ROOT/WEB-INF/*.sql
sleep 1s
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('"$DB_ADMIN_PWD"');" | mysql -uroot -p''$DEV_PWD
sleep 1s
sed -i 's/export DEV_PWD='$DEV_PWD'//g' /etc/profile.d/server_profile.sh
rm /sbin/change.sh
