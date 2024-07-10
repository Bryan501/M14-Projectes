# Imatge personalitzada de Debian per fer inspeccions al sistema

Aquesta imatge de Docker està basada en un Debian i conté eines útils per inspeccionar el sistema.

## Eines

- "ps"
- "ping"
- "ip"
- "nmap"
- "tree"
- "vim"

## Dockerfile

L'arxiu "Dockerfile" definirà els passos per a la construcció de l'imatge Docker. Resum del contingut:

### Contingut del Dockerfile:

```dockerfile
# Utilització d'una imatge Debian com a base
FROM debian

# Actualitza els repositoris i instal·la els paquets necessaris
RUN apt-get update && apt-get install -y \
 procps iputils-ping iproute2 nmap tree vim

# Comanda per predeterminar com s'executarà el contenidor al iniciar-se
CMD /bin/bash
```

## Desenvolupament

Per crear aquesta imatge, utilitzarem aquesta ordre:

```bash
docker build -t bryan501/debian-ordre:v1 .
```

## Ús

Per executar un contenidor interactiu amb aquesta imatge, podem utilitzar la segûent ordre:

```bash
docker run -it bryan501/debian-ordre:v1 .
```
