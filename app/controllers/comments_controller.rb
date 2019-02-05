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
    @note = Note.find(params[:note_id])
    @comments = @note.comments.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
    @comment = Comment.find(params[:id])
    @note = Note.find(params[:note_id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
    @note = Note.find(params[:note_id])
    @comments = @note.comments.paginate(:page => params[:page], :per_page => 5)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @note = Note.find(params[:note_id])
    @comments = @note.comments.paginate(:page => params[:page], :per_page => 5)
  end
  private
  def comment_params
    params.require(:comment).permit(:note_id,:description)
  end
end
