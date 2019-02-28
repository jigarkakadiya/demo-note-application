# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :my_note
  before_action :paginate_comments, except: %i[new edit]
  before_action :my_comment, except: %i[index new create]

  def index; end

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
  end

  def edit; end

  def update
    @comment.update(comment_params)
  end

  def destroy
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:note_id, :description)
  end

  def my_note
    @note = Note.find(params[:note_id])
  end

  def paginate_comments
    @comments = @note.comments.paginate(page: params[:page], per_page: 5)
  end

  def my_comment
    @comment = Comment.find(params[:id])
  end
end
