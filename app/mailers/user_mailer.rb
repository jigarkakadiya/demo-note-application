class UserMailer < ApplicationMailer
  def invitation_mail(user_email,name)
    @name = name
    mail(to: user_email,subject: "Join NoteMe")
  end

  def shared_note_mail(user_mail,name,receiver_name)
    @receiver_name = receiver_name
    @name = name
    mail(to: user_mail,subject: "New Shared Note")
  end
end
