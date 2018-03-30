class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    @user.update_github_info(request.env["omniauth.auth"])
    sign_in_and_redirect @user
  end
end