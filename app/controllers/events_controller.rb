require ‘google/apis/calendar_v3’
class ExampleController < ApplicationController
  def get_calendars
    # Initialize Google Calendar API
    service = Google::Apis::CalendarV3::CalendarService.new
    # Use google keys to authorize
    service.authorization = google_secret.to_authorization
    # Request for a new aceess token just incase it expired
    service.authorization.refresh!
    # Get a list of calendars
    calendar_list = service.list_calendar_lists.items
    calendar_list.each do |calendar|
      puts calendar
    end
  end
  private
    def google_secret
      Google::APIClient::ClientSecrets.new(
        { "web" =>
          { "access_token" => @user.google_token,
            "refresh_token" => @user.google_refresh_token,
            "client_id" => 958955211976-g1gvcl9c7a7hhqt1golsp4q56bcjhc0u.apps.googleusercontent.com,
            "client_secret" => DBx45uuwyHqCwHF3rZDU1WoB,
          }
        }
      )
    end
end
