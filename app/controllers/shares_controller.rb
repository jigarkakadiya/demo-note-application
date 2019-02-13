class SharesController < ApplicationController
  def index
    #@shared_notes_by_me = current_user.shared_notes
    @shared_notes_by_me = current_user.notes_shared_by_me
    @shared_notes_with_me = current_user.notes_shared_with_me
  end

  def new
    @note = Note.find(params[:note_id])
    @share = Share.new
  end

  def create
    user_email = params[:share][:email]
    @user = User.where("email = ?",user_email).first
    if @user.nil? #user is not registered
    #  @user = User.invite!({:email => user_email,:name => current_user.name})
    end
    @share = Share.new(share_data)
    @share.shared_by = current_user.id
    if @share.save
      @flag = 'Y'
    else
      @flag = 'N'
    end
  end

  private
  def share_data
    params.require(:share).permit(:note_id,:permission_id,:email)
  end
end
