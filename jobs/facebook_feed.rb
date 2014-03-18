require 'rest-graph'

FB_USER_ID = ''
FB_ACCESS_TOKEN = ''

SCHEDULER.every '1m', :first_in => 0 do |job|
	rg = RestGraph.new(
		:access_token => FB_ACCESS_TOKEN,
		:log_method   => method(:puts),
		:auto_decode  => true
		)
	response = rg.get("#{FB_USER_ID}/home")
	feeds = response["data"]
	if feeds
		feeds.map! do |feed|
			type = feed["type"]
			from_id = feed["from"]["id"]
			avatar = "http://graph.facebook.com/#{from_id}/picture?type=square"
			username = feed["from"]["name"]
			message = ""
			description = ""

			types = ["photo", "video", "status", "checkin", "link", "question"]
			messages = { 
				"photo" => "name",
				"video" => "name",
				"status" => "message",
				"question" => "question",
				"link" => "name"
			}				
			descriptions = {
			 	"photo" => "liked a photo.",
				"video" => "liked a video.",
				"status" => "updated a status.",
				"checkin" => "checked in.",
				"question" => "asked a question.",
				"link" => "shared a link."
			}						 		
			
			if types.include?(type)
				if type == "checkin"
					message = feed["place"]["name"]
				else
					message = feed[messages[type]]
				end

				description = descriptions[type]
			elsif 
				message = ""
			end	

			if !message.nil? && message.length > 101
				message = "#{message[0..100]}..."
			end

			{ name: "#{username} #{description}", body: "#{message}", avatar: avatar}
		end
	end
	
	send_event('facebook_feed', { comments: feeds })
end
