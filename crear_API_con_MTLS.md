
Identificacion MTLS

El objetico es ofrecer un servicio en php usando HTTPS y que esta disponible únicamente a usuarios que tengan un certificado de cliente autorizado.

Crear serivicio


Instalar PHP
```
apt-get install php7.2 php7.2-fpm
```

Crear contenido de la API, archivo index.php:
 ```
 <?php 
$json->nombre = "Pedro Paramo";
$json->nit = "012345012345";
$json->dui = "0987654321";
$data = json_encode($json); 
echo "\n".$data; 
?> 
 ```
Provar el script:
```
~# php7.2 /var/www/html/index.php

{"nombre":"Pedro Paramo","nit":"012345012345","dui":"0987654321"} 
```
Configurar Host virtual con https en Nginx 

Crear certificado y parámetros para HTTPS:

```
~#openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

~# openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/api-autofirmado.key -out /etc/ssl/certs/api-autofirmado.crt -subj "/C=SV/O=Gobierno de El Salvador/O=Presidencia/OU=CERTIFICADO AUTOFRIMADO/CN=API de Integración de datos"
```

Crear archivo de configuración de host virtual usando un puerto disponible (ej 9443):

```
##Host Virtual /etc/nignx/sites-enabled/ejemplo-xroad
server {
        listen 9443 ssl;
        ssl_certificate /etc/ssl/certs/api-autofirmado.crt;
        ssl_certificate_key /etc/ssl/private/api-autofirmado.key;
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
        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        }
}

```
Al llamar la api sin un ertificado autorizado, el servidor responderá con un error:
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
