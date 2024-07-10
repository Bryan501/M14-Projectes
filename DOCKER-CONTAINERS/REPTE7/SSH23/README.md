# Imatge personalitzada de Debian per utilitzar el servei SSH.

Aquesta imatge de Docker està basada en un Debian i conté el procés d'utilitzar el servei SSH.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

## startup.sh

L'arxiu "Startup.sh" s'executarà mitjançant el "Dockerfile" sense necessitat de fer totes les comandes des de dins del container. On es farà el següent:

    - Executar el script "useradd.sh" per afegir els usuaris.
    - Finalitza executant el servei SSH en segon pla.

## useradd.sh

L'arxiu "smb.conf" serà un script per crear usuaris amb directori de inici pel usuari

## Desenvolupament

Per crear la ºimatge, farem la següent ordre:
```bash
docker build -t bryan501/ssh23:latest .
```
Generem la imatge en detach, amb els seus ports corresponents de cada servei:
```bash
docker run --rm --name mi-ssh -h ssh.edt.org -p 22:22 -d bryan501/ssh23:latest 
```
Verifiquem si podem connectar-nos a algun usuari que hem creat abans:
```bash
docker exec -it mi-net ssh unix01@localhost
yes
unix01
$
```
