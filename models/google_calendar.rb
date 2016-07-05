require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'pry'
require 'fileutils'
require 'dates_from_string'


OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials

class GoogleCalendar

  def self.authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
    client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(
      base_url: OOB_URI)
      puts "Open the following URL in the browser and enter the " +
        "resulting code after authorization"
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI)
    end
    credentials
  end

  
  # Initialize the API
  @service = Google::Apis::CalendarV3::CalendarService.new
  @service.client_options.application_name = APPLICATION_NAME
  @service.authorization = authorize

  # @calendar_id = 'primary'
  @calendar_id = 'flatironschool.com_15ii6if4tou9co9iido53p6cbs@group.calendar.google.com'
 

  def self.get_items(day)
    @day=day
    time(day)
    calendar_items
    cal_items.empty? ? "It looks like you have no upcoming events" : cal_items 
  end

  private

  def self.calendar_items
    # binding.pry
    @main = @service.list_events(
                                  @calendar_id,
                                 max_results: 10,
                                 single_events: true,
                                 order_by: 'startTime',
                                 time_max: "#{@max_time.iso8601}",
                                 time_min: "#{@min_time.iso8601}" ) #Time.now.iso8601
   # binding.pry
  end


  def self.cal_items
    "Upcoming events:"
      events = @main.items.map do |event|
      start = event.start.date || event.start.date_time
      # binding.pry
      if @day == 'today'
        time_only=start.strftime("%I:%M %p")
      event.location.nil? ? "<b>#{event.summary}</b> - #{time_only}" : "<b>#{event.summary}</b> - #{time_only} - Location: <i>#{event.location}</i>"
      else
        day_time=start.strftime("%a %I:%M %p")
      event.location.nil? ?  "<b>#{event.summary}</b> - (#{day_time}) ": "<b>#{event.summary}</b> - (#{day_time}) - Location: - <i>#{event.location}</i>" 
      end
    end
    events.join("\n")
  end

    def self.time(day)
     times = {'today' => 0, 'tomorrow' => 1, 'week' => 7}
     wanted_time = (Time.now + (times[day.downcase]*86400))
     max_time(wanted_time)
     day == 'tomorrow' ? min_time(wanted_time) : @min_time=Time.now
    end


   def self.max_time(wanted_time)
     @max_time = Time.local(wanted_time.year,wanted_time.month,wanted_time.day,23,59,59)
   end

   def self.min_time(wanted_time)
     @min_time = Time.local(wanted_time.year,wanted_time.month,wanted_time.day,00,00,00)
   end


   def self.add_event(details)
    #details => ['Ruby meetup','Flatiron School','July 3 6PM','July 3 9PM']

      event = Google::Apis::CalendarV3::Event.new(
        summary: details[0].to_s, #=> 'Ruby meetup'
        location: details[1].to_s, #=> 'Flatiron School'
        start: {
          date_time: Time.parse(details[2]).to_datetime.rfc3339.to_s, #'July 3 6PM'=> "2016-07-03T18:00:00-04:00"
          time_zone: 'America/New_York',
        },
        end: {
          date_time: Time.parse(details[3]).to_datetime.rfc3339.to_s ,#'July 3 6PM'=> "2016-07-03T21:00:00-04:00" 
          time_zone: 'America/New_York',
        }
      )
     result = @service.insert_event('primary', event)  
     #@service = Google::Apis::CalendarV3::CalendarService.new 
     
     "Event created successfully!\nUse the following link to edit the event on Google Calendar:\n#{result.html_link}"
    
  end

end

 
