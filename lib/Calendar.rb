module Calendar
  extend ActiveSupport::Concern

  def get_calendar
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(
      :code => current_user.refresh_token,
      :access_token => current_user.access_token,
      :expires_in => current_user.expires_at
    )
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = client
    return calendar
  end

  def get_event(summary,description,start_date,end_date)
    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_date.to_datetime.rfc3339),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: end_date.to_datetime.rfc3339),
      summary: summary,
      description: description
    })
    return event
  end

  def get_calendar_events(calendar_id)
    calendar = get_calendar
    event_list = calendar.list_events(calendar_id)
    return event_list
  end

  private
  def client_options
    {
      client_id: "958955211976-g1gvcl9c7a7hhqt1golsp4q56bcjhc0u.apps.googleusercontent.com",
      client_secret: "DBx45uuwyHqCwHF3rZDU1WoB",
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: events_url
    }
  end
end
