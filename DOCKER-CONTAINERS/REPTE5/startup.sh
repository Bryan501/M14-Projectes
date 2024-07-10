#!/bin/bash

arg2=$2
case "$1" in
  "slapd")
    echo "Engegant el servidor LDAP..."
    rm -rf /etc/ldap/slapd.d/*
    rm -rf /var/lib/ldap/*
    slaptest -f /opt/docker/slapd.conf -F /etc/ldap/slapd.d
    chown -R openldap:openldap /etc/ldap/slapd.d /var/lib/ldap
    /usr/sbin/slapd -d0
    ;;
  "initdb")
    echo "Creant el servidor LDAP amb les dades de l'escola..."
    rm -rf /etc/ldap/slapd.d/*
    rm -rf /var/lib/ldap/*
    slaptest -f /opt/docker/slapd.conf -F /etc/ldap/slapd.d
    slapadd  -F /etc/ldap/slapd.d -l /opt/docker/edt-org.ldif
    chown -R openldap:openldap /etc/ldap/slapd.d /var/lib/ldap
    /usr/sbin/slapd -d0
    ;;
  "start"|"edtorg"|"")
    echo "Inicialitzant el servei LDAP amb les dades per defecte..."
    echo "Creant el servidor LDAP amb les dades de l'escola..."
    rm -rf /etc/ldap/slapd.d/*
    rm -rf /var/lib/ldap/*
    slaptest -f /opt/docker/slapd.conf -F /etc/ldap/slapd.d
    slapadd  -F /etc/ldap/slapd.d -l /opt/docker/edt-org.ldif
    chown -R openldap:openldap /etc/ldap/slapd.d /var/lib/ldap
    /usr/sbin/slapd -d0
    ;;
  "slapcat")
    if [ $arg2 == "0" ] || [ $arg2 == "1" ]; then
  	slapcat -n$arg2
    elif [ -z "$arg2" ]; then
	  slapcat
    fi
    ;;

  *)
    echo "Us: $0"
    exit 1
    ;;
esac


