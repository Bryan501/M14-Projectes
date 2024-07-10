#!/bin/bash

# Instalar git
apk add git

# Crear directorio para los apuntes
mkdir -p /usr/share/doc/edtasix

# Clonar repositorios
git clone https://gitlab.com/edtasixm06/m06-aso.git /usr/share/doc/edtasix/M06-ASO
git clone https://gitlab.com/edtasixm14/m14-projectes.git /usr/share/doc/edtasix/M14-proyectos
