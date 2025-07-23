module Api
  class SessionsController < ApplicationController
    

    def create
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        session[:user_id] = user.id
        render json: { message: "Login successful", user: user }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    def destroy
      reset_session  
      render json: { message: "Logged out successfully" }, status: :ok
    end
  end
end
