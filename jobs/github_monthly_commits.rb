require 'active_support/time'
require_relative '../lib/github_helper'

SCHEDULER.every GITHUB_JOB_INTERVAL, :first_in => GITHUB_JOB_FIRST_IN do |job|
	helper = GithubHelper.new

	this_month_commits_count = helper.commits_in_month(Date.today).count
	last_month_commits_count = helper.commits_in_month(Date.today.prev_month).count	

	puts("This month: #{this_month_commits_count}")
	puts("Last month: #{last_month_commits_count}")
  	
  	send_event('github_monthly_commits', { current: this_month_commits_count, last: last_month_commits_count })
end