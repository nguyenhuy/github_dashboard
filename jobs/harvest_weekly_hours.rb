require 'active_support/time'
require_relative '../lib/harvest_helper'

SCHEDULER.every HARVEST_JOB_INTERVAL, :first_in => HARVEST_JOB_FIRST_IN do |job|
	helper = HarvestHelper.new

	hours_this_week = helper.hours_in_week(Date.today)
	hours_last_week = helper.hours_in_week(Date.today.prev_week)
	
	puts("Harvest this week: #{hours_this_week}")
	puts("Harvest last week: #{hours_last_week}")
	
	send_event('harvest_weekly_hours', { current: hours_this_week, last: hours_last_week })
end