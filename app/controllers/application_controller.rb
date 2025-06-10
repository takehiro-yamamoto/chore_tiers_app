class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

protected

# Deviseのサインイン後のリダイレクト先をカスタマイズ
def after_sign_in_path_for(resource)
    if session[:pending_invite_token]
      token = session.delete(:pending_invite_token)
      accept_invite_tier_lists_path(token: token)
    else
      super
    end
  end

# Deviseのサインアウト後のリダイレクト先をカスタマイズ
def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  devise_parameter_sanitizer.permit(:account_update, keys: [:name])
end

private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

end
