module Api
  class UsersController < ApplicationController
    include Rails.application.routes.url_helpers

    def index
      users = User.where(deleted: false)
      render json: users.map { |user| user_json(user) }, status: :ok
    end

    def show
      user = User.find_by(id: params[:id])
      if user && !user.deleted
        render json: user_json(user), status: :ok
      elsif user&.deleted
        render json: { error: "User is deleted" }, status: :not_found
      else
        render json: { error: "User not found" }, status: :not_found
      end
    end

   def create
    existing_user = User.find_by(email: params[:email])
    if existing_user
      render json: { error: "Email already registered" }, status: :unprocessable_entity
      return
    end

    user = User.new(user_params.except(:avatar))

    if user.save
      if params[:avatar].present?
        begin
          uploaded_file = params[:avatar]
          user.avatar.attach(
            io: uploaded_file,
            filename: uploaded_file.original_filename,
            content_type: uploaded_file.content_type
          )

          # ✅ Store public S3 URL in DB
          s3_url = "https://#{ENV['AWS_BUCKET_NAME'] || 'balamurugan17062025'}.s3.amazonaws.com/#{user.avatar.key}"
          user.update_column(:avatar_url, s3_url)
        rescue => e
          Rails.logger.error "Avatar upload failed: #{e.class} - #{e.message}"
          user.destroy
          render json: { error: "Avatar upload failed. Try another file." }, status: :unprocessable_entity
          return
        end
      end

    render json: { message: "User created successfully", user: user_json(user) }, status: :created
  else
    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  end
end

def update
  user = User.find_by(id: params[:id])
  return render json: { error: "User not found" }, status: :not_found unless user

  if user.update(user_params.except(:avatar))
    if params[:avatar].present?
      begin
        uploaded_file = params[:avatar]
        user.avatar.attach(
          io: uploaded_file,
          filename: uploaded_file.original_filename,
          content_type: uploaded_file.content_type
        )

        # ✅ Store public S3 URL in DB
        s3_url = "https://#{ENV['AWS_BUCKET_NAME'] || 'balamurugan17062025'}.s3.amazonaws.com/#{user.avatar.key}"
        user.update_column(:avatar_url, s3_url)
      rescue => e
        Rails.logger.error "Avatar upload failed: #{e.class} - #{e.message}"
        render json: { error: "Avatar upload failed. Try another file." }, status: :unprocessable_entity
        return
      end
    end

    render json: { message: "User updated successfully", user: user_json(user) }, status: :ok
  else
    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  end
end

    def destroy
      user = User.find_by(id: params[:id])
      if user.nil?
        render json: { status: 'error', message: 'User not found' }, status: :not_found
      elsif user.update_columns(deleted: true)
        render json: { status: 'success', message: 'User deleted successfully' }
      else
        render json: { status: 'error', message: 'Update failed', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.permit(:name, :email, :password, :password_confirmation, :mobile_number, :avatar)
    end

    def update_user_params
      params.permit(:name, :email, :mobile_number)
    end

  def user_json(user)
  {
    id: user.id,
    name: user.name,
    email: user.email,
    mobile_number: user.mobile_number,
    avatar_url: user.avatar_url
  }
end
end
end
