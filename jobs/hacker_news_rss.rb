require 'net/http'
require 'net/https'
require 'xmlsimple'

SCHEDULER.every '1m', :first_in => 0 do |job|
	uri = URI.parse("https://news.ycombinator.com/rss")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	response = http.request(Net::HTTP::Get.new(uri.path))
	items = XmlSimple.xml_in(response.body, { 'ForceArray' => false })['channel']['item']
	
	items.map! do |item|
		{name: item["title"], link: item["link"]}
	end

	send_event('hacker_news_rss', {feeds: items})
end