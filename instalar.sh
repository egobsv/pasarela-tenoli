#!/usr/bin/env bash
timedatectl set-timezone America/El_Salvador;
useradd -m xroad;

#MODIFIQUE LA CONTRASEÑA!!!
echo 'xroad:xroad' | chpasswd;

apt-get update;
apt-get install -y openjdk-8-jre-headless ca-certificates-java crudini rlwrap ntp unzip expect authbind;
apt-get install -y nginx-light postgresql postgresql-contrib postgresql-client libmhash2;
cd /opt/tenoli;
debconf-set-selections ss-respuestas.txt;

dpkg -i xroad-common_6.7.13-1._amd64.deb xroad-jetty9_6.7.13-1._all.deb;
dpkg -i xroad-proxy_6.7.13-1._all.deb;
dpkg -i xroad-addon-proxymonitor_6.7.13-1._all.deb xroad-monitor_6.7.13-1._all.deb xroad-addon-messagelog_6.7.13-1._all.deb xroad-addon-metaservices_6.7.13-1._all.deb xroad-securityserver_6.7.13-1._all.deb;

cd /opt/tenoli/scripts;
cp jetty.conf /etc/xroad/services/;
cp xroad-jetty.service /etc/systemd/system/;
cp xroad-jetty9 /usr/bin/; 
chmod +x /usr/bin/xroad-jetty9;

cp xroad-signer /usr/share/xroad/bin;
chmod +x /usr/share/xroad/bin/xroad-signer;
cp xroad-signer.service /etc/systemd/system/;
cp xroad-confclient /usr/share/xroad/bin;
chmod +x /usr/share/xroad/bin/xroad-confclient;
cp xroad-confclient.service /etc/systemd/system/;
systemctl enable xroad-jetty.service;
systemctl start xroad-jetty.service;

cp xroad-proxy-port-redirect.sh /usr/share/xroad/scripts/;
cp xroad-proxy /usr/share/xroad/bin/;
cp xroad-monitor /usr/share/xroad/bin/;
cp xroad-opmonitor /usr/share/xroad/bin/;
mkdir -p /usr/share/xroad/autologin/;
cp xroad-autologin-retry.sh /usr/share/xroad/autologin/;
chmod +x /usr/share/xroad/scripts/xroad-proxy-port-redirect.sh \
/usr/share/xroad/bin/xroad-proxy /usr/share/xroad/bin/xroad-monitor \
/usr/share/xroad/bin/xroad-opmonitor /usr/share/xroad/autologin/xroad-autologin-retry.sh;
cp xroad-proxy.service /etc/systemd/system/;
cp xroad-monitor.service /etc/systemd/system/;

systemctl enable xroad-proxy.service;
systemctl enable xroad-monitor.service;
systemctl enable xroad-signer.service;
systemctl enable xroad-confclient.service;

systemctl start xroad-confclient.service;
systemctl start xroad-signer.service;
systemctl start xroad-proxy.service;
systemctl start xroad-monitor.service;

##ADD HOSTS
echo "190.5.135.94 tenoli.gob.sv" >> /etc/hosts;
