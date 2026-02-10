#!/bin/bash

# ==============================================================================
# script: deploy_docker.sh
# descripción: instalación profesional de docker engine y docker compose en ubuntu.
# compatibilidad: ubuntu 22.04 / 24.04 lts y derivados.
# ==============================================================================

set -e  # finalizar ejecución si algún comando falla

# definición de colores para salida por consola
red='\033[0;31m'
green='\033[0;32m'
nc='\033[0m' # sin color

echo -e "${green}[info]${nc} iniciando despliegue de docker..."

# 1. saneamiento y actualización del sistema operativo
echo -e "${green}[1/5]${nc} actualizando índices de paquetes y dependencias base..."
sudo apt-get update -q
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 2. gestión de seguridad y autenticidad (gpg)
echo -e "${green}[2/5]${nc} configurando el llavero de seguridad para el repositorio..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes

# 3. registro del repositorio oficial de docker inc.
echo -e "${green}[3/5]${nc} registrando el repositorio oficial en el gestor de paquetes..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. instalación del stack tecnológico (docker-ce y plugins)
echo -e "${green}[4/5]${nc} procediendo con la instalación de docker engine..."
sudo apt-get update -q
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 5. configuración de persistencia y privilegios
echo -e "${green}[5/5]${nc} configurando el grupo de usuarios y el inicio del servicio..."
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo usermod -aG docker ${USER}

echo -e "\n${green}[éxito]${nc} despliegue finalizado correctamente."
echo -e "${green}[nota]${nc} para activar el grupo 'docker' sin reiniciar la máquina, ejecute: newgrp docker"