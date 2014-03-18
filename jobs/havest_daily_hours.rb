require 'active_support/time'
require_relative '../lib/harvest_helper'

SCHEDULER.every HARVEST_JOB_INTERVAL, :first_in => HARVEST_JOB_FIRST_IN do |job|
	helper = HarvestHelper.new

	hours_today = helper.hours_on(Date.today)
	hours_yesterday = helper.hours_on(Date.yesterday)

	puts("Harvest today: #{hours_today}")
	puts("Harvest yesterday: #{hours_yesterday}")
	
	send_event('harvest_daily_hours', { current: hours_today, last: hours_yesterday })
end