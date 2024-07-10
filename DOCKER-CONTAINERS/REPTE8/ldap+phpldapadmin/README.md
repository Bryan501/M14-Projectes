# Archiu personalitzada de configuració asociada al Docker Compose

## docker-compose-ldap-phpldapadmin.yml

Aquest fitxer .yml conte 2 containers: El LDAP23 i el PHPLDAPADMIN23

## Desenvolupament

Executem el nostre fitxer amb el docker-compose:
```bash
docker compose up -d
```
Verifiquem si el portainer funciona:
```bash
http://localhost/phpldapadmin
```
Farem aquesta comanda si volem fer stop als containers, abans fets amb el compose:
```bash
docker compose down
```