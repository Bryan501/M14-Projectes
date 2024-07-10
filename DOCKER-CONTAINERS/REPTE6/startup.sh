#!/bin/bash

# Abans de tot farem "sed" fer substituir tant l'administrador, com la contrasenya del slapd.conf, mitjançant les dues variables d'entorn

sed -i "s/Manager/$LDAP_ADMIN_USERNAME/g" slapd.conf
sed -i "s/secret/$LDAP_ADMIN_PASSWORD/g" slapd.conf

# Esborrar els directoris de configuració i de dades

rm -rf /var/lib/ldap/*
rm -rf /etc/ldap/slapd.d/*

# Fa una prova on especefica el fitxer de configuració a una carpeta on és generaran els fitxers
# després de les proves.

slaptest -f /opt/docker/slapd.conf -F /etc/ldap/slapd.d

# Afegeix el contingut a la base de dades indicant la carpeta on es troben els fitxers de configuració generats i indica l'arxiu LDIF que conté les dades a afegir a la base de dades

slapadd -F /etc/ldap/slapd.d -l /opt/docker/edt-org.ldif

# Canvia el propietari

chown -R openldap:openldap /etc/ldap/slapd.d /var/lib/ldap

# Executa el servidor LDAP, habilitant la sortida en debug amb nivell 0

/usr/sbin/slapd -d0


