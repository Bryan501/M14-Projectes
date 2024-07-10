# REPTE2 APACHE EN DETACH

# Utilització d'un imatge Debian com a base:
FROM debian:latest
LABEL subject="Repte 2"
LABEL author="@edt ASIX M14"

# Actualiza els repositoris i instal·la els paquets necessaris o per defecte:
RUN apt-get update 
RUN apt-get install -y procps iproute2 iputils-ping nmap apache2 tree vim

# Creem una carpeta on posarem els arxius que tenim al directori actiu, fem executable el .sh i especifiquem la carpeta on volem treballar en el container:
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker/

# Utilitzarem el CMD per inicialitzar el container amb startup.sh:
CMD /opt/docker/startup.sh
EXPOSE 80
