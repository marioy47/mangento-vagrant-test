#|/bin/bash

# Instalación y configuración de linux

# Variables
DBRPASS=root
DOMAIN="mitienda.com"
FSUSER=www-data        # Usuario dueño de los archivos

# Ejecuta un comando como el usuario www-data que es el usuario dueño del servicio nginx
function runAs() {
    sudo -H -u ${FSUSER} bash -c "$*"
}

# Especificamos usuario y contraseña por defecto para mysql/mariadb
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${DBRPASS}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${DBRPASS}"
sudo debconf-set-selections <<< "mariadb-server mariadb-server/root_password password ${DBRPASS}"
sudo debconf-set-selections <<< "mariadb-server mariadb-server/root_password_again password ${DBRPASS}"
sudo debconf-set-selections <<< "postfix postfix/mailname string ${DOMAIN}"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"

# Add MariaDB repo
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.edatel.net.co/mariadb/repo/10.1/ubuntu trusty main' # MariaDB
sudo add-apt-repository ppa:ondrej/php # PHP 7

#  Instalación de paquetes
sudo apt-get update > /dev/null
sudo apt-get -y install nginx nginx-extras mariadb-server \
	php7.0-fpm php7.0-mysql php7.0-cli php7.0-gd php7.0-json php7.0-iconv \
    php7.0-curl php7.0-intl php7.0-mbstring php7.0-mcrypt php7.0-xml \
	php7.0-soap php7.0-zip \
	git postfix unzip curl

# Copiar archivos de configuración de nginx, php, etc
echo Copy configuration
sudo cp /tmp/ops/nginx-magento.conf /etc/nginx/sites-available/magento
ln -sfn /etc/nginx/sites-available/magento /etc/nginx/sites-enabled/magento
# sudo cp /tmp/ops/90-wordpress.ini /etc/php5/fpm/conf.d/90-wordpress.ini
sudo rm -rf /var/www/html
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart
sudo service php7.0-fpm restart


# vim: ts=4 sw=4 noet
