#! /bin/bash

# Copiem el index.html que hem creat 
# i el ficarem a la ruta que emmagatzema la informació de la pagina web

cp /opt/docker/index.html /var/www/html/index.html

#servei apache2 status, per veure'l i activar el apache

apachectl -DFOREGROUND
