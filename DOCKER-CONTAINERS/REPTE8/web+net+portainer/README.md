# Archiu personalitzada de configuració asociada al Docker Compose

## docker-compose-web-net-portainer

Aquest fitxer .yml conte 3 containers: El WEB23, el NET23 i el PORTAINER.

## Desenvolupament

Executem el nostre fitxer amb el docker-compose:
```bash
docker compose up -d
```
Verifiquem si el portainer funciona:
```bash
http://localhost:9000
http://localhost
```
Farem aquesta comanda si volem fer stop als containers, abans fets amb el compose:
```bash
docker compose down
```
