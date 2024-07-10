# Imatge personalitzada de Debian per utilizar LDAP

Aquesta imatge de Docker està basada en un Debian i conté el procés de com instal·lar el servei LDAP on podem escogir el procés que volem que fagi.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

## Startup.sh

L'arxiu "Startup.sh" s'executarà mitjançant el "Dockerfile" sense necessitat de fer totes les comandes des de adins del container. On es farà el següent:

    - INITDB → Ho inicialitza tot de nou i fa el populate de edt.org.
    - SLAPD → ho inicialitza tot però només engega el servidor, sense posar-hi dades.
    - START / EDTORG / RES → Engega el servidor utilitzant la persistència de dades de la bd i de la configuració. És a dir, engega el servei usant les dades ja existents.
    - SLAPCAT Nº (0,1, RES) → Fa un slapcat de la base de dades indicada.


## edt-org.ldif

L'arxiu "edt-org.ldif" tindrà les entitats que volem on, s'utilitzarà o no mitjançant el "Startup.sh".

## slapd.conf

L'arxiu "slapd.conf" tindrà la nostra configuració que volem al LDAP.

## Desenvolupament

Per crear la ºimatge, farem la següent ordre:
```bash
docker build -t bryan501/ldap23:detach .
```
Creem els volums per el "start":
```bash
docker volume create ldap-dades
docker volume create ldap-config
```
Generem la imatge en mode interactiva i així podrem veure els missatges corresponents a les comandes que l'hem passat. A més a més, ficarem el -p per connectar els ports del sistema remot amb el local:
initdb:
```bash
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -d bryan501/ldap23:detach initdb

```
slapd:
```bash
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -d bryan501/ldap23:detach slapd
```
start|edtorg|res:
```bash
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -v ldap-dades:/var/lib/ldap -v ldap-config:/etc/ldap/slapd.d -it bryan501/ldap23:detach start
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -v ldap-dades:/var/lib/ldap -v ldap-config:/etc/ldap/slapd.d -it bryan501/ldap23:detach edtorg
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -v ldap-dades:/var/lib/ldap -v ldap-config:/etc/ldap/slapd.d -it bryan501/ldap23:detach
```
slapcat nº (0,1,res)
```bash
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -it bryan501/ldap23:detach slapcat
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -it bryan501/ldap23:detach slapcat 0
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -it bryan501/ldap23:detach slapcat 1
```


