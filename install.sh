 #!/bin/bash
sudo apt update -y && apt upgrade -y
sudo apt install -y docker.io git

# Habilitar y arrancar Docker
sudo systemctl enable docker
sudo systemctl start docker

# Posicionarse dentro del proyecto
cd /home/ubuntu/kali-web-docker

# Construir y ejecutar el contenedor
sudo docker build -t kali-web-vnc .
sudo docker run -d -p 6080:6080 --privileged --name kali-vnc kali-web-vnc
