En aquest repte s’estudiaran algunes dels elements de personalització en la creació d’imatges automatitzades per a màquines virtuals. En especial:
    ● Sync de directoris
    ● Còpia de fitxers
    ● Provisioning amb shell inline i amb path.

Usar una imatge de tipus generic/alpine38.

Sincronitzar el directori de desenvolupament d’aquesta pràctica del host a dins de la imatge Vagrant a la ubicació /vagrant_data.

Crear un fitxer README.md descriptiu de l’escola, el cicle, el mòdul i aquesta pràctica. 

Copiar-lo a la ubicació /var/tmp usant el provision de tipus file.

Usant el provision shell inline mostrar l’execució de l’ordre “uname -a”.

Usant el provision shell inline instal·lar Docker (per alpine), configurar l’usuari perquè pertanyi al grup docker i activar el servei. Si es tracta de múltiples línies d’instruccions escriure un shel inline amb multilinies i un marcador de final.

Usant un provision shell path executar usant un fitxer script la instal·lació de git, la creació dels directori /usr/share/doc/edtasix i dins seu la descàrrega dels repositoris git (un git clone) dels apunts M06-ASO i de M14-projectes.

Generar una màquina virtual basada en la creació d’aquesta imatge i verificar-ne els requeriments.

Crear un compte personal al Vagrant Cloud i pujar la imatge amb el nom usuari/edt22base.