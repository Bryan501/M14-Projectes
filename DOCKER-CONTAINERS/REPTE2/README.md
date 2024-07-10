# Imatge personalitzada de Debian per activar una pàgina web en Detach

Aquesta imatge de Docker està bassada en l'activació d'una pàgina web en Detach on podrem veure el seu
contingut fora del container.

## Dockefile

L'arxiu "Dockerfile" definirà els passos per a la construcció de la imatge Docker

## Startup.sh

L'arxiu "Startup.sh" inicialitzarà les comendes on afegirà el nostre arxiu creat "index.html" per porsar-ho al container

## Index.html

L'arxiu "Index.html" és farà servir per representar el que és veura a la pàgina web mitjançabt el container

## Comandes

```bash

# Construcció de la imatge

docker build -t bryan501/repte2:detach .

# Iniciatlizar la imatge

docker run --name repte2 -h edt.org -p 8080:80 -d bryan501/repte2:detach

# Veure la pàgina web al google

http://localhost:80
```


