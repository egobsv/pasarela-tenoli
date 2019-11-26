
A	B		C
SI1 -----> SS1 ---- INTERNET/RED PÚBLICA --- SS2--->SI2

SI1: Sistema de información que consume datos  
SS1: Pasarela de seguridad con sub-sistema de consumo "sv-test/GOB/1001/consulta"
SS2: Pasarela de seguridad con sub-sistema que entrega datos
SI2: Sistema de información que produce datos. "sv-test/GOB/1001/api-pruebas"


Comunicación SI1 ---> SS1

Para consumir un servicio desde la red interna, primero debe crearse el sub-sistema consumidor (vacío). Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno, por defecto es HTTPS con autenticación. Por lo que es necesario crear y agregar un certificado interno usando los siguientes pasos:  
  
```
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout consumidor-api.key -out consumidor-api.crt -subj "/C=SV/O=Gobierno de El Salvador/O=PRUEBAS/OU=CERTIFICADO AUTOFRIMADO/CN= Consumidor - API de Integración de datos"
```

Asegurase de subir e archivo consumidor-api.crt a la lista de certificados TLS internos y luego pruebe el servicio usando los certificados que acaba de crear desde su sistema de información que consume datos o usando la siguiente linea de comandos:

curl -k -E consumidor-api.crt --key consumidor-api.key -X GET -H 'X-Road-Client: sv-test/GOB/1001/consulta' -i 'https://localhost/r1/sv-test/GOB/1001/api-pruebas/consulta-pruebas'
``` 

Comunicación SI2 ---> SS2
Crear parámetros de intercambio TLS:

```
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
```

Crear archivo de configuración de host virtual usando un puerto disponible (ej 9443):


Crear certificado:

```
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/api-autofirmado.key -out /etc/ssl/certs/api-autofirmado.crt -subj "/C=SV/O=Gobierno de El Salvador/O=Presidencia/OU=CERTIFICADO AUTOFRIMADO/CN=API de Integración de datos"
```

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

