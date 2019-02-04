class CommentsController < ApplicationController
  def index
    @note = Note.find(params[:note_id])
    @comments = @note.comments.paginate(:page => params[:page], :per_page => 5)
  end
  def new
    @comment = Comment.new
    @note = Note.find(params[:note_id])
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  def edit
    @comment = Comment.find(params[:id])
    @note = Note.find(params[:note_id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    @notes = Note.where("is_active = ?",true)
    @comments = Comment.all
  end

  def destroy
    @comment = Comment.find(params[:id])
    respond_to do |format|
      if @comment.destroy
        @notes = Note.where("is_active = true")
        format.html { redirect_to action:'index', notice: 'Note Updated' }
        format.js
        format.json { render json: @notes, status: :updated, location: @notes }
      else
        format.html { render action: :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end #end of if @dept.delete
    end
  end
  private
  def comment_params
    params.require(:comment).permit(:note_id,:description)
  end
end
