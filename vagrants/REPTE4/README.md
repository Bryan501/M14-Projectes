En aquest repte es crearà la configuració per a desplegar amb Vagrant màquines virtuals Debian configurades com si es tractessin de hosts de l’aula.

Caldrà que utilitzin una interfície de xarxa tipus bridge per poder ser hosts independents que rebin l’adreça IP de l’aula.

Caldrà que automàticament disposin de la post instal·lació (totalment automatitzada) per configurar el host com un més de l’aula, permetent l’autenticació dels alumnes i professors.

Aquest repte utilitzarà un Box Debian-11 (debian/bullseye64).

Pujar la imatge al Vagrant Cloud (al compte personal) amb el nom usuari/edt22aula.

*nota* Hi ha dos elements interactius a l’script d’instal·lació de l’aula que cal convertir en no interactius. Consultar el professor si es necessita ajuda per resoldre aquesta part:
    ● apt-get -y install krb5-user
    ● sudo pam-auth-update