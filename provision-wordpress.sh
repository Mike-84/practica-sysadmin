#!/bin/bash
# Descripcion del script:
# Script de provision de VM creada por vagrant para instalar y configurar LEMP y filebeat
# Este script ha de ejecutarse como usuario root
#

#
# Configuracion del script
#
#
CREA_DISCO_DATOS="si"
DESTINO_MOUNT="/var/lib/mysql"
# FILEBEAT_OUTPUT: acepta valores elasticsearch o logstash. Define que tipo de salida a configurar
FILEBEAT_OUTPUT="logstash"



# INICIO SCRIPT

# Chequo de que el script corre como root

if [[ $EUID -ne 0 ]]; then
   echo "Ejecuta este script como root (o con sudo)" 
   exit 1
fi

# creacion y montaje disco datos
if [ "${CREA_DISCO_DATOS}" == "si" ]; then
  # discos, creacion de pv, vg y lv para manejar disco de datos
  pvcreate /dev/sdc
  vgcreate VG_datos /dev/sdc
  lvcreate -n lv_datos -L 1.9G VG_datos
  
  # formateamos el volumen logico - elegimos xfs en lugar de ext4 porque mysql no arrancara si hay un directorio "lost+found" en /var/lib/mysql
  mkfs.xfs /dev/VG_datos/lv_datos
  
  # creacion usuario y grupo para el servicio
  groupadd mysql
  useradd -M -d /nonexistent -s /bin/false -g mysql mysql
  
  # creacion directorio y montamos sistema de ficheros
  mkdir -p ${DESTINO_MOUNT}
  mount  /dev/VG_datos/lv_datos ${DESTINO_MOUNT}
  
  # permisos
  chown -R mysql:mysql ${DESTINO_MOUNT}
  chmod -R 755 ${DESTINO_MOUNT}
  
  # añadimos linea en fstab para montaje automatico tras reinicio
  echo "/dev/VG_datos/lv_datos    ${DESTINO_MOUNT}    xfs    defaults        0       2" >> /etc/fstab
fi



#
# Instalacion LEMP
#
echo "# Instalando LEMP... "
apt-get update
apt-get install -y nginx=1.18.0-0ubuntu1.2 mysql-server php7.4 php7.4-fpm php7.4-mysql php7.4-curl php7.4-gd php7.4-intl php7.4-mbstring php7.4-soap php7.4-xml php7.4-xmlrpc php-zip net-tools
echo "# Instalación completada"
echo



#
# Firewall
#
echo "# Configurando firewall... "
ufw allow 'Nginx HTTP'
ufw allow 'OpenSSH'
ufw allow 3306
ufw -f enable
ufw status
echo "# Firewall configurado"
echo


#
# Habilitar sitios
#
echo "# Habilitando carpeta wordpress... "
mysql -u root < /vagrant/resources/wordpress_sql_statements.sql
cp /vagrant/resources/wordpress-site.txt /etc/nginx/sites-available/wordpress
ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
unlink /etc/nginx/sites-enabled/default
nginx -t


#
# Instalacion y configuracion de wordpress
#
echo "# Instalando y configurando wordpress... "
cd /tmp
curl -s -LO https://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
cp -a /tmp/wordpress/. /var/www/wordpress

cp -p /var/www/wordpress/wp-config.php /var/www/wordpress/wp-config.php.orig
cp /vagrant/resources/wp-config.php /var/www/wordpress/wp-config.php

chown -R www-data:www-data /var/www/wordpress

systemctl restart nginx php7.4-fpm

echo "# Instalación y configuración de wordpress completada"
echo


#
# Instalación de filebeat
#
echo "# Instalando filebeat... "
curl -s -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.13.2-amd64.deb
dpkg -i filebeat-7.13.2-amd64.deb

systemctl stop filebeat 

#filebeat habilitar modulos
filebeat modules enable system nginx mysql

# Configuramos filebeat con salida a elasticsearch (para setup)
cp -p /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.orig
cp /vagrant/resources/filebeat-elasticsearch-output.yml /etc/filebeat/filebeat.yml

#https://stackoverflow.com/questions/11904772/how-to-create-a-loop-in-bash-that-is-waiting-for-a-webserver-to-respond/50583452



# chequeamos durante unos 4 minutos si elasticsearch esta disponible
attempt_counter=0
max_attempts=50
echo "# Verificando endpoint de elasticsearch previo a setup - máximo $max_attempts intentos"
until $(curl --output /dev/null --silent --head --fail http://192.168.11.11:9200); do
    if [ ${attempt_counter} -eq ${max_attempts} ];then
      echo "Max attempts reached"
      break
    fi

    printf '.'
    attempt_counter=$(($attempt_counter+1))
    sleep 5
done

if [ "${attempt_counter}" -eq "${max_attempts}" ]; then
  echo "Elasticsearch no disponible, NO hacemos setup de los modulos, pipelines y dashboards"
  echo "Si la salida final de filebeat no es elasticsearch sino logstash puede ser que haya que ejecutar el setup para que todo funcione"
else
  echo "Elasticsearch detectado. Lanzando setup de filebeat"
  filebeat setup -e # pendiente comprobar que haga el setup completo
fi

if [ "$FILEBEAT_OUTPUT" == "logstash" ]; then
 cp /vagrant/resources/filebeat-logstash-output.yml /etc/filebeat/filebeat.yml
 echo "# Logstash output configurado"
fi

systemctl enable filebeat 
systemctl restart filebeat 

echo "# Instalación filebeat completada"
echo

exit 0


#filebeat setup -e --dashboards