class Api::V1::BaseController < ActionController::API
  include Pundit::Authorization
  before_action :authenticate_user!
  wrap_parameters format: [:json]

  respond_to :json

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
  end
end 