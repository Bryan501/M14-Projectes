#! /bin/bash

echo "Inicialitzant la BD ldap edt.org"

rm -rf /etc/ldap/slapd.d/*
rm -rf /var/lib/ldap/*
slaptest -f /opt/docker/slapd.conf -F /etc/ldap/slapd.d
slapadd  -F /etc/ldap/slapd.d -l /opt/docker/edt-org.ldif
slapcat

mkdir /etc/ldap/certs
cp /opt/docker/cacert.pem /etc/ldap/certs/.
cp /opt/docker/servercert.pem /etc/ldap/certs/.
cp /opt/docker/server.key.pem  /etc/ldap/certs/.

rm /etc/ldap/ldap.conf
cp /opt/docker/ldap.conf  /etc/ldap/ldap.conf

chown -R openldap.openldap /etc/ldap/slapd.d /var/lib/ldap
/usr/sbin/slapd -d0  -h "ldap:/// ldaps:/// ldapi:///" 

