#/usr/local/bin/elasticsearch
class NotesController < ApplicationController
  require 'Calendar'
  include Calendar
  def index
    @notes = current_user.my_notes
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    if @note.save
      if current_user.do_autosave
        render :json => { note_id: @note.id }
      else
        if params[:note][:do_remind] == true
          #render plain: "In if"
          reminder_date = params[:note][:remind_date]
          calendar = get_calendar
          event = get_event(params[:note][:title],"Event Created From NoteMe",reminder_date,reminder_date)
          calendar.insert_event("primary", event)

          reminder = Reminder.new
          reminder.note_id = @note.id
          reminder.user_id = current_user.id
          reminder.remind_date = reminder_date
          if reminder.save
            @msg = "Note saved with reminder in Google Calendar"
          else
            @msg = "Note saved without reminder in Google Calendar"
          end
        else
          #render plain: "In else"
          @msg = "New Note Added"
        end
        load_data
      end
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update(note_params)
      if current_user.do_autosave
        render :json => { note_id: @note.id }
      else
        @msg = "Note Updated"
        load_data
      end
    end
  end

  def destroy
    @note = Note.find(params[:id])
    if @note.update(is_active: false)
      @msg = "Note Deleted"
      load_data
    end
  end

  #custome functions starts
  def search_note
    #@notes = Note.where("title LIKE :value or description LIKE :value and is_active = true",{value: :params[:search]})
    content = params[:search]
    if content.nil? || content == ""
      @notes =  current_user.my_notes
    else
      tagged_note = current_user.my_notes.tagged_with(content).where("is_active = true")
      searched_note = current_user.my_notes.search(content).where("is_active = true")
      @notes = tagged_note + searched_note
    end
  end

  def change_importance
    @note = Note.find(params[:id])
    @note.update(is_important: params[:status])
    @msg = "Note Importance Changed"
    load_data
  end

  def load_data
    @notes = current_user.my_notes
    if !current_user.do_autosave
      respond_to do |format|
        @flag = '1'
        format.js { render 'notes/load_data.js.erb' }
      end
    end
  end

  #custom function ends
  private
  def note_params
    params.require(:note).permit(:title,:description,:tag_list,:is_important)
  end
end
