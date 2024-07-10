# LDAP SERVER 2023

# Creació d'un Debian personalitzat:
FROM debian:latest
LABEL version="1.0"
LABEL author="@edt ASIX-M06"
LABEL subject="ldapserver 2023"

# Actualitzem el container e instal·lem les eines necessaries:
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y procps iproute2 vim tree nmap ldap-utils slapd less

# Creem una carpeta on posarem els arxius que tenim al directori actiu, fem executable el .sh i especifiquem la carpeta on volem treballar en el container:
RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker

# Utilitzarem el CMD per inicialitzar el container amb startup.sh:
CMD /opt/docker/startup.sh
EXPOSE 389

