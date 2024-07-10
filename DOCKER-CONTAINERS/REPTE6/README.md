# Imatge personalitzada de Debian per utilizar LDAP

Aquesta imatge de Docker està basada en un Debian i conté el procés de com instal·lar el servei LDAP on podem canviar l'administrador i la seva contrasenya.

## Dockerfile

L'arxiu "Dockerfile" definirà els passos a seguir per a la construcció de l'imatge Docker.

## Startup.sh

L'arxiu "Startup.sh" s'executarà mitjançant el "Dockerfile" sense necessitat de fer totes les comandes des de adins del container. On es farà el següent:

    - Primer de tot farà els seds per substituir a l'administrador com la seva contrasenya i terminem amb tot el procés de esborrar les dades per defecte, etc.

## edt-org.ldif

L'arxiu "edt-org.ldif" tindrà les entitats que volem on, s'utilitzarà mitjançant el "Startup.sh" 
per agafar les nostres dades i substituir-les per les de defecte.

## slapd.conf

L'arxiu "slapd.conf" tindrà la nostra configuració que volem al LDAP.

## Desenvolupament

Per crear la ºimatge, farem la següent ordre:
```bash
docker build -t bryan501/ldap23:detach .
```

Generem la imatge en detach, amb els seus ports i afegint les variables d'entorn anomenades al startup.sh:
```bash
docker run --rm --name mi-ldap -h ldap.edt.org -p 389:389 -e LDAP_ADMIN_USERNAME=bryan -e LDAP_ADMIN_PASSWORD=bryan -d bryan501/ldap23:detach
```

Entrem al container i comprovem:
```bash
docker exec -it mi-ldap /bin/bash
slapcat
ldapdelete -x -D 'cn=pepe,dc=edt,dc=org' -w pepe 'cn=Anna Pou,ou=usuaris,dc=edt,dc=org'
```


