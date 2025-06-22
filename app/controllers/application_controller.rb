class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
    # ✅ Basic認証を常に有効にする（すべての環境で）
  before_action :basic_auth

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
def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
end

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

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]  # 環境変数を読み込む記述に変更
    end
  end

end
