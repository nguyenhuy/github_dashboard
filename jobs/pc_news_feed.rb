require 'net/http'
require 'rubygems'
require 'xmlsimple'

SCHEDULER.every '1m', :first_in => 0 do |job|
    url = 'http://www.pcworld.com/index.rss'
    xml_data = Net::HTTP.get_response(URI.parse(url)).body
    data = XmlSimple.xml_in(xml_data, { 'ForceArray' => false })['channel']
    feeds = data['item']

	if feeds
		feeds.map! do |feed|
			{ name: feed["title"], link: feed["link"]}
		end
	end

	send_event('pc_news_feed', { feeds: feeds })
end
