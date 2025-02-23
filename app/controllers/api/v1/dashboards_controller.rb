# frozen_string_literal: true

module Api
  module V1
    class DashboardsController < ApplicationController
      before_action :authenticate_user!

      def show
        dashboard_data = DashboardService.new(current_user).stats
        render json: dashboard_data
      end
    end
  end
end
