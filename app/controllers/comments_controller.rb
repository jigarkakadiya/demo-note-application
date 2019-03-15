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
    @comment = current_user.comments.build(comment_params)
    return false if !@comment.save

    respond_to do |format|
      format.js { render 'comments/load_data.js.erb' }
    end
  end

  def edit; end

  def update
    return false if !@comment.update(comment_params)

    respond_to do |format|
      format.js { render 'comments/load_data.js.erb' }
    end
  end

  def destroy
    return false if !@comment.destroy

    respond_to do |format|
      format.js { render 'comments/load_data.js.erb' }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:note_id, :description)
  end

  def my_note
    @note = Note.find_by(id: params[:note_id])
  end

  def paginate_comments
    @comments = @note.comments.paginate(page: params[:page], per_page: 5)
  end

  def my_comment
    @comment = Comment.find_by(id: params[:id])
  end
end
