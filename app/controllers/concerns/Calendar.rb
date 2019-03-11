# frozen_string_literal: true

module Calendar
  def my_calendar
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(authorization_data)
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = client
    calendar
  end

  def get_event(summary, description, start_date, end_date)
    event = Google::Apis::CalendarV3::Event.new(
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_date.to_datetime.rfc3339),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: end_date.to_datetime.rfc3339),
      summary: summary,
      description: description
    )
    event
  end

  def get_calendar_events(calendar_id)
    calendar = my_calendar
    event_list = calendar.list_events(calendar_id)
    event_list
  end

  def new_calendar_event(summary, description, start_date, end_date = '')
    end_date = end_date == '' ? start_date : end_date
    event = get_event(summary, description, start_date, end_date)
    calendar = my_calendar
    calendar.insert_event(:primary, event)
  end

  private

  def client_options
    {
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET'],
      authorization_uri: ENV['AUTHORIZE_URL'],
      token_credential_uri: ENV['TOCKEN_CREDENTIAL_URL'],
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: events_url
    }
  end

  def authorization_data
    authorization = {
      code: current_user.refresh_token,
      access_token: current_user.access_token,
      expires_in: current_user.expires_at
    }
    authorization
  end
end
