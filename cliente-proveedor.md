## Publicación de Servicios ##

**Diagrama General**

SI1 -----> SS1 ---- TUNEL TLS/ RED PÚBLICA --- SS2--->SI2

* SI1: Sistema de información que consume datos  
* SS1: Pasarela de seguridad con sub-sistema de consumo "sv-test/GOB/XXXX/consulta"
* SS2: Pasarela de seguridad con sub-sistema que entrega datos
* SI2: Sistema de información que produce datos. "sv-test/GOB/1001/api-pruebas"

Donde el servicio ***sv-test/GOB/XXXX/consulta***, es un cliente debidamente registrado, donde ***XXXXX*** es el código del miembro que desea consumir los datos.   

### Comunicación entre Pasarela y API de datos ###

Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno, por defecto es HTTPS con autenticación; por lo que es necesario agregar el certificado a la lista de certificados TLS internos.  El certificado debe ser el mismo que utiliza el servidor donde reside la API de datos (SI2). Por ejemplo para un servidor Nginx se debe subir el certificado definido en la propiedad 'ssl_certificate':

```
  ssl_certificate /etc/ssl/certs/api-autofirmado.crt;
 ```
 Si su API no utiliza autorización mutua TLS, la configuración esta lista.   

### Comunicación entre Pasarela y API de datos usando MTLS ###

El sistema de información requiere un certificado de cliente autorizado, la Pasarela de seguridad Proveedor enviará automaticamente su certificado interno. Si el certificado no está autorizado se generará este error:
```
{"type":"Server.ServerProxy.SslAuthenticationFailed","message":"Server certificate is not trusted",
```

Debe instalarse un nuevo certificado, que este autorizado. Para esto, seleccione Menu Principal, Parámetros del Sistema, Certificado TLS Interno, generar petición de certificado. Ingrese el sujeto que desea usar en su nuevo certificado: CN=servicios.local,OU=Ministerio xxx,O=Gobierno de El Salvador,C=SV. 

La petición/soliciud de certificado debe ser firmada por la Autoridad Certificadora que esta usando el servidor web, como se explica en la seccion de [firmar solicitud de pasarela de seguridad](crear_API_con_MTLS.md)


### Firmar petición de Pasarela Proveedor para API con MTLS ###

La pasarela de seguridad del Proveedor necesita obtener un certificado autorizado; para esto desde la pasarela se debe generar la solicitud de certificado (Menu Principal, Parámetros del Sistema, Certificado TLS Interno, generar petición de certificado). El siguiente comando firma la solicitud 'pasarela.p10' y genera el archivo 'pasarela-autorizada.crt' que debe ser instalado en la pasarela (Menu Principal, Parámetros del Sistema, Certificado TLS Interno, Importar).  

```
openssl x509 -req -days 365 -in /var/tmp/pasarela.p10 -CA /etc/ssl/certs/api-ac.crt -CAkey /etc/ssl/private/api-ac.key -set_serial 01 -out /var/tmp/pasarela-autorizada.crt;
```
Este comando debe ser ejecutado en el servidor donde recide la API .
