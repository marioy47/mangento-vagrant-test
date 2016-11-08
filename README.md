# Creación de un E-Commerce con Magento para videos tutoriales


## Instrucciones

### 1. Descargar Magento
Descargar de [aquí](https://magento.com/tech-resources/downloads/magento/)

Preferible descargar la versión que viene con datos de ejemplo y obligatorio que sea la que está compresa con **gzip**

> Esta versión puede pesar más de 200 megas !!!

* Datos de ejemplo ayudan mucho en el video
* La version .gzip descomprime más rápido cosa que es importante en este paquete que tiene tantos archivos

### 2. Clonar el repositorio

	cd /ruta/a/dir/trabajo
	git clone git@bitbucket.org:marioyepes/dazzet-video-intro-magento.git

### 3. Mover el archivo descargado
Mover el archivo descargado desde magento.com a `installers`

	cd dazzet-video-intro-magento
	mv /ruta/a/descargas/Magento-CE-2.1.2_sample_data-2016-10-11-11-27-51.tar.gz   installers/

### 4. Editar archivo de aprovisionamiento
Es necesario decirle al script de aprovisionamiento de magento cual es el archivo que se va a descomprimir

	vim ops/provision-mangento.sh

Buscar la línea

	# Archivo descargado de Magento
	MAGEFILE=

Y agregar el nombre del archivo descargado

	# Archivo descargado de Magento
	MAGEFILE=Magento-CE-2.1.2_sample_data-2016-10-11-11-27-51.tar.gz

### 4. Inciar la máquina virtual
Este paso puede tomar de 5 a 10 minutos dependiendo del tamaño del archivo descargado y de la velocidad del disco duro

	vagrant up
