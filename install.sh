 #!/bin/bash
sudo apt-get update -y && apt-get upgrade -y
sudo apt-get install docker.io git -y

# Habilitar y arrancar Docker
sudo systemctl enable docker
sudo systemctl start docker

# Posicionarse dentro del proyecto
cd /home/ubuntu
git clone https://github.com/gastonbarbaccia/kali-web-docker.git
cd /home/ubuntu/kali-web-docker

# Construir y ejecutar el contenedor
sudo docker build -t kali-web-vnc .
sudo docker run -d -p 6080:6080 --privileged --name kali-vnc kali-web-vnc
