class SessionsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def create
    email = login_params[:email].to_s.strip.downcase
    user = User.find_by(email: email)

    if user&.authenticate(login_params[:password])
      user.regenerate_api_token
      render json: {
        user: {
          id: user.id,
          email: user.email,
          anonymous_handle: user.anonymous_handle
        },
        token: user.api_token
      }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    current_user.regenerate_api_token
    render json: { message: "Logged out" }, status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
