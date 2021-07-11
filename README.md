#Instrucciones de uso

Para arrancar estas 2 maquinas virtuales utilizan 6GB de memoria RAM: 5GB(elk) y 1GB(wordpress)

Una vez clonado el repositorio lo unico que se tiene que hacer es vagrant up donde esté el archivo vagrantfile, en ese momento tardara unos minutos ya que se instalarán 2 máquinas virtuales en la primera se instalará LEMP (Nginx, MySQL y PHP) con wordpress y filebeat y en la segunda se instalará ELK (Elasticsearch, logstastash y kibana) y se configurarán automáticamente, una vez terminada la instalación solo tendrá que poner localhost:8080 y configurar wordpress indicando el idioma que quiere el nombre del sitio, con usuario y contraseña y ya tendrás wordpress funcionando.

Con wordpress funcionando, se podrá ir a localhost:8081 y esto accederá a kibana el cual entrando en discover se podrá comprobar que los logs llegan.



# Notas:

- Si decides desactivar o no activar los scripts de provisión en el vagrantfile, se puede ejecutar dentro de la máquina con el comando "sudo /vagrant/provision-wordpress.sh" o "sudo /vagrant/provision-elk.sh".

- Con la ayuda de los scripts de provisión se montaran los discos, instalarán las aplicaciones y se habilitará el firewall sólo con los puertos necesarios para que funcione la práctica, después se habilitarán los sitios, configurarán las aplicaciones y finalmente se arrancarán los servicios.

- Los scripts de provisión se tienen que ejecutar como root.

- Las urls para acceder a las aplicaciones desde el host principal (hipervisor) son:
	- http://localhost:9200/ <-> elasticsearch
	- http://localhost:8080/ <-> wordpress
	- http://localhost:8081/ <-> kibana acceso directo
	- http://localhost:8082/ <-> kibana via nginx con autenticacion (htpasswd) (usuario: admin / contraseña: admin)
	

- En MySQL se crea una base de datos (llamado wordpress), un usario (wordpressuser) y con una contraseña (Mik84), pero se pueden cambiar en la carpeta de resources y en el archivo wordpress_sql_statements.sql.

- La configuración de logstash esta realizado en un único archivo .conf (filebeat-processing.conf) y el apartado de filtros esat sin uso ya que el parseado lo realizan los pipelines de los módulos de filebeat instalados en Elasticsearch.

- En el script de provisión de wordpress (provision-wordpress.sh) se puede elegir el output de filebeat (FILEBEAT_OUTPUT) entre elasticsearch y logstash, también se elegir si quieres que te cree el 2º disco y montarlo como repositorio para los datos.

- Al igual que en el script de provisión de wordpress, en el script de provisión de elk (provision-elk.sh) se puede elegir si quieres que te cree el 2º disco para datos.

- Las configuraciones que estan en la carpeta de resources son fijas para que funcione de golpe pero se pueden modificar. (?)(?)(?)

# Problemas conocidos o encontrados

- En ocasiones ha ocurrido que la máquina virtual se queda completamente colgada (parece que por algún problema de integración entre mi PC y Virtualbox). En estos casos abriendo la VM directamente desde la consola de Virtualbox y pulsando cualquier tecla (ENTER por ejemplo) se soluciona el problema y el proceso continúa. No he conseguido solucionarlo del todo, aunque desinstalando Hyper-V parece que ya no ocurre, por lo que podía ser eso. Ejemplo de lo que aparece en la consola:

```
soft lockup - CPU#1 stuck for 22s! [mysqld:7117]
```


#Referencias

Instalación de LEMP y wordpress
- https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu-20-04
- https://www.digitalocean.com/community/tutorials/como-instalar-wordpress-con-lemp-en-ubuntu-18-04-es

Instalación de ELK y filebeat
- https://www.elastic.co/guide/en/elastic-stack/current/installing-elastic-stack.html

Uso del LVM:
- https://www.tecmint.com/manage-and-create-lvm-parition-using-vgcreate-lvcreate-and-lvextend/

Ejemplo del bucle que use en provision-wordpress.sh que uso para verificar que elasticsearch esta instalado correctamente:
- https://stackoverflow.com/questions/11904772/how-to-create-a-loop-in-bash-that-is-waiting-for-a-webserver-to-respond/50583452

