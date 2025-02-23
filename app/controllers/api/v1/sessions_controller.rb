# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Devise::SessionsController
      skip_before_action :authenticate_user!, only: [:create]
      respond_to :json

      # before_action :configure_sign_in_params, only: [:create]

      # GET /resource/sign_in
      # def new
      #   super
      # end

      # POST /resource/sign_in
      def create
        super
      end

      # DELETE /resource/sign_out
      # def destroy
      #   super
      # end

      protected

      def respond_with(resource, _opts = {})
        serialized_data = UserSerializer.render(resource) 
        Rails.logger.debug("User logged in: #{serialized_data}")
        render json: serialized_data, status: :created
      end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_in_params
      #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
      # end
    end
  end
end
