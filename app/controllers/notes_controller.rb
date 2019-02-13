#/usr/local/bin/elasticsearch
class NotesController < ApplicationController
  def index
    @notes = current_user.notes
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
        load_data
      end
    end #end of @note.save
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
        load_data
      end #end of if autosave on
    end #end of @note.update
  end

  def destroy
    @note = Note.find(params[:id])
    if @note.update(is_active: false)
      load_data
    end #end of if @dept.delete
  end

  #custome functions starts
  def search_note
    #@notes = Note.where("title LIKE :value or description LIKE :value and is_active = true",{value: :params[:search]})
    content = params[:search]
    if content.nil? || content == ""
      @notes =  current_user.notes
    else
      taged_note = Note.tagged_with(content)
      searched_note = Note.search(content)
      @notes = taged_note + searched_note
    end
  end

  def change_importance
    @note = Note.find(params[:id])
    @note.update(is_important: params[:status])
    @notes = current_user.notes
  end

  def load_data
    @notes = current_user.notes
    if !current_user.do_autosave
      respond_to do |format|
        format.js { render 'notes/load_data.js.erb' }
      end #end of respond_to
    end #end of if
  end

  #custom function ends
  private
  def note_params
    params.require(:note).permit(:title,:description,:tag_list,:is_important)
  end
end
