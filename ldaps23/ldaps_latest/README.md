# Imatge personalitzada de Debian per utilizar LDAP de forma segura

Aquesta imatge de Docker està basada en un Debian i conté el procés de com instal·lar el servei LDAP, de forma segura.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

```Dockerfile
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
```
## Startup.sh

L'arxiu "Startup.sh" s'executarà mitjançant el "Dockerfile" sense necesitat de fer totes les comandes des d'adins del container. On farem els següents passos a seguir:

1) Mostra un missatge indicant que s'està inicialitzant la base de dades LDAP per al domini "edt.org".
2) Elimina tots els fitxers i directoris dins de /etc/ldap/slapd.d/.
3) Elimina tots els fitxers i directoris dins de /var/lib/ldap/.
4) Realitza una prova de sintaxi sobre el fitxer de configuració slapd.conf i genera la configuració dinàmica a /etc/ldap/slapd.d/.
5) Afegeix dades a la base de dades LDAP utilitzant el fitxer LDIF (edt-org.ldif) i la configuració a /etc/ldap/slapd.d/.
6) Mostra el contingut actual de la base de dades LDAP.

7) Crea el directori /etc/ldap/certs.
8) Copia els fitxers de certificats i claus al directori /etc/ldap/certs/.

9) Elimina l'arxiu de configuració ldap.conf existent.
10) Copia un nou arxiu de configuració LDAP des de /opt/docker/ a /etc/ldap/ldap.conf.
11) Canvia el propietari i grup dels directoris /etc/ldap/slapd.d/ i /var/lib/ldap/ a openldap.
12) Inicia el servidor OpenLDAP en mode de depuració (-d0) i escolta en els protocols ldap://, ldaps://, i ldapi:///.

```bash
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
```

## slapd.conf

L'arxiu "slapd.conf" està definida per el següent contingut amb els includes necessaris i la configuracions del TLS:

```bash
#
# See slapd.conf(5) for details on configuration options.
# This file should NOT be world readable.
#
# debian packages: slapd ldap-utils

include		/etc/ldap/schema/core.schema
include		/etc/ldap/schema/cosine.schema
include		/etc/ldap/schema/inetorgperson.schema
include		/etc/ldap/schema/misc.schema
include		/etc/ldap/schema/nis.schema
include		/etc/ldap/schema/openldap.schema

# Allow LDAPv2 client connections.  This is NOT the default.
allow bind_v2

pidfile		/var/run/slapd/slapd.pid

TLSCACertificateFile        /etc/ldap/certs/cacert.pem
TLSCertificateFile          /etc/ldap/certs/servercert.pem
TLSCertificateKeyFile       /etc/ldap/certs/server.key.pem
TLSVerifyClient       	    never

#TLSCipherSuite        HIGH:MEDIUM:LOW:+SSLv2
#argsfile	/var/run/openldap/slapd.args

#modulepath /usr/lib/ldap
moduleload back_mdb.la
moduleload back_monitor.la

# ----------------------------------------------------------------------
database mdb
suffix "dc=edt,dc=org"
rootdn "cn=Manager,dc=edt,dc=org"
#rootpw secret
rootpw {SSHA}oAtPEpCsAdk6SLqmqv+6fkqm2EHELq32
directory /var/lib/ldap
index objectClass eq,pres
access to * by self write by * read
# ----------------------------------------------------------------------
database config
rootdn "cn=Sysadmin,cn=config"
rootpw {SSHA}vwpQxtzc7yLsGg8K7fm02p2Fhox/PFP4
# el passwd es syskey
# ----------------------------------------------------------------------
database monitor
access to *
       by dn.exact="cn=Manager,dc=edt,dc=org" read
       by * none
```

## ldap.conf

L'arxiu "ldap.conf" configura la connexió i el comportament de LDAP, establint paràmetres com la base de cerca (BASE), la ubicació del servidor (URI) i opcions com límits de mida i temps, a més de configuracions per a certificats TLS. En aquest cas específic, defineix la base de cerca com a dc=edt,dc=org i el servidor LDAP URI ldap://ldap.edt.org. A més, especifica la ruta del certificat TLS a TLS_CACERT.

```bash
#
# LDAP Defaults
#

# See ldap.conf(5) for details
# This file should be world readable but not world writable.

#BASE	dc=example,dc=com
#URI	ldap://ldap.example.com ldap://ldap-provider.example.com:666

#SIZELIMIT	12
#TIMELIMIT	15
#DEREF		never

# TLS certificates (needed for GnuTLS)
TLS_CACERT	/etc/ldap/certs/cacert.pem

BASE dc=edt,dc=org
URI  ldap://ldap.edt.org
```

## edt-org.ldif

Aquest arxiu "edt.org.ldif" descriu la configuració de l'estructura d'un directori LDAP, incloent unitats organitzatives (OU), comptes d'usuaris (uid), grups (cn) i les seves relacions. Defineix diferents OU per a maquines, clients, productes, usuaris, grups, etc., i especifica detalls com els noms, números d'identificació, directoris personals i contrasenyes encriptades dels usuaris. També estableix relacions de pertinença dels usuaris als grups corresponents.

```ldif
dn: dc=edt,dc=org
dc: edt
description: Escola del treball de Barcelona
objectClass: dcObject
objectClass: organization
o: edt.org

dn: ou=maquines,dc=edt,dc=org
ou: maquines
description: Container per a maquines linux
objectclass: organizationalunit

dn: ou=clients,dc=edt,dc=org
ou: clients
description: Container per a clients linux
objectclass: organizationalunit

dn: ou=productes,dc=edt,dc=org
ou: productes
description: Container per a productes linux
objectclass: organizationalunit

dn: ou=usuaris,dc=edt,dc=org
ou: usuaris
description: Container per usuaris del sistema linux
objectclass: organizationalunit

dn: ou=grups,dc=edt,dc=org
ou: grups
description: Container per a grups
objectclass: organizationalunit

dn: ou=Asix,dc=edt,dc=org
ou: Asix
description: Container per els asix del sistema linux
objectclass: organizationalunit

dn: ou=AntiAsix,dc=edt,dc=org
ou: Asix
description: Container per els antiasix del sistema linux
objectclass: organizationalunit

dn: uid=pau,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Pau Pou
cn: Pauet Pou
sn: Pou
homephone: 555-222-2220
mail: pau@edt.org
description: Watch out for this guy
ou: professors
uid: pau
uidNumber: 5000
gidNumber: 601
homeDirectory: /tmp/home/pau
userPassword: {SSHA}NDkipesNQqTFDgGJfyraLz/csZAIlk2/

dn: uid=pere,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Pere Pou
sn: Pou
homephone: 555-222-2221
mail: pere@edt.org
description: Watch out for this guy
ou: professors
uid: pere
uidNumber: 5001
gidNumber: 601
homeDirectory: /tmp/home/pere
userPassword: {SSHA}ghmtRL11YtXoUhIP7z6f7nb8RCNadFe+

dn: uid=anna,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Anna Pou
cn: Anita Pou
sn: Pou
homephone: 555-222-2222
mail: anna@edt.org
description: Watch out for this girl
ou: alumnes
uid: anna
uidNumber: 5002
gidNumber: 600
homeDirectory: /tmp/home/anna
userPassword: {SSHA}Bm4B3Bu/fuH6Bby9lgxfFAwLYrK0RbOq

dn: uid=marta,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Marta Mas
sn: Mas
homephone: 555-222-2223
mail: marta@edt.org
description: Watch out for this girl
ou: alumnes
uid: marta
uidNumber: 5003
gidNumber: 600
homeDirectory: /tmp/home/marta
userPassword: {SSHA}9+1F2f5vcW8z/tmSzYNWdlz5GbDCyoOw

dn: uid=jordi,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Jordi Mas
cn: Giorgios Mas
sn: Mas
homephone: 555-222-2224
mail: jordi@edt.org
description: Watch out for this guy
ou: alumnes
ou: Profes
uid: jordi
uidNumber: 5004
gidNumber: 600
homeDirectory: /tmp/home/jordi
userPassword: {SSHA}T5jrMgpJwZZgu0azkLIVoYhiG08/KGUv

dn: uid=admin,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Administrador Sistema
cn: System Admin
sn: System
homephone: 555-222-2225
mail: anna@edt.org
description: Watch out for this admin
ou: system
ou: admin
uid: admin
uidNumber: 10
gidNumber: 27
homeDirectory: /tmp/home/admin
userPassword: {SSHA}4mS0FycWc5bkpW8/a396SGNDTQUlFSX3

dn: uid=Pol Sanjurjo,ou=Asix,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Polete
cn: Pop
sn: Sanjurjo
homephone: 555-222-2225
mail: polsanjurjo@edt.org
description: Aquest noi es ros
ou: Asix
ou: AntiAsix
uid: admin
uidNumber: 10
gidNumber: 601
homeDirectory: /tmp/home/sanjurjo
userPassword: {SSHA}cDDURbhITwNmvgIIBms12BVnCTs8ydgN

dn: uid=Eustaqui Eus,ou=AntiAsix,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Eustaqui Eus
cn: Eustaqui Eus Us
sn: Eustaqui Eus
homephone: 555-222-2224
mail: esutaqui@edt.org
description: Watch out for this guy
ou: AntiAsix
ou: Asix
uid: Eustaqui Eus
uidNumber: 5004
gidNumber: 27
homeDirectory: /tmp/home/eustaqui
userPassword: {SSHA}s+k4NK6fSwI3JtJ4pZUE3fcoZTZ2hUnR

# --------------------UserXX-----------------------------

dn: uid=user01,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user01
sn: usuari01
description: Primer usuari de 1asix
ou: 1asix
uid: user01
uidNumber: 2001
gidNumber: 610
homeDirectory: /home/user01
userPassword: {SSHA}tWkj/NWcStWT0u+u4HYvf23eaRhYtPYR

dn: uid=user02,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user02
sn: usuari02
description: Segon usuari de 1asix
ou: 1asix
uid: user02
uidNumber: 2002
gidNumber: 610
homeDirectory: /home/user02
userPassword: {SSHA}OVz4p9rsOCmuzUH49uUx/PTQHidAX2NX

dn: uid=user03,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user03
sn: usuari03
description: Tercer usuari de 1asix
ou: 1asix
uid: user02
uidNumber: 2003
gidNumber: 610
homeDirectory: /home/user03
userPassword: {SSHA}AtGV6D5P/YQ07XN2c+Bcex84dSFn8odd

dn: uid=user04,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user04
sn: usuari04
description: Primer usuari de 1hiaw
ou: 1hiaw
uid: user04
uidNumber: 3001
gidNumber: 614
homeDirectory: /home/user04
userPassword: {SSHA}QWsbNGIAVR8b36H4Lj36wm2FXpejmjFk

dn: uid=user05,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user05
sn: usuari05
description: Segon usuari de 1hiaw
ou: 1hiaw
uid: user05
uidNumber: 3002
gidNumber: 614
homeDirectory: /home/user05
userPassword: {SSHA}kzW0zp/+2Cbc+8tJYl26+iGSuY58TNa/

dn: uid=user06,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user06
sn: usuari06
homephone: 555-222-0006
mail: user06@edt.org
description: Tercer usuari de 1hiaw
ou: 1hiaw
uid: user06
uidNumber: 3003
gidNumber: 614
homeDirectory: /home/user06
userPassword: {SSHA}jzwpD9kkG0c0gYjGgSRpzFUoxzXx9Tla

dn: uid=user07,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user07
sn: usuari07
description: Primer usuari de 2asix
ou: 2asix
uid: user07
uidNumber: 4001
gidNumber: 611
homeDirectory: /home/user07
userPassword: {SSHA}49vxSqSzW1vcXuPB0Ty5VQhi3MBeyla5

dn: uid=user08,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user08
sn: usuari08
description: Segon usuari de 2asix
ou: 2asix
uid: user08
uidNumber: 4002
gidNumber: 611
homeDirectory: /home/user08
userPassword: {SSHA}pUUjnlChFQlqGlp2qMNtpuj5VxgbcKs9

dn: uid=user09,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user09
sn: usuari09
description: Tercer usuari de 2asix
ou: 2asix
uid: user09
uidNumber: 4003
gidNumber: 611
homeDirectory: /home/user09
userPassword: {SSHA}qTY2/PIw9DsCtNnDZK/u4rQjHTGSaBsI

dn: uid=user10,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: user10
sn: usuari10
description: Quart usuari de 2asix
ou: 2asix
uid: user10
uidNumber: 4004
gidNumber: 611
homeDirectory: /home/user10
userPassword: {SSHA}HSkB11eOgrMaky1iAmCZiFDDLkTdmSLU

# -----------------GRUPS------------------------------

dn: cn=professors,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: professors
gidNumber: 601
description: Grup dels professors
memberUid: pau
memberUid: pere

dn: cn=alumnes,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: alumnes
gidNumber: 600
description: Grup dels alumnes
memberUid: anna
memberUid: marta
memberUid: jordi

dn: cn=1asix,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: 1asix
gidNumber: 610
description: Grup dels usuaris de 1asix
memberUid: user01
memberUid: user02
memberUid: user03

dn: cn=2asix,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: 2asix
gidNumber: 611
description: El grup dels usuaris de 2asix
memberUid: user07
memberUid: user08
memberUid: user09
memberUid: user10

dn: cn=sudo,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: sudo
gidNumber: 27
description: Grup dels privilegiats
memberUid: admin
memberUid: Eustaqui Eus

dn: cn=1wiam,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: 1wiam
gidNumber: 612
description: Grup dels usuaris de 1wiam

dn: cn=2wiam,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: 2wiam
gidNumber: 613
description: Grup dels usuaris de 2wiam

dn: cn=1hiaw,ou=grups,dc=edt,dc=org
objectclass: posixGroup
cn: 1hiaw
gidNumber: 614
description: Grup dels usuaris de 1hiaw
memberUid: user04
memberUid: user05
memberUid: user06
```

## Desenvolupament

#-----------------------------------------------------------
#-----------------------------------------------------------

01_practica_ldaps

Implementar un servidor amb servei LDAP segur ldaps.

Primer: Crear
    ● Crear una entitat certificadora Veritat Absoluta.
    ● Generar un certificat de servidor a nom de ldap.edt.org.
    ● Configurar el servidor ldap per actuar com a servidor ldaps.
    ● Configurar un client PAM per fer consultes contra el servidor LDAP (configurar el certificat de CA)

Segon: Verificar
    ● Verificar la connexió ldap amb el servidor LDAP.
    ● Verificar la connexió ldaps amb el servdor LDAP.
    ● Verificar el funcionament de l’opció de ldapsearch -z.
    ● Verificar el funcionament de l’opció de ldapsearch -Z.

Tercer: Alternate Names
    ● Generar de nou el certificat del servidor ampliant-lo amb una llista de noms alternatius del servidor:
        ○ Localhost, 127.0.0.1, <ip-container>, myldap.edt.org.
    ● Vetrificar la connexió des d’un host client PAM i des de dins del propi servidor per a cada cas.

#-----------------------------------------------------------
#-----------------------------------------------------------

Abans d'engegar la imatge farem les claus corresponents:

Veritat Absoluta
```bash
openssl genrsa -out cakey.pem
```
```bash
openssl req -new -x509  -key cakey.pem -out cacert.pem
Country Name (2 letter code) [AU]:es
State or Province Name (full name) [Some-State]:ca
Locality Name (eg, city) []:bcn
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Informatica
Organizational Unit Name (eg, section) []:inf
Common Name (e.g. server FQDN or YOUR name) []:Veritat Absoluta
Email Address []:inf@gmail.com
```

ldap.edt.org
```bash
openssl genrsa -out server.key.pem
```
```bash
openssl req -new -x509  -key cakey.pem -out servercert.pem

Country Name (2 letter code) [AU]:es
State or Province Name (full name) [Some-State]:ca
Locality Name (eg, city) []:bcn
Organization Name (eg, company) [Internet Widgits Pty Ltd]:ServerInformatica
Organizational Unit Name (eg, section) []:inf
Common Name (e.g. server FQDN or YOUR name) []:ldap.edt.org
Email Address []:server@gmail.com
```

Per crear la imatge, farem la següent ordre:
```bash
docker build -t bryan501/ldaptls:latest .
```
Generem la imatge:
```bash
 docker run --rm --name ldap.edt.org -h ldap.edt.org --net 2hisx -p 389:389 -it bryan501/ldaptls:latest
```

Comprovacions:

Exemples de connexió client en text plà i en tls/ssl
```bash
ldapsearch -x  -H ldap://ldap.edt.org 
ldapsearch -x  -H ldaps://ldap.edt.org 
```
Exemples usant startls:
```bash
ldapsearch -x -Z -H ldap://ldap.edt.org 
ldapsearch -x -ZZ -H ldap://ldap.edt.org
```



