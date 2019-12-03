#Servidor de Seguridad basado en Centos 7
#
timedatectl set-timezone America/El_Salvador;
hostnamectl set-hostname ssx.tenoli.gob.sv
echo "LC_ALL=en_US.UTF-8">> /etc/environment;

chown -R xroad:xroad /etc/xroad;
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
#Fijar contrasenia
echo 'xroad:xroad' | chpasswd;
systemctl start xroad-proxy

##NUMERO PIN
touch /etc/xroad/autologin;
chown xroad:xroad /etc/xroad/autologin;
echo "1234" >> /etc/xroad/autologin;
