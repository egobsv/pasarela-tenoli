#Servidor de Seguridad basado en RHEL/Centos 7
#
timedatectl set-timezone America/El_Salvador;
echo "LC_ALL=en_US.UTF-8">> /etc/environment;

#Nombre del Equipo
hostnamectl set-hostname ssx.tenoli.gob.sv;

yum install -y yum-utils;
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;
yum update -y;
yum install -y java-1.8.0-openjdk.x86_64;
yum install -y crudini rlwrap nginx policycoreutils-python net-tools expect postgresql-server postgresql-contrib;

#carpeta con paquetes RPM
cd /opt/tenoli/;
yum --disablerepo=* localinstall -y *.rpm;

#Agregar usuario administrador
xroad-add-admin-user  xroad
#CAMBIAR CONTRASEÑA
echo 'xroad:xroad' | chpasswd;
systemctl start xroad-proxy

##NUMERO PIN
touch /etc/xroad/autologin;
chown xroad:xroad /etc/xroad/autologin;
echo "1234" >> /etc/xroad/autologin;

#Para REDHAT los puertos estan definidos en /etc/xroad/conf.d/override-rhel-proxy.ini
# 8080 y 8443

#Deshabilitar IPv6
~# nano /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
~# sysctl -p

#Deshabilitar Sitio de Nginx
~# nano /etc/nginx/nginx.conf
--Comentar Linea 40
# listen        [::}:80 default_server;
~# systemctl restart nginx
