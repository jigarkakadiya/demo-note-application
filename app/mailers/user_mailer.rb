# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def invitation_mail(user_email, name)
    @name = name
    mail(to: user_email, subject: 'Join NoteMe')
  end

  def shared_note_mail(user_mail, name, receiver_name)
    @receiver_name = receiver_name
    @name = name
    mail(to: user_mail, subject: 'New Shared Note')
  end

  def permission_mail(asker_name, shares_id, owner_name, note_name, owner_email)
    @asker_name = asker_name
    @shares_id = shares_id
    @owner_name = owner_name
    @note_name = note_name
    mail(to: owner_email, subject: 'Permission Requested')
  end
end
