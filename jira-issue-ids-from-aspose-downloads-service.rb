require 'net/https'
require 'uri'
require 'nokogiri'
require 'byebug'
require 'nori'

# Create the http object
url = "https://downloads.asposeptyltd.com/admin/DownloadService.asmx"
uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true


data = <<-EOF
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetIsssues xmlns="http://tempuri.org/">
      <downloadLink>https://downloads.aspose.com/words/net/new-releases/aspose.words-for-.net-17.1.0/</downloadLink>
      <APPID>568daf23278349e497185ace2863009a</APPID>
      <APPSecret>a3c724ed3f7840db9b283398f03f79e3</APPSecret>
    </GetIsssues>
  </soap:Body>
</soap:Envelope>
EOF


headers = {
  'Content-Type' => 'text/xml; charset=utf-8',
  'SOAPAction' => "http://tempuri.org/GetIsssues"
}

result= http.post(uri.path, data, headers)


parser = Nori.new

parsed_res = parser.parse(result.body)

issue_keys = parsed_res["soap:Envelope"]["soap:Body"]["GetIsssuesResponse"]["GetIsssuesResult"]["IssueKeys"]



puts issue_keys
