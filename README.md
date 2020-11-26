
## Instalación de Pasarela Tenoli

  Esta son las instrucciones para instalar la pasarela de Tenoli en su institución y poder formar parte de la plataforma distribuida de intercambio de información del Gobierno de El Salvador. Puede [conocer más sobre Tenoli en esta página](http://tenoli.gobiernoelectronico.gob.sv/).

 En este sitio encontrará guías para:
 1. [Conceptos Generales](conceptos-generales.md)
 1. [Instalar Pasarela](https://github.com/egobsv/pasarela-tenoli/wiki/Intalacion-Pasarela-Tenoli)
 2. [Consumir Servicio en ambiente de pruebas](cliente-consumo.md)
 3. [Crear API para entregar datos](crear_API_con_MTLS.md)
 4. [Publicar Servicio de datos en ambiente de pruebas](cliente-proveedor.md)
 5. [Evaluar desempeño, mejorar uso de RAM](desempeño.md)
 6. [Revisar Estadísticas de Uso](estadísticas/README.md)
  
**Requisitos:** 
* Ubuntu Bionic LTS o superior, [Debian 10](instalar-deb.sh) (necesita sustituir java11 por java8), [RHEL7/Centos7](instalar-rpm.sh).  
* Al menos 3GB Ram y 3GB de disco duro.  
* Dos direcciones IP: una para acceso a la red interna y otra para acceso a Internet.
* La IP de acceso público debe tener disponibles los siguientes puertos TCP (ver lista de Acceso):  
	 - Ingreso: 5500, 5577
	- Egreso: 5500, 5577, 4001, 80, 443 
	
* Lista de Acceso servicios centrales: Completar formulario de registro para recibir IPs 	
* Lista de Acceso clientes: IPs de insituciones que consuman los servicios de esta pasarela.

* La IP interna debe tener disponibles los siguientes puertos TCP:  
Ingreso: 80,443

* Para administrar su pasarela el sistema usa el puerto 4000 que debe estar disponible solo en la red local.

El equipo puede ser una maquina virtual o un servidor físico dedicado.  

**1. Instalar**

1. Antes de iniciar debe obtener los archivos de instalación, puede hacerlo con los siguientes comandos:
```sh
~# cd /opt/
~# wget https://github.com/egobsv/pasarela-tenoli/archive/master.zip
~# apt-get install -y unzip;
~# unzip master.zip;mv pasarela-tenoli-master tenoli;
```
2. Descargue los paquetes DEB (o RPMS)y guárdelos en su servidor usando los siguientes comandos:
```sh
~# cd /opt/tenoli/;
~# wget -r -nH -np --cut-dirs=1 http://tenoli.gobiernoelectronico.gob.sv/paquetes/deb/;
```
3. Modifique las direcciones IP y define el usuario y contraseña de administrador de la pasarela dentro del archivo ss-respuestas.txt. La instalación creará el usuario automáticamente (instalar-deb.sh),  una vez realizados los cambios ejecute el script de instalación:
```sh
~# nano ss-respuestas.txt;
~# chmod +x instalar-deb.sh
~# ./instalar-deb.sh
```

**2. Inicializar Pasarela**

Conéctese a la pasarela desde el navegador https://[DIRECCION IP]:4000/

Use las credenciales que creó en el paso anterior, el sistema ingresa y pide el ancla de configuración inicial.

El ancla de  configuración inicial contiene los parámetros de inicio definidos en el servidor central.  Esta información, guardada en un archivo XML conocido como ‘ancla de configuración’ para ambiente de [Pruebas](SV-PRUEBAS_Ancla_de_configuración_2019-11-28.xml)  o [Poducción](SV-PRODUCCION_Ancla_de_configuración_2019_12_12.xml).
  
Descargue, guarde este archivo en su máquina y luego regrese a la página de configuración de su pasarela para que pueda importar el ancla de configuración inicial. Una vez importada el ancla parecerá un formulario que debe ser completado de la siguiente forma:

* Asegurese que elegir GOB en el campo Clase de Miembro. 

* En el campo Código de Miembro, ingrese el [código presupuestario](códigos-instituciones.md) asignado por el Ministerio de Hacienda a su institución, por ejemplo, el código del Ministerio de Hacienda es 111300400. Al ingresar el código, el sistema mostrará automáticamente el nombre de su institución. 

* En le campo Código del Servidor de Seguridad, ingrese el identificador de su pasarela, este valor será parte del certificado electrónico que identificará a su pasarela. El identificador depende del [código de su institución](códigos-instituciones.md) Por ejemplo: MIHSV111300400-01. 

* Ingrese el número PIN de acceso para proteger los certificados del servidor. Este PIN será requerido para administrar los certificados de su pasarela.

* Presionar 'Continuar', para guardar los cambios y entrar por primera vez.  
  
* Una vez dentro, desde el Menú Principal, seleccionar 'Parámetros del Sistema' en la sección 'Servicios de Sellado de Tiempo', presione el botón 'agregar' para usar el servicio de sellado de tiempo.

* En la parte superior de la pantalla tendrá una aviso que le indica que necesita ingresar su número PIN, presiónelo e ingrese el código que ingreso en la pantalla inicial. Edite el archivo '/etc/xroad/autologin' en su servidor con su nuevo PIN para que evitar ingresarlo manulamente.
  
**3. Registrar Pasarela**

Para terminar, es necesario registrar nuestra pasarela para que pueda unirse a la red Tenoli.  
Este registro se hace a través de certificados de Firma Electrónica Simple  y es aprobado desde la Autoridad Certificadora de Presidencia.  
Para iniciar este registro ingrese a la sección de 'Llaves y certificados' y genere las solicitudes de registro siguientes usando los datos de su institución.

* Certificado de Autorización - Este certificado será utilizado por las instituciones miembro de la red Tenoli para identificar a su pasarela. Para crearlo debe presionar el botón 'Generar Llave', luego el botón 'Generar CSR', y en el recuadro a continuación:
		Seleccione 'Autorizar' en el menu Uso, luego la autoridad "certificadora raíz" y finalmente elija Formato CSR "PEM" antes de presionar el botón OK para avanzar al siguiente paso. En el segundo recuadro, ingrese el nombre de su institución y el nombre de dominio que usara su pasarela, ej: tenoli.minec.gob.sv 

* Certificado de Firma - Este certificado será utilizado por su pasarela para firmar mensajes. Para crearlo debe presionar el botón 'Generar Llave', luego el botón 'Generar CSR', y en el recuadro a continuación:
		Seleccione 'Firmar' en el menu Uso, la autoridad "certificadora raíz" y elija y Formato CSR "PEM" antes de presionar el botón OK para avanzar al siguiente paso. En el segundo recuadro, ingrese el nombre de su institución.


El sistema genera y descarga automáticamente las peticiones de certificados a su máquina, estas deberán ser enviadas al correo dquijada @ presidencia.gob.sv. Una vez procesadas las solicitudes, se entregarán los certificados para que pueda finalizar el registro.

**4. Finalizar Registro**

Usando los certificados que recibió, ingrese a su pasarela, seleccione la opción 'Llaves y certificados', presione el botón 'importar certificado' y luego importe sus certificados de Firma y Autorización.  

Al importar el certificado de Firma se habilita el botón 'activar', asegurese de marcarlo como "Activo".
  
Con el certificado de Identidad, una vez importado, deberá realizarse el registro de su pasarela. Seleccione el certificado Identidad, y presione el botón 'Activar' y luego 'Registrar'. El estado del certificado cambia a 'registro en progreso'. 

Una vez la administración central de Tenoli autorice el registro, el estado cambiará a 'registrado'  
  
Es importante verificar que la página de diagnóstico, desde el menú principal, no muestre errores. Si aparece algún  error (indicador rojo) revise el Firewall de su red, es probable que se este bloqueando alguna conexión.  
  
Con esto queda activada nuestra pasarela dentro de la red Tenoli. 
Si necesita instalar varios nodos en alta disponibilidad puede leer la [documentación oficial](https://github.com/nordic-institute/X-Road/blob/develop/doc/Manuals/LoadBalancing/ig-xlb_x-road_external_load_balancer_installation_guide.md).


## Licencia ##

Este trabajo esta cubierto dentro de la estrategia de desarrollo de servicios de Gobierno Electrónico del Gobierno de El Salvador y como tal es una obra de valor público sujeto a los lineamientos de la Política de Datos Abiertos y la licencia [CC-BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.es).  
