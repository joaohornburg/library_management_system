# frozen_string_literal: true

# class ApplicationController < ActionController::Base
# TODO: split in two once React is added.
class ApplicationController < ActionController::API
  include Pundit::Authorization

  before_action :authenticate_user!

  # TODO: Move this to a specifc ApiController, once this is split.
  respond_to :json

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
  end
end
