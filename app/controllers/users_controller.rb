class UsersController < ApplicationController
  before_action :authenticate_user!, only: :show

  def show
    render json: { user: user_payload(current_user) }
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: {
        user: user_payload(user),
        token: user.api_token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_payload(user)
    {
      id: user.id,
      email: user.email,
      anonymous_handle: user.anonymous_handle,
      created_at: user.created_at
    }
  end
end
