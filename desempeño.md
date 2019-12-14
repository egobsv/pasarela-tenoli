## Configuración de Memoria

La pasarela de conexión es una aplicación java y su desempeño depende de la cantidad de memoria disponible en el sistema. 
Por defecto los valores de memoria son los siguientes:

|PROXY_PARAMS|SIGNER_PARAMS|
|---|--|
|-Xms100m -Xmx512m|-Xmx50m |

Estos valores pueden ser incrementados según se sugiere a continuación:

|Memoria Disponible|PROXY_PARAMS|SIGNER_PARAMS|
|:------:|:------:|:-------:|
|4G | -Xms200m -Xmx512m|	-Xms50m -Xmx100m|
|8G |-Xms512m -Xmx2g | -Xms50m -Xmx150m |
|16G | -Xms2g -Xmx8g | -Xms50m -Xmx200m |
|32G	| -Xms2g -Xmx16g | -Xms50m -Xmx200m |



Para modificar la cantidad de memoria diponible para Java, dendtro de su servidor debe crearse el archivo /etc/xroad/services/local.conf con los valores correspondientes. Por ejemplo:

```
PROXY_PARAMS="$PROXY_PARAMS -Xms200m -Xmx512m"
SIGNER_PARAMS="$SIGNER_PARAMS -Xms50m -Xmx100m "
```

Una vez guadado el archivo debe reiniciar el servicio:
```
service xroad-proxy restart
service xroad-signer restart
```

Puede vefirficar los cambios con el siguiente comando:
```
~# ps aux | grep proxy
xroad      778      Ssl  10:12   1:42 /etc/alternatives/jre_1.8.0_openjdk/bin/java -Xms100m -Xmx512m ....
```
