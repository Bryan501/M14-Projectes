#!/bin/bash

cp /opt/docker/index.html /var/www/html/index.html
cp /opt/docker/chargen /opt/docker/daytime /opt/docker/echo /etc/xinetd.d

systemctl start vsftpd
systemctl start tftpd-hpa
systemctl start apache2

xinetd -dontfork

