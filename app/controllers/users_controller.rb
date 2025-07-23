class UsersController < ApplicationController
  def new
  end

    def show_profile
    @user = User.find(session[:user_id]) rescue nil

    if @user.nil?
      redirect_to root_path, alert: "Please log in first"
    end
  end
end
