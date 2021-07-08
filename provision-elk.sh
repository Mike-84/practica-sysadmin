#!/bin/bash


CREA_DISCO_DATOS="si"
DESTINO_MOUNT="/var/lib/elasticsearch"



# INICIO SCRIPT
# Chequo de que el script corre como root

if [[ $EUID -ne 0 ]]; then
   echo "Ejecuta este script como root (o con sudo)" 
   exit 1
fi


# creacion y montaje disco datos
# referencia: https://www.tecmint.com/manage-and-create-lvm-parition-using-vgcreate-lvcreate-and-lvextend/
if [ "${CREA_DISCO_DATOS}" == "si" ]; then
  # discos, creacion de pv, vg y lv para manejar disco de datos
  pvcreate /dev/sdc
  vgcreate VG_datos /dev/sdc
  lvcreate -n lv_datos -L 4.9G VG_datos
  mkfs.ext4 /dev/VG_datos/lv_datos
  
  mkdir -p ${DESTINO_MOUNT}

  groupadd elasticsearch
  useradd -M -d /nonexistent -s /bin/false -g elasticsearch elasticsearch
  mkdir -p ${DESTINO_MOUNT}
  mount  /dev/VG_datos/lv_datos ${DESTINO_MOUNT}
  chown -R elasticsearch:elasticsearch ${DESTINO_MOUNT}
  chmod -R 755 ${DESTINO_MOUNT}

  echo "/dev/VG_datos/lv_datos    ${DESTINO_MOUNT}    ext4    defaults        0       2" >> /etc/fstab
fi



#
# Instalacion Elasticsearch y Kibana
#
echo "# Instalando Elasticsearch y Kibana... "
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list

apt-get update && apt-get install elasticsearch kibana net-tools

echo "# Instalación completada"
echo

#
# Firewall
#
echo "# Configurando reglas del firewall... "
ufw allow 'OpenSSH'
ufw allow 9200
ufw allow 5601
ufw allow 5044
ufw -f enable
ufw status
echo "# Firewall configurado"
echo

#
# Configuracion aplicaciones
#
echo "# Configurando Elasticsearch y Kibana... "
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl enable kibana.service

cp -p /etc/kibana/kibana.yml /etc/kibana/kibana.yml.orig
cp -p /etc/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml.orig

cp /vagrant/resources/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
cp /vagrant/resources/kibana.yml /etc/kibana/kibana.yml
# NOTA: falta poner permisos y propietario a los ficheros finales
echo "# configuración finalizada"
echo


#
# Instalacion logstash
#
echo "# Instalando logstash.... "
apt-get install logstash
cp /vagrant/resources/filebeat-processing.conf /etc/logstash/conf.d/filebeat-processing.conf
echo "# Instalacion completada"
echo 



#
# Arranque de servicios
#
echo "# Arrancando servicios..."
systemctl start elasticsearch.service kibana.service logstash.service
echo
echo "# Mostrando estado de servicios para finalizar"
systemctl status elasticsearch.service kibana.service
exit 0
