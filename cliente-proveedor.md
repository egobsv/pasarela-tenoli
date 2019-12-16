## Publicación de Servicios

**Diagrama General**

SI1 -----> SS1 ---- TUNEL TLS/ RED PÚBLICA --- SS2--->SI2

* SI1: Sistema de información que consume datos  
* SS1: Pasarela de seguridad con sub-sistema de consumo "sv-test/GOB/XXXX/consulta"
* SS2: Pasarela de seguridad con sub-sistema que entrega datos
* SI2: Sistema de información que produce datos. "sv-test/GOB/1001/api-pruebas"

El servicio ***sv-test/GOB/XXXX/consulta***, es un cliente debidamente registrado, donde ***XXXXX*** es el código del miembro que desea consumir los datos.   

**Comunicación entre Pasarela y API de datos**
Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno, por defecto es HTTPS con autenticación; por lo que es necesario agregar el certificado a la lista de certificados TLS internos.  El certificado debe ser el mismo que utiliza el servidor donde reside la API de datos (SI2). Por ejemplo para un servidor Nginx se debe subir el certificado definido en la propiedad 'ssl_certificate':

```
  ssl_certificate /etc/ssl/certs/api-autofirmado.crt;
 ```
 Si su API no utiliza autorización mutua TLS, la configuración esta lista.   

**Comunicación entre Pasarela y API de datos usando MTLS**

El sistema de información requiere un certificado de cliente autorizado, la Pasarela de seguridad Proveedor enviará automaticamente su certificado interno. Si el certificado no está autorizado se generará este error:
```
{"type":"Server.ServerProxy.SslAuthenticationFailed","message":"Server certificate is not trusted",
```

Debe instalarse un nuevo certificado, que este autorizado. Para esto, seleccione Menu Principal, Parámetros del Sistema, Certificado TLS Interno, generar petición de certificado. Ingrese el sujeto que desea usar en su nuevo certificado: CN=servicios.local,OU=Ministerio xxx,O=Gobierno de El Salvador,C=SV. 

La petición/soliciud de certificado debe ser firmada por la Autoridad Certificadora que esta usando el servidor web, como se explica en la seccion de [firmar solicitud de pasarela de seguridad](crear_API_con_MTLS.md)

El certificado certificado firmado por la autoridad certificadora correspondiente debe ser instalado en la pasarela, para esto seleccione Menu Principal, Parámetros del Sistema, Certificado TLS Interno, improtar.

En este punto la configuración esta terminada y estamos listos para realizar purebas. 


