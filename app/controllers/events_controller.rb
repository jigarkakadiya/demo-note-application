# frozen_string_literal: true

class EventsController < ApplicationController
  include Calendar

  def index
    if !current_user.access_token.present? || !current_user.refresh_token.present?
      redirect_to message_events_path
      return
    end
    calendar = my_calendar
    @calendar_list = calendar.list_calendar_lists
  end

  def create
    event = get_event(event_params)
    new_calendar_event(event)
  end

  def edit
    calendar = my_calendar
    @calendar_id = params[:calendar_id]
    @id = params[:id]
    @event = calendar.get_event(@calendar_id, @id)
  end

  def update
    calendar = my_calendar
    event = get_event(event_params)
    calendar.update_event(params[:calendar_id], params[:event_id], event)
    calendar_events(params[:calendar_id])
  end

  def destroy
    calendar = my_calendar
    calendar.delete_event(params[:calendar_id], params[:id])
    calendar_events(params[:calendar_id])
  end

  def show
    calendar_events(params[:calendar_id])
  end

  def calendar_permission
    client = Signet::OAuth2::Client.new(client_options)
    redirect_to client.authorization_uri.to_s
  end

  private

  def event_params
    params(:event).require(:name, :description, :start_date[0], :end_date[0])
  end

  def calendar_events(calendar_id)
    @calendar_id = calendar_id
    calendar = my_calendar
    calendar.list_acls(calendar_id).items.each do |cal|
      @role = cal.role
    end
    @event_list = get_calendar_events(calendar_id)
    respond_to do |format|
      format.js { render 'show.js.erb' }
    end
  end
end
