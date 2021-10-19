
## Crear API para entregar datos ##

El objetivo del ejercicio descrito en esta página es ofrecer un servicio en php usando HTTPS,  que esta disponible únicamente a usuarios que tengan un certificado de cliente autorizado. La identificación mútua TLS permite controlar el acceso a nuestra apliación usando certificados electrónicos.

Esta guía usa PHP y Nginx, es posible configurar identificación mútua TLS en [Apache](http://www.stefanocapitanio.com/configuring-two-way-authentication-ssl-with-apache/), [JBoss](https://developer.jboss.org/wiki/MutualAuthenticationOnJBoss720Final)y [IIS](https://medium.com/@hafizmohammedg/configuring-client-certificates-on-iis-95aef4174ddb).

**Crear servicio**

El servicio de ejemplo utiliza un script PHP para regresar un objeto JSON con valores estaticos.
```
~# apt install php php-fpm

~#nano /var/www/html/index.php:

 <?php 
$json = new stdClass();
$json->nombre = "Pedro Paramo";
$json->nit = "012345012345";
$json->dui = "0987654321";
$data = json_encode($json); 
echo "\n".$data; 
?> 
 
~# php7.3 /var/www/html/index.php

{"nombre":"Pedro Paramo","nit":"012345012345","dui":"0987654321"} 
```

**Servidor HTTPS**

Para servir nuestra API vamos a crear un Host virtual en Nginx. El primer paso es crear los certificados que utilizaremos en el servicio https.   

*Crear autoridad certificadora, certificado web y parámetros para HTTPS:

```
echo "####Autoridad Certificadora:'
openssl genrsa -out /etc/ssl/private/api-ac.key 4096;
openssl req -new -x509 -days 365 -key /etc/ssl/private/api-ac.key -out /etc/ssl/certs/api-ac.crt \
       -subj "/C=SV/O=Gobierno de El Salvador/O=Min xxx/OU=CERTIFICADO AUTOFRIMADO/CN=Autoridad certificadora";

echo "####Certificado de Servidor Web";
openssl genrsa -out /etc/ssl/private/servidor-web.key 2048;
openssl req -new -key /etc/ssl/private/servidor-web.key -out /etc/ssl/certs/server-web.csr \
        -subj "/C=SV/O=Gobierno de El Salvador/O=MIN xx/OU=CERTIFICADO AUTOFRIMADO/CN=Servidor HTTPS local";
        
openssl x509 -req -days 365 -in /etc/ssl/certs/server-web.csr -CA /etc/ssl/certs/api-ac.crt \
             -CAkey /etc/ssl/private/api-ac.key -set_serial 01 -out /etc/ssl/certs/server-web.crt;

~#openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048;
```

Crear archivo de configuración de host virtual usando un puerto disponible (ej 9443):

```
##Host Virtual /etc/nginx/conf.d/ejemplo-xroad.conf
server {
        listen 9443 ssl;
        ssl_certificate /etc/ssl/certs/server-web.crt;
        ssl_certificate_key /etc/ssl/private/servidor-web.key;
        ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
        ssl_protocols TLSv1.2;
        ssl_dhparam /etc/ssl/certs/dhparam.pem;
        ssl_prefer_server_ciphers on;

        add_header X-Content-Type-Options nosniff;
        add_header X-XSS-Protection "1; mode=block";

        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  10m;
        keepalive_timeout    60;
        
        access_log /var/log/nginx/api_access.log;
        error_log /var/log/nginx/api_error.log;
        root /var/www/html;
        index index.php;

        # MTLS
        ssl_client_certificate /etc/ssl/certs/api-ac.crt;
        ssl_verify_client on;

        location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.3-fpm.sock;
        }
}

```
Al llamar la api sin un certificado autorizado, el servidor responderá con un error indicando que la llamada requiere una certificado autorizado:
```
~# curl -k https://localhost:9443/
<html>
<head><title>400 No required SSL certificate was sent</title></head>
<body bgcolor="white">
<center><h1>400 Bad Request</h1></center>
<center>No required SSL certificate was sent</center>
<hr><center>nginx</center>
</body>
</html>
```
**Crear certificado de cliente autorizado**
```
openssl genrsa -out /etc/ssl/private/cliente.key 2048;
openssl req -new -key /etc/ssl/private/cliente.key -out /etc/ssl/certs/cliente.csr \
       -subj "/C=SV/O=Gobierno de El Salvador/O=MIN xx/OU=CERTIFICADO AUTOFRIMADO/CN=Cliente Autorizado";

openssl x509 -req -days 365 -in /etc/ssl/certs/cliente.csr -CA /etc/ssl/certs/api-ac.crt 
             -CAkey /etc/ssl/private/api-ac.key -set_serial 01 -out /etc/ssl/certs/cliente.crt;
```
Invocar la API enviando un certificado de cliente autorizado:
```
~# curl -k -E /etc/ssl/certs/cliente.crt --key /etc/ssl/private/cliente.key https://localhost:9443/;
```
