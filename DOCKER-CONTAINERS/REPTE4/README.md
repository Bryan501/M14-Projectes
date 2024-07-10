# Imatge personalitzada de Debian per utilitzar LDAP en mode detach amb persistència de dades

Aquesta imatge de Docker està basada en un Debian i conté el procés de com instal·lar el servei
LDAP i mitjançant això navegar per les dades, que hi posarem, fora del contenidor comprovant, també la persistència de dades.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

## Startup.sh

L'arxiu "Startup.sh" s'executarà mitjançant el "Dockerfile" sense necessitat de fer totes les comandes des de dins del container. On farem els següents passos a seguir:

Inicia el servei slapd amb el mode debug per mantenir-lo en funcionament en primer pla.

## edt-org.ldif

L'arxiu "edt-org.ldif" tindrà les entitats que volem, on s'utilitzarà mitjançant el "Startup.sh" 
per agafar les nostres entitats (les dades) i substituir-les per les de defecte.

## slapd.conf

L'arxiu "slapd.conf" tindrà la nostra configuració que volem al LDAP.


## Desenvolupament

Crearem dos volums per a la persistència de dades de la configuració i de les dades LDAP
```bash
docker volume create ldap-dades
docker volume create ldap-config
```
Per crear la imatge, farem la següent ordre:
```bash
docker build -t bryan501/ldap23:detach .
```
Generem la imatge en mode detach i ficarem el -p per connectar els ports del sistema remot amb el local. A més a més, dels volums per a la persistència de dades:
```bash
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -v ldap-config:/etc/openldap/slapd.d -v ldap-dades:/var/lib/ldap -d bryan501/ldap23:detach
```
Verifiquem si n'hi ha alguna base de dades o si podem buscar informació:
```bash
slapcat
ldapsearch -x -LLL -b 'dc=edt,dc=org'
```

## Comprovació de la persistència de dades

LDIF a afegir com exemple:
```ldif
dn: cn=Bryan Alvitres,ou=usuaris,dc=edt,dc=org
objectclass: posixAccount
objectclass: inetOrgPerson
cn: Bryan Alvitres
sn: Alvitres
homephone: 555-222-2228
mail: bryan@edt.org
description: Vigileu aquesta persona
ou: Alumnes
uid: bryan
uidNumber: 5007
gidNumber: 600
homeDirectory: /tmp/home/bryan
userPassword: {SSHA}abc1234dEfG5678hIjk90LmN1oPqR   
```

Si tenim la base de dades nostra només afegim en .ldif que volem posar:
```bash
docker cp /tmp/ldap/extra.ldif mi-ldap:/tmp/extra.ldif
docker exec mi-ldap ldapadd -x -D cn=Manager,dc=edt,dc=org -w secret -f /tmp/ldap/extra.ldif 
```
Si tenim la base de dades per defecte del LDAP, fem les següents comandes:
```bash
rm -rf /etc/ldap/slapd.d/* /var/lib/ldap/*
slaptest -f /opt/docker/slapd.conf -F /etc/ldap/slapd.d
slapadd  -F /etc/ldap/slapd.d -l /opt/docker/edt-org.ldif
chown -R openldap:openldap /etc/ldap/slapd.d /var/lib/ldap
```
Ara podem tant buscar per veure que estan afegits les dades del .ldif com esborrar-les.
```bash
docker exec mi-ldap ldapsearch -x -LLL -H ldap://172.17.0.2 -b "dc=edt,dc=org" "cn=Bryan Alvitres"
docker exec mi-ldap ldapdelete -x -D cn=Manager,dc=edt,dc=org -w secret "cn=Bryan Alvitres,ou=usuaris,dc=edt,dc=org"
```

Tot això per sortir del container, tornar-ho a engegar i veure si s'han afegit les dades o si s'han eliminat les dades, segons la comanda feta abans de sortir del container i torna-ho a engegar.


