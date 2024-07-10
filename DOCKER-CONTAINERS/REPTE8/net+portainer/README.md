# Archiu personalitzada de configuració asociada al Docker Compose

## docker-compose-net-portainer.yml

Aquest fitxer .yml conte 2 containers: El NET23 i el PORTAINER`.

## Desenvolupament

Executem el nostre fitxer amb el docker-compose:
```bash
docker compose up -d
```
Verifiquem que el portainer funciona:
```bash
http://localhost:9000
```

Farem aquesta comanda si volem fer stop als containers, abans fets amb el compose:
```bash
docker compose down
```