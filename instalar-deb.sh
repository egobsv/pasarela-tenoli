#!/usr/bin/env bash
timedatectl set-timezone America/El_Salvador;
useradd -m xroad;

#MODIFIQUE LA CONTRASEÑA!!!
echo 'xroad:xroad' | chpasswd;

apt-get update;
apt-get install -y  openjdk-8-jre-headless ca-certificates-java ntp unzip expect net-tools \
                   postgresql postgresql-contrib postgresql-client crudini rlwrap \
                   nginx-light curl debconf rlwrap rsyslog unzip libmhash2 authbind;
cd /opt/tenoli;

#MODIFIQUE EL ARCHIVO ANTES DE EJECUTAR ESTE COMANDO!!!
debconf-set-selections /opt/tenoli/ss-respuestas.txt;
cd /opt/tenoli/deb; 

dpkg -i xroad-base_6.22.0-1.local.ubuntu18.04_amd64.deb xroad-jetty9_6.22.0-1.local.ubuntu18.04_all.deb \
	 xroad-signer_6.22.0-1.local.ubuntu18.04_amd64.deb xroad-nginx_6.22.0-1.local.ubuntu18.04_amd64.deb \
         xroad-confclient_6.22.0-1.local.ubuntu18.04_amd64.deb;
service postgresql restart;

dpkg -i xroad-proxy_6.22.0-1.local.ubuntu18.04_all.deb xroad-monitor_6.22.0-1.local.ubuntu18.04_all.deb \
        xroad-opmonitor_6.22.0-1.local.ubuntu18.04_all.deb \
        xroad-addon-opmonitoring_6.22.0-1.local.ubuntu18.04_all.deb; 

dpkg -i xroad-addon-metaservices_6.22.0-1.local.ubuntu18.04_all.deb \
        xroad-addon-messagelog_6.22.0-1.local.ubuntu18.04_all.deb \
        xroad-addon-proxymonitor_6.22.0-1.local.ubuntu18.04_all.deb \
        xroad-addon-wsdlvalidator_6.22.0-1.local.ubuntu18.04_all.deb;

dpkg -i xroad-securityserver_6.22.0-1.local.ubuntu18.04_all.deb xroad-autologin_6.22.0-1.local.ubuntu18.04_all.deb;

##NUMERO PIN
touch /etc/xroad/autologin;
chown xroad:xroad /etc/xroad/autologin;
echo "CAMBIAME" >> /etc/xroad/autologin;
