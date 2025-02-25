# Imagen base de Kali Linux
FROM kalilinux/kali-rolling

# Instalar entorno de escritorio Kali (Xfce) y herramientas gráficas
RUN apt update && apt upgrade -y && apt install -y \
    kali-desktop-xfce \
    xfce4-terminal \
    tigervnc-standalone-server \
    tigervnc-tools \
    novnc \
    websockify \
    xterm \
    dbus-x11 \
    curl \
    nano \
    sudo \
    kali-tools-top10 \
    && rm -rf /var/lib/apt/lists/*


RUN apt install kali-tools-top10 -y

# Crear usuario VNC con permisos de sudo
RUN useradd -m -s /bin/bash kali && \
    echo "kali:kali" | chpasswd && \
    usermod -aG sudo kali

RUN chmod -R 777 /usr/share/novnc

# Crear directorios necesarios y establecer permisos
USER kali
RUN mkdir -p /home/kali/.vnc /home/kali/.config/tigervnc /home/kali/.Xauthority && \
    touch /home/kali/.Xauthority && \
    echo "kali" | vncpasswd -f > /home/kali/.vnc/passwd && \
    chmod 600 /home/kali/.vnc/passwd

# Configurar el archivo xstartup para iniciar el escritorio de Kali (Xfce)
RUN echo "#!/bin/bash" > /home/kali/.vnc/xstartup && \
    echo "export DISPLAY=:1" >> /home/kali/.vnc/xstartup && \
    echo "export XAUTHORITY=/home/kali/.Xauthority" >> /home/kali/.vnc/xstartup && \
    echo "unset SESSION_MANAGER" >> /home/kali/.vnc/xstartup && \
    echo "unset DBUS_SESSION_BUS_ADDRESS" >> /home/kali/.vnc/xstartup && \
    echo "exec dbus-launch --exit-with-session startxfce4" >> /home/kali/.vnc/xstartup && \
    chmod +x /home/kali/.vnc/xstartup

# Exponer puertos VNC y NoVNC
EXPOSE 5901 6080

# Comando de inicio para VNC y NoVNC
CMD ["bash", "-c", "\
    vncserver :1 -localhost no -geometry 1920x1080 -depth 24 -rfbauth /home/kali/.vnc/passwd && \
    export DISPLAY=:1 && \
    while true; do xrandr --output $(xrandr | grep ' connected' | awk '{print $1}') --auto; sleep 5; done & \
    echo '<meta http-equiv=\"refresh\" content=\"0; url=vnc.html?resize=remote\">' > /usr/share/novnc/index.html && \
    websockify --web=/usr/share/novnc/ 6080 localhost:5901 && \
    tail -F /home/kali/.vnc/*.log"]

