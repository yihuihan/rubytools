# encoding: UTF-8

require 'net/http'
require 'cgi'
require 'nokogiri'
require 'json'

@url="http://www.beijingaqifeed.com/shanghaiaqi/shanghaiairrss.xml"
@retry_time=3

def log(msg)
	time_string=Time.now.strftime("%Y-%m-%d %H:%M:%S")
	puts "#{time_string}: #{msg}"
end

def request
	uri=URI(@url)
	response=nil
	

	@retry_time.times do
		response=Net::HTTP.get_response(uri)
		if response.code=='200'
			log("[inf]: response code is #{response.code}");
			break;	
		end
	end
	
	if response.code!='200'	
		log("[err]: response code is #{response.code}");
		log("[err]: failed to get data")
		return;
	end

	# log("[dbg]: response body is #{response.body}")

	doc=Nokogiri::XML(response.body)

	doc.search("item").each do |item|
		fields=item.children		
		conc=fields.search("Conc")
		aqi=fields.search("AQI")
		desc=fields.search("Desc")
		readingDateTime=fields.search("ReadingDateTime")
		puts conc
		puts aqi
		puts desc
		puts readingDateTime
		puts ""
	end	
end

request
