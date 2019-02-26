class EventsController < ApplicationController
  require 'Calendar'
  include Calendar
  def index
    calendar = get_calendar
    @calendar_list = calendar.list_calendar_lists
  end

  def create
    calendar = get_calendar
    event = get_event(params[:event_name],params[:event_description],
      params[:event_start_date][0],params[:event_end_date][0])
    calendar.insert_event("primary", event)
    @event_list = get_calendar_events("primary")
    @calendar_id = "primary"
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
    #render plain: params.inspect
    #return
    event = get_event(params[:event_name],params[:event_description],
      params[:event_start_date][0],params[:event_end_date][0])
    @calendar_id = params[:calendar_id]
    @event_id = params[:event_id]
    calendar.update_event(@calendar_id,@event_id,event)
    calendar_events
    respond_to do |format|
      format.js { render 'calendar_events.js.erb' }
    end
  end

  def destroy
    calendar = get_calendar
    @calendar_id = params[:calendar_id]
    @event_id = params[:id]
    calendar.delete_event(@calendar_id,@event_id)
    calendar_events
    respond_to do |format|
      format.js { render "calendar_events.js.erb" }
    end
  end

  def calendar_events
    @calendar_id = params[:calendar_id]
    @event_list = get_calendar_events(@calendar_id)
  end
end
