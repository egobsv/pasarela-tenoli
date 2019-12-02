#!/usr/bin/env python3
#
import random
import string
import time
import requests
import common

##EDITAR VARIABLES ANTES DE CONSULTAR ESTADISTICAS 
var_host="localhost"
var_client_system = "consulta"
var_client_code = "1001"
var_client_server_code="MIHSV1001-02"
var_request_template ="/var/tmp/plantilla-consulta-historico.xml"
var_respuesta="/var/tmp/estadisticas-"
var_certificado_cliente="/var/tmp/consumidor-api.crt"
var_llave_cliente="/var/tmp/consumidor-api.key"
#60*60*24*30 --> un mes
var_periodo= 2592000 
var_peticion_soap="_"
var_message_id="_"

def generar_id() -> str:
    return ''.join([
        random.choice(string.ascii_letters + string.digits) for _ in range(32)])

#Valor en timempo Unix/Epoch
var_fin = round(time.time())
var_inicio = var_fin-var_periodo

def llenar_plantilla() -> str:
    var_message_id=generar_id()
    with open(var_request_template) as template_file:
        request_template = template_file.read()
        return request_template.format(
                message_id_placeholder=var_message_id,
		client_system=var_client_system,
		client_code=var_client_code,
		client_server_code=var_client_server_code,
		tiempo_inicio=var_inicio,tiempo_fin=var_fin)

def post_xml_request(data: str, get_raw_stream: bool=False) -> requests.Response:
    return requests.post(
            "https://" + var_host, data=data.encode("utf-8"),
            cert=(var_certificado_cliente,var_llave_cliente),verify=False,
            headers={"Content-type": "text/xml; charset=utf-8"},
            stream=get_raw_stream)

var_peticion_soap=llenar_plantilla()
#print("\nGenerated message ID %s for X-Road request" % (var_message_id))
#print("Generated the following X-Road request: \n")
#print(var_peticion_soap)

response = post_xml_request( var_peticion_soap, get_raw_stream=True)
mime_parts, raw_response = common.parse_multipart_response(response)
if not mime_parts:
           print("\n\n**-La peticion no pudo ser procesada, por favor revise los valores usados \n")
           print(var_peticion_soap)
           raise Exception("Expected a multipart response, received a plain SOAP response")

fecha=time.strftime("%Y-%m-%d", time.gmtime())

json_payload = common.get_json_payload_as_string(mime_parts[1])
var_respuesta=var_respuesta+fecha+".json"
archivo = open(var_respuesta,"w+") 
archivo.write(json_payload);
archivo.close();
print("Se guardo la respuesta en "+var_respuesta) 
