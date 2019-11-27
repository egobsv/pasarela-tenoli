
SI1 -----> SS1 ---- INTERNET/RED PÚBLICA --- SS2--->SI2

* SI1: Sistema de información que consume datos  
* SS1: Pasarela de seguridad con sub-sistema de consumo "sv-test/GOB/1001/consulta"
* SS2: Pasarela de seguridad con sub-sistema que entrega datos
* SI2: Sistema de información que produce datos. "sv-test/GOB/1001/api-pruebas"


Comunicación SI1 ---> SS1

Para consumir un servicio desde la red interna, primero debe crearse el sub-sistema consumidor (vacío). Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno, por defecto es HTTPS con autenticación; por lo que es necesario crear y agregar un certificado interno usando los siguientes pasos:  
  
```
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout consumidor-api.key -out consumidor-api.crt -subj "/C=SV/O=Gobierno de El Salvador/O=PRUEBAS/OU=CERTIFICADO AUTOFRIMADO/CN= Consumidor - API de Integración de datos"
```

Asegurase de subir e archivo consumidor-api.crt a la lista de certificados TLS internos y luego pruebe el servicio usando los certificados que acaba de crear desde su sistema de información que consume datos o usando la siguiente linea de comandos:
```
curl -k -E consumidor-api.crt --key consumidor-api.key -X GET -H 'X-Road-Client: sv-test/GOB/1001/consulta' -i 'https://localhost/r1/sv-test/GOB/1001/api-pruebas/consulta-pruebas'
``` 

Comunicación SS2 ---> SI2
Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno, por defecto es HTTPS con autenticación; por lo que es necesario agregar el certificado a la lista de certificados TLS internos.  El certificado debe ser el mismo que utiliza el servidor donde reside el sistema de información interno (SS2). Por ejemplo para un servidor Nginx se debe subir el certificado de la propiedad 'ssl_certificate':

```
  ssl_certificate /etc/ssl/certs/api-autofirmado.crt;
 ```
      

