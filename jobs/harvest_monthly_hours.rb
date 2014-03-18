require 'active_support/time'
require_relative '../lib/harvest_helper'

SCHEDULER.every HARVEST_JOB_INTERVAL, :first_in => HARVEST_JOB_FIRST_IN do |job|
	helper = HarvestHelper.new

	hours_this_month = helper.hours_in_month(Date.today)
	hours_last_month = helper.hours_in_month(Date.today.prev_month)
	
	puts("Harvest this month: #{hours_this_month}")
	puts("Harvest last month: #{hours_last_month}")

	send_event('harvest_monthly_hours', { current: hours_this_month, last: hours_last_month })
end