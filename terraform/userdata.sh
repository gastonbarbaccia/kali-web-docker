#!/bin/bash
set -e

# Actualizar paquetes y sistema
sudo apt-get update && sudo apt-get upgrade -y

# Instalar Docker
sudo apt-get install -y docker.io

# Iniciar y habilitar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Clonar el repositorio (cambiar URL si es necesario)
cd /home/ubuntu
sudo git clone https://github.com/gastonbarbaccia/kali-web-docker.git
cd kali-web-docker

# Ejecutar contenedor Kali VNC
sudo docker run -d -p 6080:6080 --privileged --name kali-vnc accetto/kali-web-vnc
