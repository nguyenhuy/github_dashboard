require 'active_support/time'
require_relative '../lib/github_helper'

SCHEDULER.every GITHUB_JOB_INTERVAL, :first_in => GITHUB_JOB_FIRST_IN do |job|
	helper = GithubHelper.new

	today_commits_count = helper.commits_on(Date.today).count
	yesterday_commits_count = helper.commits_on(Date.yesterday).count

	puts("Github today: #{today_commits_count}")
	puts("Github yesterday: #{yesterday_commits_count}")

	send_event('github_daily_commits', { current: today_commits_count, last: yesterday_commits_count} )
end