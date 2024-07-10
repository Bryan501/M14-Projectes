# Imatge personalitzada de Debian per utilitzar un servidor samba.

Aquesta imatge de Docker està basada en un Debian i conté el procés de com fer un servidor SAMBA.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

## startup.sh

L'arxiu "Startup.sh" s'executarà mitjançant el "Dockerfile" sense necessitat de fer totes les comandes des de dins del container. On es farà el següent:

    - Creació de directoris i configuració de permisos
    - Configuració de Samba
    - Crea usuaris en el sistema Unix amb noms lila, roc, patipla i pla, cadascun amb un directori d'inici (-m)
    - Inicia els serveis de Samba, /usr/sbin/smbd (servei de dimoni de Samba per compartir arxius) i /usr/sbin/nmbd (servei de dimoni NetBIOS per la resolució de noms), mostrant un missatge "smb OK" i "nmb OK" respectivament si s'engeguen correctament.

## smb.conf

L'arxiu "smb.conf" defineix la configuració global del Samba i els paràmetres específics per a diferents directoris compartits, especificant aspectes com ara permisos d'accés, rutes de directoris i propietats dels recursos compartits, com ara impressores i carpetes.

## Desenvolupament

Per crear la ºimatge, farem la següent ordre:
```bash
docker build -t bryan501/samba23:detach .
```
Generem la imatge en detach, amb els seus ports corresponents de cada servei:
```bash
docker run --rm --name mi-samba -h samba.edt.org -p 139:139 -p 445:445 -d bryan501/samba23:latest
```
Verifiquem la disponibilitat i accessibilitat dels recursos compartits especificats en la xarxa:
```bash
smbclient //172.17.0.2/public
smbclient //localhost/public
```