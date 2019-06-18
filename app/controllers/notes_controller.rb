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
    note = current_user.notes.build(note_params)
    note.save
    p "========================"
    msg = 'New Note Added'
    check_reminder(msg, note, params[:do_remind], params[:remind_date][0])
  end

  def edit; end

  def update
    return false unless @note.update(note_params)

    msg = 'Note Updated'
    check_reminder(msg, @note, params[:do_remind], params[:remind_date][0])
  end

  def destroy
    return false unless @note.update(is_active: false)

    @msg = 'Note Deleted'
    load_data
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
    return false unless @note.update(is_important: params[:status])

    @msg = 'Note Importance Changed'
    load_data
  end

  def load_data
    @notes = current_user.my_notes
    if current_user.do_autosave
      render json: { note_id: @note.id }
    else
      @flag = '1'
      respond_to do |format|
        format.js { render 'notes/load_data.js.erb' }
      end
    end
  end

  def check_reminder(msg, note, do_remind, reminder_date)
    @msg = msg
    set_reminder(note.title, note.id, reminder_date) if do_remind == 'true'
    load_data
  end

  private

  def note_params
    params.require(:note).permit(:title, :description, :tag_list, :is_important)
  end

  def my_note
    @note = Note.find_by(id: params[:id])
  end

  def set_reminder(note_title, note_id, reminder_date)
    new_calendar_event(note_title, 'Event Created From NoteMe', reminder_date)
    reminder = current_user.reminders.build(
      note_id: note_id,
      remind_date: reminder_date
    )
    @msg = reminder.save ? 'Note and reminder saved' : 'Note saved, Reminder not saved'
  end
end
