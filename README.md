## Instalación de Pasarela Tenoli

  Esta son las instrucciones para instalar la pasarela de Tenoli en su institución. Puede [conocer más sobre Tenoli en esta página](http://tenoli.gobiernoelectronico.gob.sv/).
  
**Requisitos:** 
* Ubuntu Xenial LTS / Debian 8 o superior. 
* Al menos 2GB Ram y 3GB de disco duro.  
* Dos direcciones IP: una para acceso a la red interna y otra para acceso a Internet.
* La IP de acceso público debe tener disponibles los siguientes puertos TCP:  
	 - Ingreso: 2080,5500, 5577, 9011  
	- Egreso: 80,443,4001,4050-4055, 5500, 5577  
* La IP de interna debe tener disponibles los siguientes puertos TCP:  
Ingreso: 80,443

El equipo puede ser una maquina virtual o un servidor físico dedicado.  
   
**Descargar Archivos**
Antes de iniciar debe obtener los archivos de instalacion, puede hacerlo con los siguientes comandos:
```
~# cd /opt/
~# wget https://github.com/egobsv/pasarela-tenoli/archive/master.zip
~# unzip master.zip
~# chmod +x instalar.sh
~# ./instalar.sh
```
**Inicializar Pasarela**

Conéctese a la pasarela desde el navegador https://[mipasarela].[institucion].gob.sv:4000/

Use las credenciales que creó en el paso anterior, el sistema ingresa y pide el ancla de configuración inicial.
El ancla de  configuración inicial contiene los parámetros de inicio definidos en el servidor central.  Esta información, guardada en un archivo XML conocido como ‘ancla de configuración’, está [disponible aquí.](http://190.5.135.94/instalar/TENOLI-Ancla-de-Configuracion-20170307.xml)  
  
Descargue, guarde este archivo en su máquina y luego regrese a la página de configuración de su pasarela para que pueda importar el ancla de configuración inicial.

* Ingresar el código presupuestario asignado por el Ministerio de Hacienda a su institución, por ejemplo, para MINED el código es 4100.

* Ingrese nombre de dominio público que se asigno durante la instalación Ej. [mipasarela].[institucion].gob.sv

* Ingrese el número PIN de acceso para proteger los certificados del servidor. Este PIN será requerido para administrar los certificados de su pasarela.

* Presionar 'Continuar', para guardar los cambios y entrar por primera vez.  
  
* Una vez dentro, desde el Menú Principal, seleccionar 'Parámetros del Sistema', agregue el servicio de sellado de tiempo.

* En la parte superior de la pantalla tendrá una aviso que le indica que necesita ingresar su número PIN, presiónelo e ingrese el código que ingreso en la pantalla inicial.
  
**6. Registrar Pasarela**

Para terminar, es necesario registrar nuestra pasarela para que pueda unirse a la red Tenoli.  
Este registro se hace a través de certificados de Firma Electrónica Simple  y es aprobado desde la Autoridad Certificadora de SETEPLAN.  
Para iniciar este registro ingrese a la sección de 'Llaves y certificados' y genere las solicitudes de registro siguientes usando los datos de su institución.

* Certificado de Autorización - Este certificado será utilizado por las instituciones miembro de la red Tenoli para identificar a su pasarela. Para crearlo debe presionar el botón 'Generar Llave', luego el botón 'Generar Petición de Certificado', y en el recuadro a continuación:
seleccione 'autorizar', en el campo sujeto ingrese un valor en el siguiente formato: C=SV,O=Gobierno de El Salvador,OU=[institución],CN=tenoli.[institución].gob.sv,serialNumber=SV/tenoli.[institucion].gob.sv/GOB  

 Ejemplo: C=SV,O=Gobierno de El Salvador,OU=MINEC,CN=tenoli.[institución].gob.sv,serialNumber=SV/tenoli.[institución].gob.sv/GOB


* Certificado de Firma - Este certificado será utilizado por su pasarela para firmar mensajes. Para crearlo debe presionar el botón 'Generar Llave', luego el botón 'Generar Petición de Certificado', y en el recuadro a continuación:
seleccione 'Firma', en el campo sujeto ingrese un valor en el siguiente formato: C=SV,O=Gobierno de El Salvador,OU=[institución],CN=[código presupuesto],serialNumber=SV/tenoli.[institución].gob.sv/GOB  
  
Ejemplo: C=SV,O=Gobierno de El Salvador,OU=MINEC,CN=4100,serialNumber=SV/tenoli.minec.gob.sv/GOB

El sistema genera y descarga automáticamente las peticiones de certificados a su maquina, estas deberán ser enviadas a SETEPLAN al correo dquijada @ presidencia.gob.sv. Una vez  
procesadas las solicitudes, se entregarán los certificados para que pueda finalizar el registro.

**Finalizar Registro**

Usando los certificados que recibió de SETEPLAN, ingrese a su pasarela, seleccione la opcion 'Llaves y certificados', presione el botón 'importar certificado' y luego importe su certificado de Autorización y Firma.  
  
Con el certificado de Identidad, una vez importado, deberá realizarse el registro de nuestra pasarela. Seleccione el certificado Identidad, y presione el botón 'Activar' y luego 'Registrar'. El estado del certificado cambia 'registro en progreso'. 

Una vez la administración central de Tenoli autorice el registro, el estado cambiara a 'registrado'  
  
Es importante verificar que la página de diagnóstico, desde el menú principal, no muestre errores. Si aparece algún  error (indicador rojo) revise el Firewall de su red, es probable que se este boqueando alguna conexión.  
  
Con esto queda activada nuestra pasarela dentro de la red Tenoli. El siguiente paso es [agregar servicios](servicios.html) para consumir o compartir datos con otras instituciones.

## Licencia

Este trabajo esta cubierto dentro de la estrategia de desarrollo de servicios de Gobierno Electrónico del Gobierno de El Salvador y como tal es una obra de valor público sujeto a los lineamientos de la Política de Datos Abiertos y la licencia [CC-BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.es).  