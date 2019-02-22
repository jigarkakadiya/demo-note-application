class EventsController < ApplicationController
  def index
    calendar = get_calendar
    @calendar_list = calendar.list_calendar_lists
  end

  def create
    calendar = get_calendar
    event = get_event
    calendar.insert_event("primary", event)
    @event_list = get_calendar_events("primary")
    respond_to do |format|
      format.js { render 'calendar_events.js.erb' }
    end
  end

  def edit
    calendar = get_calendar
    @calendar_id = params[:calendar_id]
    @id = params[:id]
    @event = calendar.get_event(@calendar_id,@id)
  end

  def update
    calendar = get_calendar
    event = get_event
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]
    calendar.update_event(@calendar_id,@event_id,event)
    render plain: "Event Updated"
  end

  def destroy
    calendar = get_calendar
    @calendar_id = params[:calendar_id]
    @event_id = params[:id]
    calendar.delete_event(@calendar_id,@event_id)
    render plain: "Event Deleted"
  end

  def calendar_events
    @event_list = get_calendar_events(params[:calendar_id])
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

  def get_event
    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date: params[:event_start_date]),
      end: Google::Apis::CalendarV3::EventDateTime.new(date: params[:event_end_date]),
      summary: params[:event_name],
      description: params[:event_description]
    })
    return event
  end

  def get_calendar_events(calendar_id)
    calendar = get_calendar
    event_list = calendar.list_events(calendar_id)
    return event_list
  end
end
