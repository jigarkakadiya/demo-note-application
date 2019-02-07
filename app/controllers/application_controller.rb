class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def dashboard

  end

  def change_autosave
    @user = current_user
    @user.update(do_autosave: params[:status])
    redirect_to edit_user_registration_path
  end
  protected
  def configure_permitted_parameters
    added_attrs = [:name, :contact, :email, :password, :password_confirmation, :remember_me, :profile_photo]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :accept_invitation, keys: [:email]
  end

end
