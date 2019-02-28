# frozen_string_literal: true

# /usr/local/bin/elasticsearch
class NotesController < ApplicationController
  before_action :my_note, exept: %i[index new create]
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
    return false unless @note.save

    if current_user.do_autosave
      render json: { note_id: @note.id }
    else
      if params[:note][:do_remind] == true
        reminder_date = params[:note][:remind_date]
        event = get_event(
          params[:note][:title],
          'Event Created From NoteMe',
          reminder_date
        )
        new_calendar_event(event)

        reminder = Reminder.new(
          note_id: @note.id,
          user_id: current_user.id,
          remind_date: reminder_date
        )
        @msg = reminder.save ? 'Note and reminder saved' : 'Note saved, Reminder not saved'
      else
        @msg = 'New Note Added'
      end
      load_data
    end
  end

  def edit; end

  def update
    if @note.update(note_params)
      if current_user.do_autosave
        render json: { note_id: @note.id }
      else
        @msg = 'Note Updated'
        load_data
      end
    end
  end

  def destroy
    if @note.update(is_active: false)
      @msg = 'Note Deleted'
      load_data
    end
  end

  #
  ## custome functions
  #

  def search_note
    # @notes = Note.where("title LIKE :value or description LIKE :value and
    # is_active = true",{value: :params[:search]})
    content = params[:search]
    if content.nil? || content == ''
      @notes = current_user.my_notes
    else
      tagged_note = current_user.my_notes.tagged_with(content)
      searched_note = current_user.my_notes.search(content)
      @notes = tagged_note + searched_note
    end
  end

  def change_importance
    @note.update(is_important: params[:status])
    @msg = 'Note Importance Changed'
    load_data
  end

  def load_data
    @notes = current_user.my_notes
    unless current_user.do_autosave
      respond_to do |format|
        @flag = '1'
        format.js { render 'notes/load_data.js.erb' }
      end
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :description, :tag_list, :is_important)
  end

  def my_note
    @note = Note.find_by(id: params[:id])
  end
end
