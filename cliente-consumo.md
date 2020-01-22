## Consumo de Datos ##

### 1. Autorización de Consumo de Servicio ###

*Comunicación entre sistemas de consumo y proveedor de datos*

Es responsabilidad del administrador de la **Pasarela de Seguridad Consumidor** solicitar acceso/autorización al servicio publicado en la **Pasarela de Seguridad Proveedor**. Para hacer pruebas está disponible el servicio **sv-test/GOB/1001/api-pruebas/consulta-pruebas** en el ambiente de pruebas de Tenoli. Para poder consumirlo es encesario registrar un cliente en su pasarela y solicitar acceso. Antes de continuar asegurese de completar este proceso. 

La comunicación no será posible hasta que el administrador proveedor agregue en su pasarela una regla para que su servicio de consulta pueda consumir los datos. Si no existe esa regla, el sistema responderá con un error similar al siguiente:

```
"type":"Server.ServerProxy.AccessDenied"","message":"Request is not allowed: SERVICE: ...
```

### 2. Autorización red local Consumidor ###

Para consumir un servicio desde la red interna, primero debe crearse el sub-sistema consumidor (vacío). Desde la ventana de configuración del sistema, en la pestaña "Servidores Internos" se debe definir el modo de conexión interno, por defecto es HTTPS con autenticación, la pasarela espera recibir un certificado autorizado en cada llamada, de lo contrario responde con el siguiente mensaje:
```
{"type":"Server.ClientProxy.SslAuthenticationFailed","message":"Client (SUBSYSTEM:SV/GOB/XXXX/XXXX) specifies HTTPS but did not supply TLS certificate"}
```

Para presentar un certificado autorizado es necesario crear y agregar un certificado interno usando los siguientes pasos:  
```
openssl req -x509 -nodes -sha256 -days 365 -newkey rsa:2048 -keyout consumidor-api.key -out consumidor-api.crt -subj "/C=SV/O=Gobierno de El Salvador/O=PRUEBAS/OU=CERTIFICADO AUTOFRIMADO/CN= Consumidor - API de Integración de datos"
```

Asegurase de subir e archivo consumidor-api.crt a la lista de certificados TLS internos desde el recuadro de configuración del servicio de consumo/ servidores internos. Luego pruebe el servicio usando los certificados que acaba de crear desde su sistema de información que consume datos o usando la siguiente linea de comandos:
```
curl -k -E consumidor-api.crt --key consumidor-api.key -X GET -H 'X-Road-Client: sv-test/GOB/XXXXXX/consulta' -i 'https://localhost/r1/sv-test/GOB/1001/api-pruebas/consulta-pruebas'
``` 
