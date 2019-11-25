Crear certficado:

```
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/api-autofirmado.key -out /etc/ssl/certs/api-autofirmado.crt -subj "/C=SV/O=Gobierno de El Salvador/O=Presidencia/OU=CERTIFICADO AUTOFRIMADO/CN=API de Integración de datos"
```

Crear parametros de intercambio TLS:

```
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```

Crear archivo de configuración de host virtual usando un puerto disponible (ej 9443):

```
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
        root /var/www/html;
        index index.php;

        location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.2-fpm.sock;
        }
}
```
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
echo $data; 
?> 
 ```

