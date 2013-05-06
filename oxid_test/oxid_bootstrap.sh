#!/usr/bin/env bash

#$osrootpwd = root
#$mysqlrootpwd = mysql

echo "Checking out oxid demo shop."
/usr/bin/svn --force --quiet export http://svn.oxid-esales.com/trunk/eshop/ /var/www/www.oxiddemo.de/

echo "Creating database user."
sudo mysql -e 'GRANT ALL PRIVILEGES ON `oxid_demo`.* TO `oxid_demo_u`@"localhost" IDENTIFIED BY "secure";'

echo "Installing oxid database."
sudo mysql -D oxid_demo < /var/www/www.oxiddemo.de/setup/sql/database.sql

echo "Installing oxid demo data."
sudo mysql -D oxid_demo < /var/www/www.oxiddemo.de/setup/sql/demodata.sql

echo "Doing some oxid config settings."
sudo sed 's/<dbHost\_ce>/localhost/g' -i /var/www/www.oxiddemo.de/config.inc.php
sudo sed 's/<dbName\_ce>/oxid\_demo/g' -i /var/www/www.oxiddemo.de/config.inc.php
sudo sed 's/<dbUser\_ce>/oxid\_demo\_u/g' -i /var/www/www.oxiddemo.de/config.inc.php
sudo sed 's/<dbPwd\_ce>/secure/g' -i /var/www/www.oxiddemo.de/config.inc.php
sudo sed 's/<sShopURL\_ce>/http\:\/\/\www\.oxiddemo\.de:8080\//g' -i /var/www/www.oxiddemo.de/config.inc.php
sudo sed 's/<sShopDir\_ce>/\/var\/www\/www\.oxiddemo\.de/g' -i /var/www/www.oxiddemo.de/config.inc.php
sudo sed 's/<sCompileDir\_ce>/\/var\/www\/www\.oxiddemo\.de\/tmp/g' -i /var/www/www.oxiddemo.de/config.inc.php

sudo chown -R www-data:www-data /var/www/www.oxiddemo.de/

echo "Setting root password."
# read osrootpwd
sudo echo "root:root" | /usr/sbin/chpasswd

echo "Setting mysql root password."
# read mysqlrootpwd
sudo mysqladmin --user=root password mysql

echo "Installation of demo oxid demo data and vagrant development box done. Enjoy!"
