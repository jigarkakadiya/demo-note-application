#/usr/local/bin/elasticsearch
class NotesController < ApplicationController
  def index
    @notes = Note.records
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
      @notes =  Note.records
    else
      taged_note = Note.tagged_with(content)
      searched_note = Note.search(content)
      @notes = taged_note + searched_note
    end
  end

  def change_importance
    @note = Note.find(params[:id])
    @note.update(is_important: params[:status])
    @notes = Note.records
  end

  def load_data
    @notes = Note.records
    if !current_user.do_autosave
      respond_to do |format|
        @notes = Note.records
        format.js { render 'notes/load_data.js.erb' }
      end #end of respond_to
    end #end of if
  end

  def invitation_email
    @note = Note.find(params[:id])
  end

  def check_email
    user_email = params[:user_email]
    @user = User.where("email = ?",user_email)
    if @user.empty? #user is not registered
      @user = User.invite!({:email => user_email,:name => current_user.name})
    end
    return
  end
  #custom function ends
  private
  def note_params
    params.require(:note).permit(:title,:description,:tag_list,:is_important)
  end
end
