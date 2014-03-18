require 'active_support/time'
require_relative '../lib/github_helper'

SCHEDULER.every GITHUB_JOB_INTERVAL, :first_in => GITHUB_JOB_FIRST_IN do |job|
	helper = GithubHelper.new
	
	this_week_commits_count = helper.commits_in_week(Date.today).count
	last_week_commits_count = helper.commits_in_week(Date.today.prev_week).count

	puts("This week: #{this_week_commits_count}")
	puts("Last week: #{last_week_commits_count}")
		
  	send_event('github_weekly_commits', { current: this_week_commits_count, last: last_week_commits_count})
end