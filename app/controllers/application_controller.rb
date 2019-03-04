# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :authenticate_admin_user!, if: :admin_controller?

  def dashboard; end

  def change_autosave
    current_user.update(do_autosave: params[:status])
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[name contact email password password_confirmation
                     remember_me profile_photo]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :accept_invitation, keys: [:email]
  end
end
