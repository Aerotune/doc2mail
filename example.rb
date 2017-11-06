require './lib/doc2mail'

certificate = File.read("path/to/certificate.pke")

ws = Doc2Mail::WebService.new(certificate, :test)
#ws = Doc2Mail::WebService.new(certificate, :production)

username = "Dogndata\\super"
meta_information = Doc2Mail::MetaInformation.new
meta_information.documenttype = "documenttype here" # Test
meta_information.destination = "EBOKSKMDPRINT"
meta_information.title = "Bue's besked til Henrik"
meta_information.receivertype = "CPR"
meta_information.receiver = "111111118"
meta_information.documentid = "0"
meta_information.AttPNummer = ""
# NB: PDF must be in exact A4 standing format!
filepath = '/path/to/my_letter.pdf'
attachment_filepaths = []

response_is_delivery_possible = ws.delivery_possible? username, meta_information
Doc2Mail::ResponseParser
response_upload_file = ws.upload username, meta_information, filepath, attachment_filepaths
