# LDAP SERVER 2023

# Creació d'un Debian personalitzat:

FROM debian:latest
LABEL version="1.0"
LABEL author="@edt ASIX-M06"
LABEL subject="ldap.edt.org 2023"

# Actualitzem el container e instal·lem les eines necessaries:

RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y procps iproute2 vim tree nmap ldap-utils slapd less

#Creem, copiem, fem executable, executem primer el que volem i que port volem que el container escolti:

RUN mkdir /opt/docker
COPY * /opt/docker/
RUN chmod +x /opt/docker/startup.sh
WORKDIR /opt/docker
CMD /opt/docker/startup.sh
EXPOSE 389



