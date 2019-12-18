## Publicación de Servicios ##

**Diagrama General**

RED TENOLI ---> SS--->SI

* SS: Pasarela de seguridad con sub-sistema que entrega datos
* SI: Sistema de información que produce datos. Ejm: "sv-test/GOB/1001/api-pruebas"

Es responsabilidad de cada institución implementar los mecanismos que garanticen la seguridad de las comunicaciones entre sistemas en su red local; esto incluye la comunicacion entre su Pasarela de Seguridad y su Sistema de Información.  

La Pasarela de Seguriad ofrece tres modos de conexión hacia sistemas en su red local:

|Modo|Protocolo| Seguridad|
|-----|------|------|
|HTTPS| HTTPS con verficación de certificado y autenticación de cliente (MTLS)| Nivel alto de seguridad|
|HTTPS NOAUTH| HTTPS con con verficación de certificado |Nivel básico de seguridad|
|HTTP|HTTP en texto plano| Inseguro, no recomendado|

El modo de conexión se configura en la pestaña "Servidores Internos" de su servicio. El modo por defecto que utiliza la pasarela es HTTPS, es decir el más alto, este el nivel recomendado para ambientes en producción. La configruación del servidor que ofrece la API en su red interna deber corresponder al modo de conexión seleccionado.

Para modificar el modo de conexión, desde la ventana de configuración de su servicio, seleccione "Servidors Internos" y en la sección 'TIPO DE CONEXIÓN..' seleccione el tipo de conexión que desea usar.  


### Comunicación entre Pasarela y API de datos usando HTTPS ###

Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno a HTTPS NOAUTH. La pasarela verifica el certificado TLS de la API por lo que es necesario agregar el certificado a la lista de certificados TLS internos.  El certificado debe ser el mismo que utiliza el servidor donde reside la API de datos. Por ejemplo para un servidor Nginx se debe subir el certificado definido en la propiedad 'ssl_certificate':

```
  ssl_certificate /etc/ssl/certs/api-autofirmado.crt;
 ```
Desde la ventana de configuración, seleccione "Servidors Internos", presione el botón agregar y suba el certificado correspondiente.  Si su API no utiliza autorización mutua TLS, la configuración esta terminada.   

### Comunicación entre Pasarela y API de datos usando HTTPS con MTLS ###

El sistema de información requiere un certificado de cliente autorizado, la Pasarela de seguridad Proveedor enviará automaticamente su certificado interno. Si el certificado no está autorizado se generará este error:
```
{"type":"Server.ServerProxy.SslAuthenticationFailed","message":"Server certificate is not trusted",
```

Debe instalarse un nuevo certificado, que este autorizado. Para esto, seleccione Menu Principal, Parámetros del Sistema, Certificado TLS Interno, generar petición de certificado. Ingrese el sujeto que desea usar en su nuevo certificado: CN=servicios.local,OU=Ministerio xxx,O=Gobierno de El Salvador,C=SV. 

La petición/soliciud de certificado debe ser firmada por la Autoridad Certificadora que esta usando el servidor web, como se explica a continuación.


### Firmar petición de Pasarela Proveedor para API con MTLS ###

La pasarela de seguridad del Proveedor necesita obtener un certificado autorizado; para esto desde la pasarela se debe generar la solicitud de certificado (Menu Principal, Parámetros del Sistema, Certificado TLS Interno, generar petición de certificado). El siguiente comando firma la solicitud 'pasarela.p10' y genera el archivo 'pasarela-autorizada.crt' que debe ser instalado en la pasarela (Menu Principal, Parámetros del Sistema, Certificado TLS Interno, Importar).  

```
openssl x509 -req -days 365 -in /var/tmp/pasarela.p10 -CA /etc/ssl/certs/api-ac.crt -CAkey /etc/ssl/private/api-ac.key -set_serial 01 -out /var/tmp/pasarela-autorizada.crt;
```
Este comando debe ser ejecutado en el servidor donde recide la API .
