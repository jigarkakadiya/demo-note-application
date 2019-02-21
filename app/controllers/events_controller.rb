class EventsController < ApplicationController
  def index
    #render plain: current_user.access_token.inspect
    #return
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(
      :code => current_user.refresh_token,
      :access_token => current_user.access_token,
      :expires_in => current_user.expires_at
    )

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
    rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
  end

  def new
  end

  def create
    #render plain: params.inspect
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(
      :code => current_user.refresh_token,
      :access_token => current_user.access_token,
      :expires_in => current_user.expires_at
    )

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: params[:event_start_date]),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: params[:event_end_date]),
      summary: params[:event_name]
    })
    service.insert_event("primary", event)
    render plain: "Event Added"
  end

  def change

  end

  def update

  end
  def calendar_events
=begin
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @calendar_list = service.list_calendar_lists
  rescue Google::Apis::AuthorizationError
    response = client.refresh!

    session[:authorization] = session[:authorization].merge(response)

    retry
=end
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(
      :code => current_user.refresh_token,
      :access_token => current_user.access_token,
      :expires_in => current_user.expires_at
    )

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    @event_list = service.list_events(params[:calendar_id])
  end

  private
  def client_options
    {
      client_id: "958955211976-g1gvcl9c7a7hhqt1golsp4q56bcjhc0u.apps.googleusercontent.com",
      client_secret: "DBx45uuwyHqCwHF3rZDU1WoB",
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: application_dashboard_url
    }
  end
end
