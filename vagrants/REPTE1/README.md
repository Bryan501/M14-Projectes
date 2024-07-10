Configurar els providers

Vagrant és una eina que s’executa per ‘sobre’ dels programes de gestió de
màquines virtuals per proporcionar una gestió de capa superiors. Per sota utilitza els
programes clàssics de gestió de màquines virtuals com són libvirtd, virtualbox o
VMware. Aquests programes són els que anomena providers.

Instal·lar el software de gestió de màquines virtuals de libvirtd conjuntament amb
les eines gràfiques de virt-manager.

Instal·lar el software de gestió de màquine svirtuals virtualbox. Per fer-ho es poden
seguir le sindicacions de la seva seu web o també les instruccions de l’apèndix del
document HowTo-ASIX-Vagrant.pdf. Segurament caldrà instal·lar els paquets dels
kernel headers i executar la utilitat de configuració vboxsetup.

Instal·lar Vagrant seguint les indicacions de la seu web de l’aplicació. Observar que
hi ha dos mecanismes clàssics, via un paquet descarregable (cal usar apt-get
perquè estiri de les dependències) o configurar un repositori propi (cal la línia
descriptiva del repositori i la clau GPG) i seguidament fer-ne la instal·lació amb
apt-get.

Gestionar les imatges (Box)

Practicar les ordres de gestió d’imatges que Vagrant anomena Box.

$ vagrant box
add list prune repackage
help outdated remove update

Afegir els següents Box (practicar afegir, llistar i eliminar)
    ● Afegir dos box de alpine generic/alpine38, un per libvirtd i un per virtualbox
    ● Afegir dos box debian bullseye64, també per a libvirtd i virtualbox.
    ● Un box de ubuntu per virtualbox.
    ● Un box per fedora cloud 37 per a libvirtd.

Vagrant Cloud:
    ● Navegar per vagrant cloud i identificar les imatges que hi ha, en especial les de Debian, Fedora i Ubuntu. Observar si són oficials o no.
    ● Observar de les imatges per a quins providers n’existeixen versions.

Creació, execució i accés a una VM

Crear una màquina virtual basada en el Box de generic/alpine38. Practicar les ordres
de gestió de les màquines virtuals:
    ● Creació (up), aturar, suspendre, reanudar, eliminar, estatus (local i global).

Accedir a la màquina virtual amb vagrant ssh i observar la següent informació:
    ● cat /etc/os-release
    ● uname -a
    ● id
    ● pwd
    ● ip a
    ● nmap localhost
    ● ls / /vagrant