# NET23 2023

# Utilització d'un imatge Debian com a base:
FROM debian:latest
LABEL version="1.0"
LABEL author="@edt ASIX-M14"
LABEL subject="ldapserver 2023"

# Actualiza els repositoris i instal·la els paquets necessaris o per defecte
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y systemctl procps iproute2 nmap tree vim apache2 net-tools xinetd vsftpd tftpd-hpa telnet tftp less

# Creem una carpeta on posarem els arxius que tenim al directori actiu, fem executable el .sh i especifiquem la carpeta on volem treballar en el container:
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker

# Camvien el CMD per ENTRYPOINT per poder posar arguments en comptes de comandes:
CMD /opt/docker/startup.sh
EXPOSE 7 13 19 21 69 80 
