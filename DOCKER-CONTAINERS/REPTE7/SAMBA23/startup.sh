#! /bin/bash

# Creació de xixa per als shares
mkdir /var/lib/samba/public
chmod 777 /var/lib/samba/public
cp /opt/docker/* /var/lib/samba/public/.
mkdir /var/lib/samba/privat

# chmod 777 /var/lib/samba/privat
cp /opt/docker/*.md /var/lib/samba/privat/.

# Configuració samba
cp /opt/docker/smb.conf /etc/samba/smb.conf

# Creació usuaris unix/samba
useradd -m -s /bin/bash lila
useradd -m -s /bin/bash roc
useradd -m -s /bin/bash patipla
useradd -m -s /bin/bash pla
echo -e "lila\nlila" | smbpasswd -a lila
echo -e "roc\nroc" | smbpasswd -a roc
echo -e "patipla\npatipla" | smbpasswd -a patipla
echo -e "pla\npla" | smbpasswd -a pla

# Archivar els serveis
/usr/sbin/smbd && echo "smb OK"
/usr/sbin/nmbd -F && echo "nmb OK"


