## Gestión de Servicios

### 1. Conceptos ###


![Diagrama General - Fuente NIIS.org](diagrama-x-road.png)

[**Fuente: NIIS.org**.](https://www.niss.org/)



Conceptos generales de la plataforma nacional de interoperabildad.

**Proveedor de Servicio:** Un sistema de información conectado a la plataforma a través de un cliente/pasarela de seguridad que ofrece datos a clientes autorizados.

**Consumidor de Servicio:** Un sistema de información conectado a la plataforma a través de un cliente/pasarela de seguridad que consume datos como cliente autorizado.

**Cliente:** Un registro creado en la pasarela de seguridad que permite gesitonar autoizaciones para que un sistema de información conectado a la plataforma funcione como consumidor o proveedor de servicio.

**Miembro:**  Una organización o entidad afiliada, cada miembro controla uno o más clientes en la plataforma, que pueden operar como proveedor y / o consumidor de servicios.

**Servicios de Confianza:** Conjunto de servicios de gestion de certificados, firmas y sellos digitales que hacen posible el funcionamiento de la plataforma. Estos incluyen una Autoridad de Certificación, validación (OCSP) y Sellos de tiempo (TSA) y son administrados por Presidencia.

**Catálogo Central:** Indice central de miembros y sus clientes, disponible para todos los miembros activos de la red. El catálogo central también es reponsable de distibuir cambios en los servicios de confianza a toda la red.  

**Tenoli:** Es una instalación de X-Road, es la plataforma nacional de interoperabildad. Es un canal de comunicación estandarizado que proporciona una forma estándar de transferir información entre organizaciones y faciita la construcción servicios públicos integrados y seguros.


## 2. Modelo de Seguridad de Mensajes ##

1. El tunel de red local del consumidor (1) utiliza  un certificado autofirmado que debe ser instalado en la pasarela.  

<p align="center">
  <img width="689" src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/tenoli1.png">
</p>


2. El tunel TLS entre Pasarelas de Seguridad (2) utiliza los certificados frimados por la autoridad cetificadora de Presidencia.

<p align="center">
  <img width="689" src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/tenoli2.png">
</p>



3. El tunel de red local del proveedor (3) utiliza  un certificado autofirmado que debe ser instalado en la pasarela y debe estar autorizado por el servidor web que recibe la petición (Sistema Proveedor).  

<p align="center">
  <img width="689" src="https://raw.githubusercontent.com/egobsv/pasarela-tenoli/master/imagenes/tenoli3.png">
</p>

