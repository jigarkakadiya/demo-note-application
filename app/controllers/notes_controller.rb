#/usr/local/bin/elasticsearch
class NotesController < ApplicationController
  def index
    @notes = Note.records
    @comments = Comment.all
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)
    @note.user_id = current_user.id
    @note.save
    @notes = Note.records
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    respond_to do |format|
      if @note.update(note_params)
        @notes = Note.where("is_active = true")
        format.html { redirect_to action:'index', notice: 'Note Updated' }
        format.js
        format.json { render json: @notes, status: :updated, location: @notes }
      else
        format.html { render action: :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end #end of if @dept.update
    end
  end

  def destroy
    @note = Note.find(params[:id])
    respond_to do |format|
      if @note.update(is_active: false)
        @notes = Note.records
        format.html { redirect_to action:'index', notice: 'Note Deleted' }
        format.js
        format.json { render json: @notes, status: :updated, location: @notes }
      else
        format.html { render action: :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end #end of if @dept.delete
    end
  end

  def show
  end
  #custome functions starts
  def search_note
    #@notes = Note.where("title LIKE ? or description LIKE ? and is_active = ?","#{params[:search]}%","#{params[:search]}%",true)
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

  #custom function ends
  private
  def note_params
    params.require(:note).permit(:title,:description,:tag_list,:is_important)
  end
end
