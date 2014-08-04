require 'json'
require 'github_api'
require 'active_support/time'

# Github login
GITHUB_LOGIN = ''
# Github password
GITHUB_PASSWORD = ''
# Repo owner
GITHUB_OWNER = ''
# Repo name
GITHUB_REPO = ''
# Github client id
GITHUB_CLIENT_ID = ''
# Github client secret
GITHUB_CLIENT_SECRET = ''
# Interval for jobs to schedule
GITHUB_JOB_INTERVAL = '15m'
# Delay for first run of jobs
GITHUB_JOB_FIRST_IN = 0

class GithubHelper
    attr_reader :github

    def initialize
        @github = Github.new do |config|
                    config.client_id = GITHUB_CLIENT_ID
                    config.client_secret = GITHUB_CLIENT_SECRET
                    config.auto_pagination = true
                    config.basic_auth = "#{GITHUB_LOGIN}:#{GITHUB_PASSWORD}"
                end 
    end

    # Get commits on a specified date
    #
    # @param date [Date] Date on which we want to get
    # @return num of commits on that date
    def commits_on(date)
        start_date = date.beginning_of_day
        end_date = date.end_of_day
        return commits_between(start_date, end_date)
    end

    # Get commits in a specified week
    #
    # @param date [Date] Date within a week which we want to get
    # @return num of commits in that week
    def commits_in_week(date)
        start_date = date.beginning_of_week.beginning_of_day
        end_date = date.end_of_week.end_of_day
        return commits_between(start_date, end_date)
    end

    # Get commits in a specified month
    #
    # @param date [Date] Date within a month which we want to get
    # @return num of commits in that month
    def commits_in_month(date)
        start_date = date.beginning_of_month.beginning_of_day
        end_date = date.end_of_month.end_of_day
        return commits_between(start_date, end_date)
    end

    # Get num of commits between two nominated dates
    #
    # @param start_date [Date] Start Date on which we want to get
    # @param end_date [Date] End Date on which we want to get
    # @return num of commits between those dates
    def commits_between(start_date, end_date)
        puts("Commits since " << iso8601(start_date) << " until " << iso8601(end_date))
        commits = @github.repos.commits.list GITHUB_OWNER, GITHUB_REPO, :author => GITHUB_LOGIN, :since => iso8601(start_date), :until => iso8601(end_date)
        return commits
    end

    # Reference: https://github.com/pengwynn/octokit/blob/master/lib/octokit/client/commits.rb
    def iso8601(date)
        if date.respond_to?(:iso8601)
            date.utc.iso8601
        else
            date.strftime("%Y-%m-%dT%H:%M:%S%Z")
        end
    end
end

