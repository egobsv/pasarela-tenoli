## Estadísticas de Uso

La plataforma genera información estadística de uso de la pasarela sobre:
 * Historico de mensajes procesados por cada sub-sistema/servicio administrado por la pasarela
 * Desempeño de servicios publicados (tiempos de respuesta, tamaño de los mensajes, etc) 
 
 La descripción de las variables, posibles parametros de consulta y estructura de los mensajes de respuesta estan definidos en [esta página](https://github.com/nordic-institute/X-Road/blob/6.22.0/doc/OperationalMonitoring/Protocols/pr-opmon_x-road_operational_monitoring_protocol_Y-1096-2.md)

Para consultar el historico de mensajes de un subsistema, se debe utilizar el mecanismo HTTP definido en el servicio/sub-sistema, es decir HTTPS con autenticación (valor por defecto). El servicio únicamente está disponible usando mensajes SOAP, a continuación se muestra un ejemplo de econsulta.

```
~# curl -k -E /var/tmp/consumidor-api.crt --key /var/tmp/consumidor-api.key \
        -d @/var/tmp/ejemplo-consulta-historico.xml --header "Content-Type: text/xml" \
         -X POST http://localhost --output /var/tmp/respuesta.multipart
```
La respuesta de la consulta es un mensaje SOAP con adjuntos binarios; el script consulta.py realiza la consulta sobre estadisitcas de los últimos 30 días, procesa la respuesta y guarda los registros json en un archivo. Las variables del script se pueden ajsutar para diferentes servicios y rangos del reporte. 

```
 ~# python3 consulta.py

 ~# cat  estadisticas-2019-12-02.json
 [....]
       "messageId": "sv-test-5b319806-e1d5-4769-9a7c-e9ca03c9bf0c",
        "messageProtocolVersion": "1",
        "monitoringDataTs": 1574722196,
        "requestAttachmentCount": 0,
        "requestInTs": 1574722194483,
        "requestOutTs": 1574722194665,
        "requestRestSize": 221,
        "responseAttachmentCount": 0,
        "responseInTs": 1574722195965,
        "responseOutTs": 1574722196112,
        "responseRestSize": 627,
        "securityServerType": "Client",
        "serviceCode": "consulta-pruebas",
    }
 [...]   
```

Al usar certificados autofirmados dentro del script de python, el sistema muestra este mensaje de precaución:
```
/usr/lib/python3/dist-packages/urllib3/connectionpool.py:860: InsecureRequestWarning: Unverified HTTPS request is being made. Adding certificate verification is strongly advised. See: https://urllib3.readthedocs.io/en/latest/advanced-usage.html#ssl-warnings
```
Una forma de eliminar este mensaje es exporatando la siguiente variable
```
~# export PYTHONWARNINGS="ignore:Unverified HTTPS request"
```

Para consultar el estadístico de desempeño de un sub-sistema puede editarse y usarse la consulta SOAP de ejemplo usnado el siguiente comando:
```
 curl -k -E /var/tmp/consumidor-api.crt --key /var/tmp/consumidor-api.key \
        -d @/var/tmp/ejemplo-consulta-desempeno.xml --header "Content-Type: text/xml" \
         -X POST http://localhost --output /var/tmp/respuesta.xml
```
La respuesta es un mensaje SOAP con las estadísticas de desempeño de la APIs que estan publicadas a través del sub-sistema.

