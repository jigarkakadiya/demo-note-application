class SharesController < ApplicationController
  def index
    #@shared_notes_by_me = current_user.shared_notes
    #@shared_notes_by_me = current_user.notes_shared_by_me.uniq
    @shared_notes_with_me = current_user.notes_shared_with_me    
    #render plain: @shared_notes_with_me.inspect
  end

  def new
    @note = Note.find(params[:note_id])
    @share = Share.new
  end

  def create
    user_email = params[:share][:email]
    @user = User.where("email = ?",user_email).first
    if @user.nil? #user is not registered
      UserMailer.invitation_mail(user_email,current_user.name).deliver_now
      @name = user_email
    else
      @name = @user.name
      UserMailer.shared_note_mail(user_email,current_user.name,@name).deliver_now
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
