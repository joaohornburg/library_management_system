# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      skip_before_action :authenticate_user!, only: [:create]

      # before_action :configure_sign_up_params, only: [:create]
      # before_action :configure_account_update_params, only: [:update]

      # GET /resource/sign_up
      # def new
      #   super
      # end

      # POST /resource
      def create
        Rails.logger.debug("Raw params: #{params.inspect}")
        Rails.logger.debug "Manual permit: #{params.require(:user).permit(:email, :password, :password_confirmation)}"
        Rails.logger.debug("Devise params: #{sign_up_params}")
        sanitized = devise_parameter_sanitizer.sanitize(:sign_up)
        Rails.logger.debug("Sanitized params: #{sanitized}")
        super
      end

      # GET /resource/edit
      # def edit
      #   super
      # end

      # PUT /resource
      # def update
      #   super
      # end

      # DELETE /resource
      # def destroy
      #   super
      # end

      # GET /resource/cancel
      # Forces the session data which is usually expired after sign
      # in to be expired now. This is useful if the user wants to
      # cancel oauth signing in/up in the middle of the process,
      # removing all OAuth session data.
      # def cancel
      #   super
      # end

      protected

      # Overriding to avoid issue with Devise::ParameterSanitizer - couldn't find the root cause of it.
      def sign_up_params
        # Explicitly ignoring param role, so that no user can register as a librarian.
        params.require(:user).permit(:email, :password, :password_confirmation)
      end

      def respond_with(resource, _opts = {})
        if resource.persisted?
          if (token = request.env['warden-jwt_auth.token'])
            response.headers['Authorization'] = "Bearer #{token}"
          end
          render json: UserSerializer.render(resource), status: :created
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_sign_up_params
      #   # devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation])
      # end

      # If you have extra params to permit, append them to the sanitizer.
      # def configure_account_update_params
      #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
      # end

      # The path used after sign up.
      # def after_sign_up_path_for(resource)
      #   super(resource)
      # end

      # The path used after sign up for inactive accounts.
      # def after_inactive_sign_up_path_for(resource)
      #   super(resource)
      # end
    end
  end
end
