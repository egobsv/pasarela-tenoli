## Estadísticas de Uso

La plataforma genera información estadística de uso de la pasarela sobre las variables del sistema operativo (memoria, disco duro, etc) y sobre los mensajes procesados. La descripción de las variables, posibles parametros de consulta y estructura de los mensajes de respuesta estan definidos en [esta página](https://github.com/nordic-institute/X-Road/blob/6.22.0/doc/OperationalMonitoring/Protocols/pr-opmon_x-road_operational_monitoring_protocol_Y-1096-2.md)

Para consultar estas estadísticas, es necesario crear un servicio(sub sistema) que actuará como compuerta de autorización para ver las estadisitcas de nuestra pasarela.  

El servicio unicamente esta disponible usando mensajes SOAP.
```
~# curl -k -E /var/tmp/consumidor-api.crt --key /var/tmp/consumidor-api.key  -d @/var/tmp/consulta-estadisiticas.xml --header "Content-Type: text/xml" -X POST http://localhost --output /var/tmp/respuesta.multipart
```
