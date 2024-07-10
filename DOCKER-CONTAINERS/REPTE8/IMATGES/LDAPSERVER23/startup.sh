#! /bin/bash

bash /opt/docker/install.sh
ulimit -n 1024
/usr/sbin/slapd -d0
