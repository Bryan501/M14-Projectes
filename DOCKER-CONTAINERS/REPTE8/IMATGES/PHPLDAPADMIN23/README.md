## Configuració de phpLDAPadmin en Docker

Aquest repositori conté els fitxers necessaris per configurar i executar phpLDAPadmin dins d'un contenidor Docker.

### Fitxers inclosos:

#### `config.php`

El fitxer `config.php` és la configuració personalitzada de phpLDAPadmin. Conté opcions per modificar les preferències per defecte, configurar connexions amb servidors LDAP i altres configuracions importants. S'ha d'editar amb cura per ajustar-lo a les necessitats de l'entorn.

#### `Dockerfile`

El fitxer `Dockerfile` defineix les instruccions per a la construcció de la imatge Docker. Utilitza Fedora 27 com a base i instal·la `phpldapadmin`, `php-xml` i `httpd`. A més, copia els fitxers necessaris del repositori al contenidor, estableix permisos i defineix la comanda per iniciar el contenidor.

#### `instal.sh`

El script `instal.sh` realitza la configuració necessària perquè phpLDAPadmin funcioni correctament. Copia arxius de configuració específics als seus llocs adients dins del contenidor.

#### `phpldapadmin.conf`

El fitxer `phpldapadmin.conf` és la configuració d'Apache per a phpLDAPadmin. Estableix alias i directrius de directori per permetre l'accés a la interfície web de phpLDAPadmin.

#### `startup.sh`

El script `startup.sh` és el punt d'entrada del contenidor. Executa l'script `install.sh` per realitzar la configuració inicial i després inicia els serveis necessaris (`php-fpm` i `httpd`).
