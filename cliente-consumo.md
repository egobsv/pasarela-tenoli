## Consumo de Datos ##

**Nota**: La plataforma X-ROAD llama Clientes y Subsistemas a las API y Enpoints. 


Tanto la institución que consume como la que ofrece datos administran su propia Pasarela de Seguridad con una API/Cliente disponible para realizar el intercambio. Es responsabilidad del administrador de la API **Consumidor de Servicio** solicitar acceso/autorización para usar API **Proveedor de Servicio** que se desea consumir. 


### 1. Crear Cliente/API local de consumidor ###

La API de consumo es un Cliente vacío, para crearlo desde el menú principal de la pasarela seleccione: 

Cliente de Servidor de Seguridad, Agregar Cliente

<p align="center">
  <img width="689" height="578" src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/agregarCliente.PNG">
</p>

Seleccione Cliente de Lista Global, Buscar (sin ningún valor) y seleccione el primer valor de la lista y dar clic en "ok"

<p align="center">
  <img width="689" height="578" src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/seleccionarCliente.PNG">
</p>


El detalle del proceso esta disponible en las [instrucciones de creación de cliente de la pasarela](https://github.com/nordic-institute/X-Road/blob/develop/doc/Manuals/ug-ss_x-road_6_security_server_user_guide.md#4-security-server-clients).

Esta API se usará para solicitar acceso a los datos que deseamos consumir desde un sistema interno.

```
|Sistema Interno que solicita datos|---->|Pasarela/API de Consumidor|
   |
   |
|RED TENOLI|
   |
   |
|Pasarela/API de Proveedor|---->|Sistema Interno que ofrece Datos
```

Ejemplo llamada para solicitar datos:
```
curl -k -X GET -H 'X-Road-Client: NOMPRE_API_LOCAL' -i 'https://1.2.3.4/r1/NOMBRE_API_PROVEEDOR'
``` 

Donde 1.2.3.4 es la IP de nuestra pasarela. Es posible hacer esta llamada desde la misma pasarela usando 'localhost'  

### 2. Comunicación interna a API local de consumidor ###

Por defecto, la pasarela únicamente responde a llamadas que incluyan un certificado autorizado (Mutual TLS/HTTPS con autenticación); esto evita que clientes no autorizados dentro de su red consuman este servicio.

En la configuración de su API/Cliente de consumo, desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno, por defecto es HTTPS con autenticación. La pasarela espera recibir un certificado autorizado en cada llamada, de lo contrario responde con el siguiente mensaje:
```
{"type":"Server.ClientProxy.SslAuthenticationFailed",
"message":"Client (SUBSYSTEM:SV/GOB/XXXX/XXXX) specifies HTTPS but did not supply TLS certificate"}
```

Para presentar un certificado autorizado es necesario crear y agregar un certificado interno que puede ser autofirmado:  
```
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout consumidor-api.key -out consumidor-api.crt 
-subj "/C=SV/O=Gobierno de El Salvador/O=PRUEBAS/OU=CERTIFICADO AUTOFRIMADO/CN= Consumidor - API de Integración de datos"
```

Asegurase de subir el archivo consumidor-api.crt a la lista de certificados TLS internos desde el recuadro de configuración de 'Servidores Internos' del servicio en su pasarela.

**Puede cambiar el modo de conexión a HTTPS NO AUTH o HTTP para evitar usar certificados desde su red interna, pero esto dará acceso libre a su servicio dentro de su red**


### 3. Autorización de Consumo de API remota ###
*Comunicación entre API/Cliente local de consumo y API/Cliente remoto proveedor de datos*

Antes  de poder consumir un Cliente/API publicado en una pasarela externa, es necesario obtener la autorización del administrador respectivo. 
La comunicación no será posible hasta que el administrador proveedor agregue en su pasarela una regla para que su API/Cliente de consulta pueda consumir los datos. Si no existe esa regla de acceso en la pasarela remota, el sistema responderá con un error similar al siguiente:

```
"type":"Server.ServerProxy.AccessDenied"","message":"Request is not allowed: SERVICE: ...
```
Una vez el responsable del servicio que se desea consumir agregue la regla, usted estará listo para empezar a consumirlo. Para hacer pruebas puede solicitar acceso al Cliente/API **sv-test/GOB/1001/api-pruebas/consulta-pruebas** en el ambiente de pruebas de Tenoli.

### 4. Consumo de Datos ###

Una vez autorizado, podemos invocar nuestra API de consumo desde la red local. La llamada local esta protegida con MTLS, por lo que debe usar el certificado y llave que creados en el paso 2:
```
curl -k -E consumidor-api.crt --key consumidor-api.key -X GET -H 'X-Road-Client: sv-test/GOB/XXXXXX/NOMBRE_API_LOCAL' 
-i 'https://localhost/r1/sv-test/GOB/1001/api-pruebas/consulta-pruebas'
``` 
