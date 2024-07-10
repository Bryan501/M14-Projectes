# Archiu personalitzada de configuració asociada al Docker Compose

## docker-compose-postgres-adminer.yml

Aquest fitxer .yml conte 2 containers: El POSTGRES23 i el ADMINER.

## Desenvolupament

Executem el nostre fitxer amb el docker-compose:
```bash
docker compose up -d
```
Verifiquem si el adminer funciona:
```bash
http://localhost:8080
```
I iniciem sessió mitjançant el que hagim fet al .yml:

- PostgresSQL
- postgres
- postgres
- secret123
- training

Farem aquesta comanda si volem fer stop als containers, abans fets amb el compose:
```bash
docker compose down
```