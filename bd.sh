#!/bin/bash

################################################################################
# script: deploy_mysql.sh
# descripción: despliegue automatizado de contenedor mysql para entorno de prácticas.
# configuración: nombre "practicas-mysql", password "practicas", db "practicas"
################################################################################

set -e

# definición de variables según requerimientos
container_name="practicas-mysql"
mysql_root_password="practicas"
mysql_database="practicas"

echo "[info] verificando entorno y desplegando contenedor..."

# 1. creación del volumen de persistencia
# garantiza que los datos no se pierdan si el contenedor se detiene o elimina.
docker volume create mysql_data_practicas > /dev/null

# 2. ejecución de la instancia mysql 8.0
docker run -d \
  --name "$container_name" \
  -p 3306:3306 \
  -v mysql_data_practicas:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD="$mysql_root_password" \
  -e MYSQL_DATABASE="$mysql_database" \
  --restart unless-stopped \
  mysql:8.0

echo "----------------------------------------------------------"
echo "despliegue finalizado con éxito."
echo "nombre del contenedor: $container_name"
echo "base de datos inicial: $mysql_database"
echo "puerto local: 3306"
echo "----------------------------------------------------------"
