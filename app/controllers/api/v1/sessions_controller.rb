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

      # DELETE /resource/sign_out
      # def destroy
      #   super
      # end

      protected

      # We need to override this method because of the namespace of the API. Otherwise Devise will assume scope: :api_v1_user.
      def auth_options
        { scope: :user, recall: "#{controller_path}#new", locale: I18n.locale }
      end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_in_params
      #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
      # end
    end
  end
end
