import requests
import zlib
import json
from typing import Tuple
import xml.dom.minidom as minidom

def clean_whitespace(contents: str) -> str:
    """ Return the given string with all line breaks and spaces removed."""
    lines = [line.strip(" \r\n") for line in contents.split('\n')]
    return ''.join(lines)

def parse_multipart_response(response: requests.Response) -> Tuple:
    content_type_parts = response.headers.get("content-type").split(';')
    boundary = None
    for part in content_type_parts:
        part = part.strip()
        if part.startswith("boundary="):
            # Content-Type header can contain boundary="foo"
            part = part.replace('"', "")
            boundary = "--" + part.replace("boundary=", "")
            break
    contents = response.raw.read()
    mime_parts = []
    if boundary:
        # The response was a multipart message and the parts can be processed.
        for part in contents.split(boundary.encode('utf-8')):
            if part:
                mime_parts.append(part)
    return mime_parts, contents

def get_multipart_soap_and_record_count(
        response_xml_part: bytes) -> Tuple[bytes, int]:
    """ Return the SOAP part and the record count in the query data response.
    Expecting response_xml_part to be the first part of the MIME multipart response.
    """
    return _extract_operational_data_response_and_record_count(response_xml_part)

def _extract_operational_data_response_and_record_count(
        response_xml_part:bytes) -> Tuple[bytes, int]:
    response_xml = response_xml_part[response_xml_part.index(b"<?xml"):]
    dom = minidom.parseString(response_xml)
    record_count = _find_operational_data_response_record_count(dom)
    if record_count is None:
        raise Exception("The record count was not found in the operational data response")
    return (response_xml, _find_operational_data_response_record_count(dom))

def _find_operational_data_response_record_count(response_xml: minidom.Document) -> int:
    record_count = response_xml.documentElement.getElementsByTagName("om:recordsCount")
    if record_count:
        return int(record_count[0].firstChild.nodeValue)
    return None

def get_multipart_json_payload(gzipped_json_payload: bytes) -> dict:
    """ Return the gunzipped JSON payload of the query data response. """
    return json.loads(
            _decompress_gzipped_attachment(gzipped_json_payload).decode('utf-8'))

def get_json_payload_as_string(gzipped_json_payload: bytes) -> str:
    """ Return the gunzipped JSON payload of the query data response. """
    json_payload=json.loads(
            _decompress_gzipped_attachment(gzipped_json_payload).decode('utf-8'))
    return json.dumps(json_payload.get("records"),sort_keys=True, indent=4)

def _decompress_gzipped_attachment(attachment: bytes) -> bytes:
    headers = \
        b"\r\ncontent-type:application/gzip\r\n" \
        b"content-transfer-encoding: binary\r\n" \
        b"content-id: <operational-monitoring-data.json.gz>\r\n\r\n"

    gzipped_payload = attachment[len(headers):].rpartition(b'\r\n')[0]
    # From the manual of zlib:
    # 32 + (8 to 15): Uses the low 4 bits of the value as the window size logarithm,
    # and automatically accepts either the zlib or gzip format.
    # +8 to +15: The base-two logarithm of the window size.
    # The input must include a zlib header and trailer.
    decompressed_payload = zlib.decompress(gzipped_payload, 32 + 15)
    return decompressed_payload

def print_multipart_soap_and_record_count(
            soap_part: bytes, record_count: int, is_client: bool=True):
    print("Received the following SOAP response from the " \
            "security server of the %s: \n" % ("client" if is_client else "producer"))
    xml = minidom.parseString(clean_whitespace(soap_part.decode("utf-8")))
    print(xml.toprettyxml())
    print("The expected number of JSON records in the response payload: %d" % (
            record_count,))
