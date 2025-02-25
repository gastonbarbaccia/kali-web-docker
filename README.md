docker build -t kali-web-vnc .

docker run -d -p 6080:6080 --name kali-vnc kali-web-vnc

http://localhost:6080/vnc.html

Credenciales de acceso:
User: kali
Password: kali