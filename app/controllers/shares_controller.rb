# frozen_string_literal: true

class SharesController < ApplicationController
  def index
    @notes = current_user.notes_shared_with_me
  end

  def shared_notes_with_me
    @notes = current_user.notes_shared_with_me
    @active = :shared_to_me
    @deactive = :shared_by_me
    respond_to do |format|
      format.js { render 'load_data.js.erb' }
    end
  end

  def shared_notes_by_me
    @notes = current_user.notes_shared_by_me.uniq
    @active = :shared_by_me
    @deactive = :shared_to_me
    respond_to do |format|
      @flag = 0
      format.js { render 'notes/load_data.js.erb' }
    end
  end

  def new
    @note = Note.find(params[:note_id])
    @share = Share.new
  end

  def create
    user_email = params[:share][:email]
    if user_email == current_user.email
      @flag = 'N'
      @name = current_user.name
    else
      @user = User.find_by(email: user_email).first
      if @user.nil? # user is not registered
        UserMailer.invitation_mail(user_email, current_user.name).deliver_now
        @name = user_email
      else
        @name = @user.name
        UserMailer.shared_note_mail(user_email, current_user.name, @name).deliver_now
      end
      @share = Share.new(share_data)
      @share.shared_by = current_user.id
      @flag = @share.save ? :Y : :N
    end
  end

  def ask_for_permission
    shares_id = params[:id]
    share = Share.find_by(id: shares_id)
    owner_email = share.email
    owner_name = User.find_by(id: share.shared_by).name
    note_name = Note.find_by(id: share.note_id)
    asker_name = current_user.name
    UserMailer.permission_mail(asker_name, shares_id, owner_name, note_name,
                               owner_email).deliver_now
  end

  def change_note_permission
    @share = Share.find_by(id: params[:id])
    @share.update(permission_id: 2)
  end

  private

  def share_data
    params.require(:share).permit(:note_id, :permission_id, :email)
  end
end
