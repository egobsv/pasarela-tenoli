## Instalación de Pasarela Tenoli

  
**Requisitos:** Ubuntu Xenial LTS / Debian 8 o superior. 2GB Ram, 3GB HD.  
El equipo puede ser una maquina virtual o un servidor físico dedicado.  
  
Dos direcciones IP: una para acceso a la red interna y otra para acceso a Internet.  
La IP de acceso público debe tener disponibles los siguientes puertos TCP:  
Ingreso: 2080,5500, 5577, 9011  
Egreso: 80,443,4001,4050-4055, 5500, 5577  
  
La IP de interna debe tener disponibles los siguientes puertos TCP:  
Ingreso: 80,443
**Inicializar Pasarela**

La configuración inicial necesita los parámetros de inicio definidos en el servidor central.  
Esta información, guardada en un archivo XML conocido como ‘ancla de configuración’, está [disponible aqui.](http://190.5.135.94/instalar/TENOLI-Ancla-de-Configuracion-20170307.xml)  
  
Antes de continuar descargue y guarde este archivo en su maquina.

Conectese a la pasarela desde el navegador https://[mipasarela].[institucion].gob.sv:4000/

Importar ancla de configuración inicial.

Ingresar el código presupuestario de la institución, por ejemplo 4100 para MINEC.

Asignar nombre de dominio público que se asigno durante la instalación Ej. [mipasarela].[institucion].gob.sv

Asignar el número PIN de acceso para proteger los certificados del servidor. Este PIN será requerido para administrar los certificados de su pasarela.

Presionar 'Continuar', con esto se inicializa la plataforma y entramos por primera vez.  
  
Una vez dentro, desde el Menú Principal, seleccionar 'Parámetros del Sistema', agregar servicio de sellado de tiempo.

  
**6. Registrar Pasarela**

En este último paso se solicitara el registro de nuestra pasarela para que pueda unirse a la red Tenoli.  
Este registro se hace a través de certificados de firma electrónica simple y es aprobado desde el servidor central.  
Para iniciar este registro ingrese a la sección de 'Llaves y certificados' y genere las solicitudes de registro siguientes usando los datos de su institución.

_Solicitud de Certificado de Identidad_  
Generar llave, generar petición de certificado con el siguiente sujeto:  
Formato: C=SV,O=Gobierno de El Salvador,OU=[institucion],CN=[mipasarela].[institucion].gob.sv,serialNumber=SV/[mipasarela]/GOB  
  
Ejemplo: C=SV,O=Gobierno de El Salvador,OU=MINEC,CN=pasarela.minec.gob.sv,serialNumber=SV/pasarela.minec.gob.sv/GOB

_Solicitud de certificado de Firma_  
Generar llave, generar petición de certificado con el siguiente sujeto:  
Formato: C=SV,O=Gobierno de El Salvador,OU=[institucion],CN=[codigo presupesto],serialNumber=SV/[mipasarela]/GOB  
  
Ejemplo: C=SV,O=Gobierno de El Salvador,OU=MINEC,CN=4100,serialNumber=SV/pasarela.minec.gob.sv/GOB

Las solicitudes de certificado deberán ser enviadas a las Secretaria Técnica al correo dquijada @ presidencia.gob.sv. Una vez  
procesadas las solicitudes, se entregarán los certificados correspondientes que deberán ser instalados usando el botón 'importar certificado'.  
  
Con el certificado de Identidad, una vez importado, deberá realizarse el registro de nuestra pasarela. Seleccione el certificado Identidad, y presione el botón 'Activar' y luego 'Registrar'. El estado del certificado cambia 'registro en progreso'. Una vez la administración central de Tenoli autorice el registro, el estado cambiara a 'registrado'  
  
Es importante verificar que la pagina de diagnóstico no muestre errores. Si la pagina de diagnostico muestra alguna error (indicador rojo) revise firewall de su red, es probable que el se este boqueando alguna conexión.  
  
Con esto queda activada nuestra pasarela dentro de la red Tenoli. El siguiente paso es [agregar servicios](servicios.html) para consumir o compartir datos con otras instituciones.

## Licencia

Este trabajo esta cubierto dentro de la estrategia de desarrollo de servicios de Gobierno Electrónico del Gobierno de El Salvador y como tal es una obra de valor público sujeto a los lineamientos de la Política de Datos Abiertos y la licencia [CC-BY-SA](https://creativecommons.org/licenses/by-sa/3.0/deed.es).  