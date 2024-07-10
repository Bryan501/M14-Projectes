#!/bin/bash

# Instalar Docker
    apk add docker
    addgroup vagrant docker
    rc-update add docker default
    service docker start

# Iniciar los servicios Docker

docker network create 2hisx 

docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -p 389:389 --privileged -d bryan501/ldap23:latestv2
docker run --rm --name phpldapadmin.edt.org -h phpldapadmin.edt.org --net 2hisx -p 80:80 --privileged -d bryan501/phpldapadmin23:v2
docker run --rm --name ssh.edt.org -h ssh.edt.org --net 2hisx --privileged -d bryan501/ssh23:latest
docker run --rm --name samba.edt.org -h samba.edt.org --net 2hisx --privileged -d bryan501/samba23:home_server
