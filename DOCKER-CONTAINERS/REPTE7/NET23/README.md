# Imatge personalitzada de Debian per utilitzar el serveis de xarxa ECHO, DAYTIME, CHARGEN, FTP, TFTP i HTTP.

Aquesta imatge de Docker està basada en un Debian i conté el procés de com instal·lar els serveis de xarxa ECHO, DAYTIME, CHARGEN, FTP, TFTPD i HTTP.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

## startup.sh

L'arxiu "Startup.sh" s'executarà mitjançant el "Dockerfile" sense necessitat de fer totes les comandes des de dins del container. On es farà el següent:

    - Primer de tot farà la còpia del "index.html" que tenim en el nostre repositori per afegir-lo a l'apache del container.
    - També farà el mateix en els fitxers chargen, daytime i echo però, es posaran a la carpeta del xinetd.
    - I finalitzarà amb l'activació dels 4 serveis de xarxa ftp tftp i http (aquest, en segon pla).

## index.html

L'arxiu "index.html" tindrà un contingut fer en html, on es mostrarà un petit disseny d'una pàgina web que ens ajudarà a sapigué què anar bé el server del http en el container.

## echo-daytime-chargen

En aquests tres arxius el crearem nosaltres amb la seva configuració per a cada una d'elles on substituiran la configuració del xinetd del container.

## Desenvolupament

Per crear la ºimatge, farem la següent ordre:
```bash
docker build -t bryan501/net23:detach .
```

Generem la imatge en detach, amb els seus ports corresponents de cada servei:
```bash
docker run --rm --name mi-net -h net.edt.org -p 7:7 -p 13:13 -p 19:19 -p 21:21 -p 69:69 -p 80:80 -d bryan501/net23:latest 
```

Comprovem que anan tots els serveis:
```bash
systemctl status vsftpd
systemctl status tftpd-hpa
systemctl status apache2
```
També podem veure si els ports estan oberts (si no es veuen x ports oberts de x serveis no passa res, però n'hi han d'estar running els serveis):
```bash
nmap localhost
```
Veiem si l'apache es veu al Google (HTTP):
```html
http://localhost:80
```
Comprovem el TFTP:
```bash
docker exec -it mi-net tftp localhost
get README.md
```
Finalitzem la comprovació mitjançant el telnet apuntant els ports:
ECHO:
```bash
telnet localhost 7
```
DAYTIME:
```bash
telnet localhost 13
```
CHARGEN:
```bash
telnet localhost 19
```
FTP:
```bash
telnet localhost 21
```



