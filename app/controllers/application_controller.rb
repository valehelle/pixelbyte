class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private 

  def after_sign_out_path_for(resource_or_scope)
      new_user_session_path
  end
  def after_sign_in_path_for(resource_or_scope)
      pages_path
  end
  def facebook_expiry
    if current_user.token_expiry_at.nil? || current_user.token_expiry_at < Time.now.to_i
        redirect_to user_facebook_omniauth_authorize_path
    end
  end
end
