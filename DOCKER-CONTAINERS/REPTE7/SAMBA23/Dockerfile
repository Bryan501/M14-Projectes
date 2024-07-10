# SAMBA Server 2023

# Utilització d'un imatge Debian com a base:
FROM debian:latest
LABEL author="Bryan501 M05"
LABEL subject="SAMBA Server"

# Actualiza els repositoris i instal·la els paquets necessaris o per defecte:
RUN apt-get update
RUN apt-get -y install procps iproute2 nmap tree vim samba 

# Creem una carpeta on posarem els arxius que tenim al directori actiu, fem executable el .sh i especifiquem la carpeta on volem treballar en el container;
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker

# Inicialitzem mitjançant el script
CMD /opt/docker/startup.sh
EXPOSE 139 445

