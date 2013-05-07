#!/usr/bin/env bash

CONFIG_PATH=/var/www/www.oxiddemo.de/config.inc.php


. /tmp/oxid_config/oxid_demo.cfg

echo "Checking out oxid demo shop."
/usr/bin/svn --force --quiet export http://svn.oxid-esales.com/trunk/eshop/ /var/www/www.oxiddemo.de/

echo "Creating database user."
echo "GRANT ALL PRIVILEGES ON `oxid_demo`.* TO `$OXID_DB_USER`@'localhost' IDENTIFIED BY $OXID_DB_USER_PW;" | mysql

#sudo mysql -e "GRANT ALL PRIVILEGES ON `oxid_demo`.* TO `$OXID_DB_USER`@localhost IDENTIFIED BY '$OXID_DB_USER_PW';"

#OXID_DB_NAME=oxid_demo
#QUERY="sudo /usr/bin/mysql -e \"GRANT ALL PRIVILEGES ON $OXID_DB_NAME.* TO $OXID_DB_USER@localhost IDENTIFIED BY '$OXID_DB_USER_PW';\""

#echo $QUERY

echo "Installing oxid database."
sudo mysql -D oxid_demo < /var/www/www.oxiddemo.de/setup/sql/database.sql

echo "Installing oxid demo data."
sudo mysql -D oxid_demo < /var/www/www.oxiddemo.de/setup/sql/demodata.sql

echo "Doing some oxid config settings."
sudo sed "s/<dbHost\_ce>/localhost/g" -i $CONFIG_PATH 
sudo sed "s/<dbName\_ce>/oxid\_demo/g" -i $CONFIG_PATH 
sudo sed "s/<dbUser\_ce>/$OXID_DB_USER/g" -i $CONFIG_PATH 
sudo sed "s/<dbPwd\_ce>/$OXID_DB_USER_PW/g" -i $CONFIG_PATH 
sudo sed "s/<sShopURL\_ce>/http\:\/\/\www\.oxiddemo\.de:8080\//g" -i $CONFIG_PATH 
sudo sed "s/<sShopDir\_ce>/\/var\/www\/www\.oxiddemo\.de/g" -i $CONFIG_PATH 
sudo sed "s/<sCompileDir\_ce>/\/var\/www\/www\.oxiddemo\.de\/tmp/g" -i $CONFIG_PATH 

sudo chown -R www-data:www-data /var/www/www.oxiddemo.de/

echo "Setting root password."
sudo echo 'root:'$ROOTPW | /usr/sbin/chpasswd

echo "Setting mysql root password."
# read mysqlrootpwd
sudo mysqladmin --user=root password $MYSQL_ROOTPW 

echo "Installation of demo oxid demo data and vagrant development box done. Enjoy!"
