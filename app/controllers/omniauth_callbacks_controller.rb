class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # google callback
  def google_oauth2
    auth = request.env['omniauth.auth']
    @user = User.create_from_google_data(auth)
    @user.access_token = auth.credentials.token
    @user.expires_at = auth.credentials.expires_at
    @user.refresh_token = auth.credentials.refresh_token
    @user.save!
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
    else
      flash[:error] = 'There was a problem signing you in through Google. Please register or try signing in later.'
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
