#!/usr/bin/env bash

CONFIG_PATH=/var/www/www.oxiddemo.de/config.inc.php
SHOP_DL='/usr/bin/svn --force export http://svn.oxid-esales.com/trunk/eshop/ /var/www/www.oxiddemo.de/ > /tmp/countfile'

# read oxid_demo.cfg 
. /tmp/oxid_config/oxid_demo.cfg

echo "Checking out oxid demo shop."
eval $SHOP_DL &
while [ `ps aux | grep svn | grep -v grep | wc -l` == 1 ];do wc -l /tmp/countfile | dbar -max 3604;sleep 10;done
echo 100 |/usr/bin/dbar

#/usr/bin/svn --force --quiet export http://svn.oxid-esales.com/trunk/eshop/ /var/www/www.oxiddemo.de/

echo "Creating database."
sudo mysql << EOFMYSQL
CREATE DATABASE $OXID_DB /*!40100 DEFAULT CHARACTER SET utf8 */;
EOFMYSQL

echo "Creating database user."
sudo mysql << EOFMYSQL
GRANT ALL PRIVILEGES ON $OXID_DB.* TO $OXID_DB_USER@'localhost' IDENTIFIED BY '$OXID_DB_USER_PW';
EOFMYSQL

echo "Installing oxid database."
sudo mysql -D $OXID_DB < /var/www/www.oxiddemo.de/setup/sql/database.sql

echo "Installing oxid demo data."
sudo mysql -D $OXID_DB < /var/www/www.oxiddemo.de/setup/sql/demodata.sql

echo "Creating oxid admin user."
sudo mysql -D $OXID_DB  << EOFMYSQL
UPDATE oxuser SET oxusername = "$OXID_ADMIN_USER" WHERE oxid = 'oxdefaultadmin';
EOFMYSQL

echo "Setting Oxid Admin Password"
sudo mysql -D $OXID_DB  << EOFMYSQL
UPDATE oxuser SET oxpassword = md5(concat("$OXID_ADMIN_PW",unhex(oxpasssalt))) WHERE oxid = 'oxdefaultadmin';
EOFMYSQL

echo "Configuring Oxid Shop."
sudo sed "s/<dbHost\_ce>/localhost/g" -i $CONFIG_PATH 
sudo sed "s/<dbName\_ce>/$OXID_DB/g" -i $CONFIG_PATH 
sudo sed "s/<dbUser\_ce>/$OXID_DB_USER/g" -i $CONFIG_PATH 
sudo sed "s/<dbPwd\_ce>/$OXID_DB_USER_PW/g" -i $CONFIG_PATH 
sudo sed "s/<sShopURL\_ce>/http\:\/\/\www\.oxiddemo\.de:8080\//g" -i $CONFIG_PATH 
sudo sed "s/<sShopDir\_ce>/\/var\/www\/www\.oxiddemo\.de/g" -i $CONFIG_PATH 
sudo sed "s/<sCompileDir\_ce>/\/var\/www\/www\.oxiddemo\.de\/tmp/g" -i $CONFIG_PATH 
sudo chown -R www-data:www-data /var/www/www.oxiddemo.de/

echo "Setting root password."
sudo echo 'root:'$ROOTPW | /usr/sbin/chpasswd

echo "Setting mysql root password."
sudo mysqladmin --user=root password $MYSQL_ROOTPW 

echo "Cleaning up Oxid Installation."
sudo chmod 444 /var/www/www.oxiddemo.de/config.inc.php
sudo chmod 444 /var/www/www.oxiddemo.de/.htaccess
sudo rm -rf /var/www/www.oxiddemo.de/setup/*
sudo rm -rf /tmp/countfile

echo "Installation of demo oxid demo data and vagrant development box done. Enjoy!"
