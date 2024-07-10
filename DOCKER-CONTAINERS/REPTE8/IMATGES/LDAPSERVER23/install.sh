#!/bin/bash
# Install ldap server

rm -rf /etc/openldap/slapd.d/*
rm -rf /var/lib/ldap/*
cp /opt/docker/DB_CONFIG /var/lib/ldap/.
slaptest -f /opt/docker/slapd.conf -F /etc/openldap/slapd.d
slapadd -F /etc/openldap/slapd.d -l /opt/docker/edt.org.ldif
chown -R openldap:openldap /etc/openldap/slapd.d
chown -R openldap:openldap /var/lib/ldap
cp /opt/docker/ldap.conf /etc/openldap/.
