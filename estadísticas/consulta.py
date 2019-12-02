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
var_request_template ="/var/tmp/plantilla-consulta-estadisticas.xml"
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
print("terminado") 
