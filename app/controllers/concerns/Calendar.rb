module Calendar
  
  def my_calendar
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(authorization_data)
    calendar = Google::Apis::CalendarV3::CalendarService.new
    calendar.authorization = client
    calendar
  end

  def get_event(summary, description, start_date, end_date = '')
    end_date = end_date == '' ? start_date : end_date
    event = Google::Apis::CalendarV3::Event.new(
              start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_date.to_datetime.rfc3339),
              end: Google::Apis::CalendarV3::EventDateTime.new(date_time: end_date.to_datetime.rfc3339),
              summary: summary,
              description: description
            )
    event
  end

  def get_calendar_events(calendar_id)
    calendar = get_calendar
    event_list = calendar.list_events(calendar_id)
    event_list
  end

  def new_calendar_event(event)
    calendar = my_calendar
    calendar.insert_event(:primary, event)
    calendar_events(:primary)
  end

  private

  def client_options
    {
      client_id: '958955211976-g1gvcl9c7a7hhqt1golsp4q56bcjhc0u.apps.googleusercontent.com',
      client_secret: 'DBx45uuwyHqCwHF3rZDU1WoB',
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: events_url
    }
  end

  def authorization_data
    authorization = ({
      code: current_user.refresh_token,
      access_token: current_user.access_token,
      expires_in: current_user.expires_at
    })
    authorization
  end
end
