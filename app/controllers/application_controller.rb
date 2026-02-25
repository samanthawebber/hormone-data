class ApplicationController < ActionController::API
  before_action :set_current_user

  attr_reader :current_user
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def set_current_user
    token = bearer_token
    @current_user = token.present? ? User.find_by(api_token: token) : nil
  end

  def authenticate_user!
    return if current_user.present?

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def bearer_token
    auth_header = request.authorization.to_s
    return if auth_header.blank?

    scheme, token = auth_header.split(" ", 2)
    return unless scheme&.casecmp("Bearer")&.zero?

    token
  end

  def render_not_found
    render json: { error: "Not found" }, status: :not_found
  end
end
