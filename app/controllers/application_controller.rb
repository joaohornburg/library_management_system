# frozen_string_literal: true

# class ApplicationController < ActionController::Base
# TODO: split in two once React is added.
class ApplicationController < ActionController::API
  before_action :authenticate_user!

  # TODO: Move this to a specifc ApiController, once this is split.
  respond_to :json
end
