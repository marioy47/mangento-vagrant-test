#!/bin/bash

INDIR=/var/www/magento # Directorio donde reside Wordpress
DBHOST=localhost       # Servidor donde está la base de datos
DBNAME=magento         # Base de datos para Wordpress
DBUSER=magento         # Usuario de la base de datos de Wordpress
DBPASS=magento         # Contraseña de la base de datos
DBRPASS=root           # Contraseña de root para la base de datos (ver provision-vagrant.sh)
FSUSER=www-data        # Usuario dueño de los archivos
DOMAIN="mitienda.com"

# Archivo descargado de Magento
MAGEFILE=Magento-CE-2.1.2_sample_data-2016-10-11-11-27-51.tar.gz # Con datos de ejemplo
MAGEFILE=Magento-CE-2.1.2-2016-10-11-11-19-27.tar.gz # Sin datos de ejemplo

#  Ejecuta un comando como www-data
function runAs() {
    sudo -H -u ${FSUSER} bash -c "$*"
}

#  Crear la base de datos de Wordpress
mysql -u root -p${DBRPASS} -e "CREATE DATABASE ${DBNAME};"
mysql -u root -p${DBRPASS} -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO ${DBUSER}@'%' IDENTIFIED BY '${DBPASS}';"
mysql -u root -p${DBRPASS} -e "FLUSH PRIVILEGES;"

cd $INDIR

# Descomprimimos Magento
if [ ! -f $INDIR/index.php ]; then
    echo Extrayendo archivos de magento
    runAs tar xfz ../installers/$MAGEFILE
fi

echo  Ejecutando el instalador
runAs php bin/magento setup:install  \
    --admin-firstname=Admin \
    --admin-lastname=Admin \
    --admin-email="webmaster@${DOMAIN}" \
    --admin-user=admin \
    --admin-password='admin.1234' \
    --base-url="http://${DOMAIN}" \
    --backend-frontname=admin_mitienda   \
    --db-name=${DBNAME} \
    --db-user=${DBUSER} \
    --db-password=${DBPASS} \
    --language=es_CO \
    --currency=COP \
    --timezone='America/Bogota' \
    --cleanup-database \
    --use-rewrites=1

# Nos aseguramos que los directorio tengan los permisos correctos
sudo chmod -R ugo+w $INDIR/app/etc
sudo chmod -R ugo+w $INDIR/var
sudo chmod -R ugo+w $INDIR/pub/media
sudo chmod -R ugo+w $INDIR/pub/static

# Ajustamos el cron de magento si no está en el crontab
grep magento /etc/crontab >> /dev/null
if [ "$?" != "0" ]; then
    echo Agregando entrada de crontab
    STR="* * * * * ${FSUSER} cd ${INDIR} && php bin/magento cron:run"
    echo "'$STR'"
    sudo -H bash -c "echo '$STR' >> /etc/crontab"
fi

sudo service nginx restart

# vim: ts=4 sw=4 sts=4 sr et
