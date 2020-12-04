## Publicación de Servicios ##

**Diagrama General**

RED TENOLI ---> SS--->SI

* SS: Pasarela de seguridad con sub-sistema que entrega datos.  Ejm: "sv-test/GOB/1001/api-pruebas"
* SI: Sistema de información interno que produce datos.

Es responsabilidad de cada institución implementar los mecanismos que garanticen la seguridad de las comunicaciones entre sistemas en su red local; esto incluye la comunicacion entre su Pasarela de Seguridad y su Sistema de Información.  

La Pasarela de Seguriad ofrece tres modos de conexión hacia sistemas en su red local:

|Modo|Protocolo| Seguridad|
|-----|------|------|
|HTTPS| HTTPS con certificado validado y autenticación de cliente (MTLS)| Nivel alto de seguridad|
|HTTPS NOAUTH| HTTPS con certificado validado |Nivel básico de seguridad|
|HTTP|HTTP en texto plano| Inseguro, no recomendado|

El modo de conexión se configura en la pestaña "Servidores Internos" de su servicio. El modo por defecto que utiliza la pasarela es HTTPS, es decir el más alto, este el nivel recomendado para ambientes en producción. La configruación del servidor que ofrece la API en su red interna deber corresponder al modo de conexión seleccionado.

Para modificar el modo de conexión, desde la ventana de configuración de su servicio, seleccione "Servidors Internos" y en la sección 'TIPO DE CONEXIÓN..' seleccione el tipo de conexión que desea usar. Tal como lo muestra la siguiente imagen 

<p align="center">
  <img width="600"  src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/tipoConeccion.PNG">
</p>

### Conexión entre Pasarela y API interna en modo HTTPS NOAUTH ###

Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno a HTTPS NOAUTH. 

<p align="center">
  <img width="600"  src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/noAuth.PNG">
</p>

La pasarela verifica el certificado TLS de la API por lo que es necesario agregar el certificado a la lista de certificados TLS internos.  Si el certificado no está autorizado se generará este error:
```
{"type":"Server.ServerProxy.SslAuthenticationFailed","message":"Server certificate is not trusted",
```

El certificado debe ser el mismo que utiliza el servidor donde reside la API de datos. Por ejemplo para un servidor Nginx se debe subir el certificado definido en la propiedad 'ssl_certificate':

```
  ssl_certificate /etc/ssl/certs/api-autofirmado.crt;
 ```
Desde la ventana de configuración, seleccione "Servidors Internos", presione el botón agregar y suba el certificado correspondiente.  Si su API no utiliza autorización mutua TLS, la configuración esta terminada.   

<p align="center">
  <img width="600"  src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/importCert.PNG">
</p>


### Comunicación entre Pasarela y API de datos usando HTTPS con MTLS ###

Al igual que en el modo HTTPS NOAUTH, este modo de conexión require agregar el certificado TLS del servidor. Adicionalemente, la API esta configurada para autenticar al cliente usando certificados ([ver ejemplo](crear_API_con_MTLS.md)). Si se trata de llamar la API sin presentar un certificado de cliente,  el servidor respondera con un error:

```
No required SSL certificate was sent
```

La pasarela de seguridad Proveedor enviará automaticamente su certificado interno para autenticarse ante la API, este certificado es deconocido para el servidor donde reside la API, por lo que fallara la conexión. 

Debe instalarse en la Pasarela un nuevo certificado, que este autorizado por el Servidor que ofrece la API. Para esto, seleccione Menu Principal, Parámetros del Sistema, Certificado TLS Interno, generar petición de certificado. Ingrese el sujeto que desea usar en su nuevo certificado: CN=servicios.local,OU=Ministerio xxx,O=Gobierno de El Salvador,C=SV. 

La petición/soliciud de certificado debe ser firmada por la Autoridad Certificadora que esta usando el servidor web, como se explica a continuación.


### Firmar petición de Pasarela Proveedor para API con MTLS ###

La pasarela de seguridad del Proveedor necesita obtener un certificado autorizado; para esto desde la pasarela se debe generar la solicitud de certificado (Menu Principal, Parámetros del Sistema, Certificado TLS Interno, generar petición de certificado). 

<p align="center">
  <img width="600"  src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/generarPeticion.PNG">
</p>

El siguiente comando firma la solicitud 'pasarela.p10' y genera el archivo 'pasarela-autorizada.crt' que debe ser instalado en la pasarela (Menu Principal, Parámetros del Sistema, Certificado TLS Interno, Importar).  
<p align="center">
  <img width="600"  src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/importarCert.PNG">
</p>
```
openssl x509 -req -days 365 -in /var/tmp/pasarela.p10 -CA /etc/ssl/certs/api-ac.crt -CAkey /etc/ssl/private/api-ac.key -set_serial 01 -out /var/tmp/pasarela-autorizada.crt;
```
Este comando debe ser ejecutado en el servidor donde recide la API .
