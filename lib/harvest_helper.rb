require 'harvested'

HARVEST_SUBDOMAIN = ''
HARVEST_EMAIL = ''
HARVEST_PASSWORD = ''
# Interval for jobs to schedule
HARVEST_JOB_INTERVAL = '15m'
# Delay for first run of jobs
HARVEST_JOB_FIRST_IN = 0

class HarvestHelper
	attr_reader :client

	def initialize
		@client = Harvest.hardy_client(HARVEST_SUBDOMAIN, HARVEST_EMAIL, HARVEST_PASSWORD)
	end	

	# Get hours on a specified date
	#
	# @param date [Date] Date on which we want to get
	# @return total hours on that date
	def hours_on(date)
		# List of TimeEntry objects
		entries = client.time.all(date.to_time)
		return hours_from_entries(entries)
	end

	# Get hours in a specified week
    #
    # @param date [Date] Date within a week which we want to get
    # @return total hours in that week
    def hours_in_week(date)
    	start_date = date.beginning_of_week
    	end_date = date.end_of_week
    	return hours_between(start_date, end_date)
    end

    # Get hours in a specified month
    #
    # @param date [Date] Date within a month which we want to get
    # @return total hours in that month
    def hours_in_month(date)
		start_date = date.beginning_of_month
    	end_date = date.end_of_month
    	return hours_between(start_date, end_date)
    end
    

	# Get hours between a given timeframe
	#
	# @param start_date [Date] start_date on which we want to get
	# @param end_date [Date] end_date on which we want to get
	# @return total hours on that timeframe
	def hours_between(start_date, end_date)
		# List of TimeEntry objects
		entries = client.reports.time_by_user(user_id(), start_date, end_date)
		return hours_from_entries(entries)
	end

	# Get total hours from a list of TimeEntry objects
	#
	# @param time_entries [] list of TimeEntry objects
	# @return total hours from those entries
	def hours_from_entries(time_entries)
		hours = 0
		for entry in time_entries
			hours += entry.hours
		end
		return hours.round(2)
	end

	# Get id of the user by comparing HARVEST_EMAIL
	#
	# @return the user id if found or -1 if not found.
	def user_id()
		# @TODO: looks for a better way to get user id
		users = client.users.all()
		for user in users
			if user.email == HARVEST_EMAIL
				return user.id
			end
		end
		return -1
	end
end
