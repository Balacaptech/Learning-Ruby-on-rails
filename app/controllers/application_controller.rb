class ApplicationController < ActionController::API
  helper_method:current_user  
  def current_user
     @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
